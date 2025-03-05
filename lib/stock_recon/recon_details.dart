// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';
import 'package:warehouse/Homepage%20Re-design/homepage.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/stock_recon/widget/dialog_widget.dart';
import 'package:warehouse/utils/utils.dart';
import 'package:warehouse/van_stock_take/layout/widget/modal.dart';

class ReconDetailPage extends StatefulWidget {
  const ReconDetailPage({
    super.key,
    required this.reconId,
    required this.status,
    required this.plannedClockOutDate,
  });

  final String reconId;
  final String status;
  final String plannedClockOutDate;

  @override
  State<ReconDetailPage> createState() => _ReconDetailPageState();
}

class _ReconDetailPageState extends State<ReconDetailPage> {
  static const String NOT_RECEIVED = 'NOT RECEIVED';
  static const String EXTRA = 'EXTRA';
  static const String OLD ='OLD';
  static const String DAMAGED ='DAMAGED';
  static const String RECALLED ='RECALLED';
  static const String EXTRA_OLD ='EXTRA(OLD)';
  static const String EXTRA_DAMAGED ='EXTRA(DAMAGED)';
  static const String EXTRA_RECALLED ='EXTRA(RECALLED)';

  static const String SALES_SUMMARY = 'Sales Summary';
  static const List<String> SALES_SUMMARY_HEADER = [
    'SKU ID',
    'UOM',
    'OPENING',
    'SALES',
    'FRESH',
    'CONSIGNMENT IN',
    'CONSIGNMENT OUT',
    'VAN ADHOC RETURN',
    'CLOSING',
  ];
  static const String SALES_RECON = 'Sales Reconcilation';
  static const List<String> SALES_RECON_HEADER = [
    'SKU ID',
    'UOM',
    'RECEIVED',
    'NOT RECEIVED',
    'EXTRA',
  ];
  static const String RETURN_SUMMARY = 'Return Summary';
  static const List<String> RETURN_SUMMARY_HEADER = [
    'SKU ID',
    'UOM',
    'OLD',
    'DAMAGED',
    'RECALLED',
  ];
  static const String RETURN_RECON = 'Return Reconcilation';
  static const List<String> RETURN_RECON_HEADER_MAIN = [
    'RECEIVED',
    'NOT RECEIVED',
  ];
  static const List<String> RETURN_RECON_HEADER = [
    'SKU ID',
    'UOM',
    'OLD',
    'DAMAGED',
    'RECALLED',
    'OLD',
    'EXTRA(OLD)',
    'DAMAGED',
    'EXTRA(DAMAGED)',
    'RECALLED',
    'EXTRA(RECALLED)',
  ];
  
  List<String> tableNames = [];
  List<List<Map<String,dynamic>>> tableContents = [];
  List<ScrollController> tableScrollsHorizontal = [];
  List<ScrollController> tableScrollsVertical = [];

  List<int> salesReconReceived = [];
  List<int> salesReconNotReceived = [];
  List<int> salesReconExtra = [];

  List<int> returnReconOld = [];
  List<int> returnReconDamaged = [];
  List<int> returnReconRecalled = [];

  List<int> returnReconOldNotReceived = [];
  List<int> returnReconOldExtra = [];

  List<int> returnReconDamagedNotReceived = [];
  List<int> returnReconDamagedExtra = [];

  List<int> returnReconRecalledNotReceived = [];
  List<int> returnReconRecalledExtra = [];

  List<List<int>> salesReconQty = [];
  List<List<int>> returnReconQty = [];

  final PageController _pageController = PageController();
  final NumberPaginatorController _paginatorController = NumberPaginatorController();

  final ScrollController _scrollController = ScrollController();
  final ScrollController salesSummaryControllerHorizontal = ScrollController();
  final ScrollController salesReconControllerHorizontal = ScrollController();
  final ScrollController returnSummaryControllerHorizontal = ScrollController();
  final ScrollController returnReconControllerHorizontal = ScrollController();
  final ScrollController salesSummaryControllerVertical = ScrollController();
  final ScrollController salesReconControllerVertical = ScrollController();
  final ScrollController returnSummaryControllerVertical = ScrollController();
  final ScrollController returnReconControllerVertical = ScrollController();

  List<TextEditingController> nullTextController = [];
  List<TextEditingController> notReceivedTextController = [];
  List<TextEditingController> extraTextController = [];
  List<TextEditingController> oldNotReceivedTextController = [];
  List<TextEditingController> oldExtraTextController = [];
  List<TextEditingController> damagedNotReceivedTextController = [];
  List<TextEditingController> damagedExtraTextController = [];
  List<TextEditingController> recalledNotReceivedTextController = [];
  List<TextEditingController> recalledExtraTextController = [];
  List<List<TextEditingController>> salesReconTextController = [];
  List<List<TextEditingController>> returnReconTextController = [];

  List<Map<String, dynamic>> details = [];
  List<Map<String, dynamic>> salesSummary = [];
  List<Map<String, dynamic>> salesReconcilation = [];
  List<Map<String, dynamic>> returnSummary = [];
  List<Map<String, dynamic>> returnReconcilation = [];
  Map<String, dynamic> allTables = {};
  int tableCount = 0;

  Map<String, dynamic> stockRecon = {};
  int activeStep = 0;
  
  bool _showReconDetails = false;
  bool _launchLoading = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    fetchUnacknowledgedData(widget.reconId).whenComplete(() => setState(() {
      _launchLoading = false;
    }));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _paginatorController.dispose();
    _scrollController.dispose();
    
    salesSummaryControllerHorizontal.dispose();
    salesReconControllerHorizontal.dispose();
    returnSummaryControllerHorizontal.dispose();
    returnReconControllerHorizontal.dispose();
    salesSummaryControllerVertical.dispose();
    salesReconControllerVertical.dispose();
    returnSummaryControllerVertical.dispose();
    returnReconControllerVertical.dispose();

    super.dispose();
  }

  Future<void> fetchUnacknowledgedData(String id) async {
    final String? token = await TokenUtil.getToken();
    final String? domainName = await TokenUtil.getDomainName();

    String url = '$domainName/api/reconciliation/wms/o/stock';
    if (token != null) {
      final apiUrl = url;
      final uri = Uri.parse('$apiUrl/$id');

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(
          () {
            stockRecon = jsonData["stock_recon"];
            salesSummary = List<Map<String, dynamic>>.from(
              jsonData["salesSummary"]
            );
            if (salesSummary.isNotEmpty) {
              tableCount = tableCount + 1;
              allTables.addEntries({ SALES_SUMMARY : [salesSummary, salesSummaryControllerHorizontal, salesSummaryControllerVertical]}.entries);
            }

            salesReconcilation = List<Map<String, dynamic>>.from(
              jsonData["salesReconcilation"]
            );
            if (salesReconcilation.isNotEmpty) {
              tableCount = tableCount + 1;
              allTables.addEntries({ SALES_RECON : [salesReconcilation, salesReconControllerHorizontal, salesReconControllerVertical]}.entries);

              for (var element in salesReconcilation) {
                salesReconReceived.add(element['quantity'][0]);
                salesReconNotReceived.add(element['quantity'][1]);
                salesReconExtra.add(element['quantity'][2]);

                notReceivedTextController.add(TextEditingController(text: element['quantity'][1].toString()));
                extraTextController.add(TextEditingController(text: element['quantity'][2].toString()));
              }

              salesReconQty = List.from([
                salesReconReceived,
                salesReconNotReceived,
                salesReconExtra,
              ]);

              salesReconTextController = List.from([
                nullTextController, //null
                notReceivedTextController,
                extraTextController,
              ]);
            }

            returnSummary = List<Map<String, dynamic>>.from(
              jsonData["returnSummary"]
            );
            if (returnSummary.isNotEmpty) {
              tableCount = tableCount + 1;
              allTables.addEntries({ RETURN_SUMMARY : [returnSummary, returnSummaryControllerHorizontal, returnSummaryControllerVertical]}.entries);
            }

            returnReconcilation = List<Map<String, dynamic>>.from(
              jsonData["returnReconcilation"]
            );
            if (returnReconcilation.isNotEmpty) {
              tableCount = tableCount + 1;
              allTables.addEntries({ RETURN_RECON : [returnReconcilation, returnReconControllerHorizontal, returnReconControllerVertical]}.entries);

              for (var element in returnReconcilation) {
                returnReconOld.add(element['quantity'][0]);
                returnReconDamaged.add(element['quantity'][1]);
                returnReconRecalled.add(element['quantity'][2]);
                returnReconOldNotReceived.add(element['quantity'][3]);
                returnReconOldExtra.add(element['quantity'][4]);
                returnReconDamagedNotReceived.add(element['quantity'][5]);
                returnReconDamagedExtra.add(element['quantity'][6]);
                returnReconRecalledNotReceived.add(element['quantity'][7]);
                returnReconRecalledExtra.add(element['quantity'][8]);

                oldNotReceivedTextController.add(TextEditingController(text: element['quantity'][3].toString()));
                oldExtraTextController.add(TextEditingController(text: element['quantity'][4].toString()));
                damagedNotReceivedTextController.add(TextEditingController(text: element['quantity'][5].toString()));
                damagedExtraTextController.add(TextEditingController(text: element['quantity'][6].toString()));
                recalledNotReceivedTextController.add(TextEditingController(text: element['quantity'][7].toString()));
                recalledExtraTextController.add(TextEditingController(text: element['quantity'][8].toString()));
              }

              returnReconQty = List.from([
                returnReconOld,
                returnReconDamaged,
                returnReconRecalled,
                returnReconOldNotReceived,
                returnReconOldExtra,
                returnReconDamagedNotReceived,
                returnReconDamagedExtra,
                returnReconRecalledNotReceived,
                returnReconRecalledExtra
              ]);

              returnReconTextController = List.from([
                nullTextController, //null
                nullTextController, //null
                nullTextController, //null
                oldNotReceivedTextController,
                oldExtraTextController,
                damagedNotReceivedTextController,
                damagedExtraTextController,
                recalledNotReceivedTextController,
                recalledExtraTextController
              ]);
            }
          },
        );

        allTables.forEach((key, value) {
          if (value != null) {
            tableNames.add(key);
            tableContents.add(value[0]);
            tableScrollsHorizontal.add(value[1]);
            tableScrollsVertical.add(value[2]);
          }
        },);

      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Token is null');
    }
  }

  Future<void> postDataToAPI() async {
    final String? token = await TokenUtil.getToken();
    if (token != null) {
    final String? domainName = await TokenUtil.getDomainName();

    String apiUrl = '$domainName/api/stock/wms/recon/receive';
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final data = {
        'stockRecons': [stockRecon['id']],
        'receivingSalesSku': salesReconcilation,
        'receivingReturnSku': returnReconcilation,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Request successful
        debugPrint('Data posted successfully');
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SuccessModal(
                content: 'Stock Recon Data Received.',
                title: 'Success',
                buttonText: 'Okay',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomepageV2()),
                  );
                },
              );
            });
      } else {
        // Request failed
        debugPrint(data.toString());

        debugPrint('Failed to post data');
        Navigator.pop(context);
        debugPrint(response.statusCode.toString());
        debugPrint(response.body);
      }
    } else {
      // Handle case where token is null
      debugPrint('Token is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          title: Text(
            'Stock Reconcilliation Lists',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: biruImran,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),

      body:
      Stack(
        children: [
          WillPopScope(
            onWillPop: () async {
              if (widget.status == 'ready') {
                bool willPop = false;
                willPop = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogConfirmation();
                  },
                );
          
                return willPop;
              }
          
              else {
                return true;
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 24.0, right: 20),
                      child: RichText(
                          text: TextSpan(
                            text: 'Home ',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                if (widget.status != 'ready') {
                                  Navigator.pop(context, false);
                                  Navigator.pop(context, false);
                                }
                                else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DialogConfirmation(toHome: true,);
                                    },
                                  );
            
                                }
                              },
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              color: textColorTertiary,
                            ),
                            children: [
                              TextSpan(
                                text: '> Stock Reconcilliation ',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    if (widget.status != 'ready') {
                                      Navigator.pop(context, false);
                                    }
                                    else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DialogConfirmation();
                                        },
                                      );
                                      
                                    }
                                  },
                              ),
                              TextSpan(
                                text: '> ${widget.reconId}',
                              ),
                            ],
                          ),
                        ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Recon Details',
                                style: TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                  color: biruImran,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _showReconDetails
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 30,
                                  color: biruImran,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showReconDetails = !_showReconDetails;
                                    // debugPrint(_showActionSummary);
                                  });
                                },
                              ),
                            ],
                          ),
                          Text(
                            'Planned Clock Out: ${widget.plannedClockOutDate.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w300,
                              color: textColorTertiary,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          _showReconDetails == false ?
                          InkWell(
                            onTap: () {
                              setState(() { 
                                _showReconDetails = !_showReconDetails;
                              });
                            },
                            child: Text(
                              'Show more',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w300,
                                color: textColorTertiary,
                              ),
                            ),
                          ):
                          
                          _launchLoading == true ?
                          Center(child: CircularProgressIndicator()) :
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 80.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        _buildInfoContainer(
                                          'Stock Recon ID',
                                          stockRecon['id'],
                                          Icons.info,
                                        ),
                                        _buildInfoContainer(
                                          'Van ID',
                                          stockRecon['van_id'],
                                          Icons.directions_car,
                                        ),
                                        _buildInfoContainer(
                                          'Sales Date',
                                          stockRecon['sales_date'],
                                          Icons.calendar_today,
                                        ),
                                        _buildInfoContainer(
                                          'Status',
                                          (stockRecon['status'] as String).capitalize(),
                                          Icons.assignment_turned_in_outlined,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        _buildInfoContainer(
                                          'Clock Out At',
                                          stockRecon['clocked_out'],
                                          Icons.timer,
                                        ),
                                        _buildInfoContainer(
                                          'Created By',
                                          stockRecon['created_by'],
                                          Icons.person,
                                        ),
                                        _buildInfoContainer(
                                          'Created At',
                                          stockRecon['createdAt'],
                                          Icons.access_time,
                                        ),
                                        _buildInfoContainer(
                                          'Updated At',
                                          stockRecon['updatedAt'],
                                          Icons.send,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (tableCount != 0)
                            SizedBox(
                              width: (MediaQuery.of(context).size.width / 7) * 4,
                              child: NumberPaginator(
                                initialPage: 0,
                                controller: _paginatorController,
                                contentBuilder: (index) {
                                  
                                  return Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        tableNames[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: biruImran,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                numberPages: tableCount,
                                onPageChange: (index) async {
                                  setState(() {
                                    activeStep = index;
                                    _pageController.animateToPage(
                                      activeStep,
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  });
                                },
                                config: NumberPaginatorUIConfig(
                                  buttonSelectedForegroundColor: white,
                                  buttonUnselectedForegroundColor: textColorTertiary,
                                  buttonSelectedBackgroundColor: biruImran,
                                ),
                                nextButtonContent: Icon(Icons.chevron_right, size: _responsiveFontSize() * 3,
                                  color: activeStep == tableCount - 1 ? greyColor : biruImran,),
                                prevButtonContent: Icon(Icons.chevron_left, size: _responsiveFontSize() * 3,
                                  color: activeStep == 0 ? greyColor : biruImran,),
                              ),
                            ),
                          const SizedBox(
                            height: 48,
                          ),
                          
                            
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.92,
                              child: PageView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    debugPrint('index');
                                    activeStep = index;
                                    _paginatorController.currentPage = index;
                                  });
                                },
                                itemCount: tableCount,
                                itemBuilder: (context, index) {
                            
                                  return _buildTables(
                                    title: tableNames[index],
                                    data: tableContents[index],
                                    horizontalScrollController: tableScrollsHorizontal[index],
                                    verticalScrollController: tableScrollsVertical[index]
                                  );
                                  // return Center(child: Text('data'),);
                                      
                                },
                              )
                            ),
                          ),
                            
                          const SizedBox(
                            height: 85,
                          ),
                          
                        ]
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
          
          Positioned(
            bottom: 24,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      if (widget.status != 'ready') {
                        Navigator.pop(context, false);
                      }
                      else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogConfirmation();
                          },
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      elevation: 10,
                      backgroundColor: biruImran4,
                    ),
                    child: const Text(
                      "Back",
                      style: TextStyle(
                        color: biruImran,
                        fontSize: 16
                      ),
                    ),
                  ),
                ),
                
                widget.status != 'ready' ?
                SizedBox() :
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextButton(
                    onPressed: () async {
                      bool _confirmReceive = false;
                      
                      _confirmReceive = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogReceiveConfirmation();
                        },
                      );
            
                      if (_confirmReceive) {
                        setState(() {
                          _isLoading = true;
                          postDataToAPI().then((value) => setState(() {
                            _isLoading = false;
                            FloatingSnackBar(
                              message: 'Stock received.',
                              context: context,
                            );
                            Navigator.pop(context, true);
                          }));
                        });
                      }
                      
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: hijauImran,
                      side: BorderSide(
                        color: Colors.transparent,
                      )
                    ),
                    child: Text(
                      'Receive',
                      style: TextStyle(
                        color: white,
                        fontSize: 16
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        
          _isLoading ? Opacity(opacity: 0.5,child: Container(
              color: white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator()),
              ),
            ) : SizedBox()
        ],
      ),

      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   debugPrint("SALES RECON : ${salesReconReceived.toString()}");
      //   debugPrint("SALES RECON : ${returnReconOld.toString()}");
      //   debugPrint("SALES RECON : ${returnReconDamaged.toString()}");
      //   debugPrint("SALES RECON : ${returnReconRecalled.toString()}");
      // }),
      
      ));
  }

  double _responsiveFontSize() {
    final screenWidth = MediaQuery.of(context).size.width;
    const maxResolution = 1200.0;
    const maxSize = 20.0;

    return (screenWidth / maxResolution) * maxSize;
  }

  Widget _buildTables({
    required String title,
    required List<Map<String,dynamic>> data,
    required ScrollController horizontalScrollController,
    required ScrollController verticalScrollController,
  }) {
    
    final dataQuantity = data[0]['quantity'];
    debugPrint('DATAQTY : ${dataQuantity.length}');
    
    final TextStyle _thisStyle = TextStyle(
      fontSize: _responsiveFontSize(),
      fontWeight: FontWeight.w400,
      color: biruImran,
    );

    return _launchLoading == true ? Center(child: CircularProgressIndicator()) :
      RawScrollbar(
        radius: Radius.circular(10),
        thickness: 8,
        thumbColor: biruImran2,
        thumbVisibility: true,
        controller: verticalScrollController,
        child: RawScrollbar(
          scrollbarOrientation: ScrollbarOrientation.top,
          radius: Radius.circular(10),
          thickness: 8,
          thumbColor: biruImran2,
          thumbVisibility: true,
          controller: horizontalScrollController,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10),
            child: TableView.builder(
              verticalDetails: ScrollableDetails.vertical(
                controller: verticalScrollController,
              ),
              horizontalDetails: ScrollableDetails.horizontal(
                controller: horizontalScrollController,
              ),
              cellBuilder: (context, vicinity) {
                return _buildCell(context, vicinity, data, type: title, textStyle: _thisStyle);
              },
              columnCount: (dataQuantity.length) + 2,
              columnBuilder: _buildColumnSpan,
              rowCount: (data.length) + 1,
              rowBuilder: _buildRowSpan,
            ),
          ),
        ),
      );
  }

  Widget _buildInfoContainer(String label, dynamic value, IconData icon) {
    String formattedValue = '';

    if (value is DateTime) {
      formattedValue = DateFormat.yMMMd().add_jm().format(value);

    } else if (value is String && DateTime.tryParse(value) != null) {
      
      DateTime dateTimeValue = DateTime.parse(value).add(Duration(hours: int.parse('8')));
      formattedValue = DateFormat.yMMMd().add_jm().format(dateTimeValue);

    } else {
      formattedValue = value.toString();
    }

    return ListTile(
      leading: Icon(
        icon,
        color: biruImran,
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: biruImran
        ),
      ),
      subtitle: Text(
        formattedValue,
        style: TextStyle(color: black),
      ),
    );
  }

  TableViewCell _buildCell(BuildContext context, TableVicinity vicinity, List<Map<String,dynamic>> data, {
    required String type,
    required TextStyle textStyle,
  }) {
    List<String> header = [];

    switch (type) {
      case SALES_SUMMARY:
        header = List.from(SALES_SUMMARY_HEADER);
        break;
      case SALES_RECON:
        header = List.from(SALES_RECON_HEADER);
        break;
      case RETURN_SUMMARY:
        header = List.from(RETURN_SUMMARY_HEADER);
        break;
      case RETURN_RECON:
        header = List.from(RETURN_RECON_HEADER);
        break;
      default:
    }

    Container fixedDataContainer({required Widget child}) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: 30,
        color: biruImran3,
        child: Opacity(
          opacity: .7,
          child: child,
        )
      );
    }
    
    return TableViewCell(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text('Tile v: ${vicinity.column}, r: ${vicinity.row}'),
              if(vicinity.row == 0)
                AutoSizeText(
                  header[vicinity.column],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
          
                  minFontSize: 1,
                  maxLines: 1,
                ),
          
              if(vicinity.row != 0 && vicinity.column == 0)
                fixedDataContainer(
                  child: AutoSizeText(
                    data[(vicinity.row) -1]['sku_id'],
                    style: textStyle,
                            
                    minFontSize: 1,
                    maxLines: 1,
                  ),
                ),
          
              if(vicinity.row != 0 && vicinity.column == 1)
                fixedDataContainer(
                  child: AutoSizeText(
                    data[(vicinity.row) -1]['uom_id'],
                    style: textStyle,
                            
                    minFontSize: 1,
                    maxLines: 1,
                  ),
                ),
          
              if(vicinity.row != 0 && vicinity.column > 1)
               type == SALES_RECON && vicinity.column >= 3 && widget.status == 'ready' ?
                  TextFormField(
                    controller: salesReconTextController[(vicinity.column) - 2][(vicinity.row) -1],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      isDense: true,
                      border: InputBorder.none,
                    ),
                    style: textStyle,
                    keyboardType: TextInputType.number,
                    // initialValue:
                    //     data[(vicinity.row) -1]['quantity'][(vicinity.column) - 2]?.toString() ?? '0',
                    onChanged: (value) {
                      if (value.isEmpty) {
                        salesReconTextController[(vicinity.column) - 2][(vicinity.row) -1].text = (salesReconQty[(vicinity.column) - 2][(vicinity.row) -1]).toString();
                        value = '0';
                      }
                      
                      final int inputQty = int.parse(value);
                      salesReconTextController[(vicinity.column) - 2][(vicinity.row) -1].text = inputQty.toString();

                      int newQty = 0;

                      if (inputQty < 0) {
                        FloatingSnackBar(message: 'Cannot place numbers less than 0.', context: context, backgroundColor: category4Color);
                        FocusManager.instance.primaryFocus?.unfocus();

                        setState(() {
                          data[(vicinity.row) -1]['quantity'][0] = salesReconQty[0][(vicinity.row) -1];
                          salesReconTextController[1][(vicinity.row) -1].text = (salesReconQty[1][(vicinity.row) -1]).toString();
                          salesReconTextController[2][(vicinity.row) -1].text = (salesReconQty[2][(vicinity.row) -1]).toString();
                        });

                        return;
                        
                      } else if (inputQty > salesReconQty[0][(vicinity.row) -1]) {
                        FloatingSnackBar(message: 'Input exceeds received quantity.', context: context, backgroundColor: category4Color);
                        FocusManager.instance.primaryFocus?.unfocus();
                        
                        setState(() {
                          data[(vicinity.row) -1]['quantity'][0] = salesReconQty[0][(vicinity.row) -1];
                          salesReconTextController[1][(vicinity.row) -1].text = (salesReconQty[1][(vicinity.row) -1]).toString();
                          salesReconTextController[2][(vicinity.row) -1].text = (salesReconQty[2][(vicinity.row) -1]).toString();
                        });

                        return;

                      } else if (header[vicinity.column] == NOT_RECEIVED) {
                        final int extra = int.parse(salesReconTextController[2][(vicinity.row) -1].text);
                        newQty = salesReconQty[0][(vicinity.row) -1] - inputQty + extra;

                      } else if (header[vicinity.column] == EXTRA) {
                        final int notReceived = int.parse(salesReconTextController[1][(vicinity.row) -1].text);
                        newQty = salesReconQty[0][(vicinity.row) -1] - notReceived + inputQty;

                      }

                      if (newQty > salesReconQty[0][(vicinity.row) -1] || newQty < 0) {
                        FloatingSnackBar(message: 'New calculated Received quantity cannot exceed original Received quantity.', context: context, backgroundColor: category4Color);
                        FocusManager.instance.primaryFocus?.unfocus();
                        
                        setState(() {
                          data[(vicinity.row) -1]['quantity'][0] = salesReconQty[0][(vicinity.row) -1];
                          salesReconTextController[1][(vicinity.row) -1].text = (salesReconQty[1][(vicinity.row) -1]).toString();
                          salesReconTextController[2][(vicinity.row) -1].text = (salesReconQty[2][(vicinity.row) -1]).toString();
                        });

                        return;
                      }

                      setState(() {
                        data[(vicinity.row) -1]['quantity'][0] = newQty;
                        // data[(vicinity.row) -1]['quantity'][(vicinity.column) - 2] = inputQty;
                      });
                      

                    },
                  )
               : type == RETURN_RECON && vicinity.column >= 5 && widget.status == 'ready' ?
                  TextFormField(
                    controller: returnReconTextController[(vicinity.column) - 2][(vicinity.row) - 1],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      isDense: true,
                      border: InputBorder.none,
                    ),
                    style: textStyle,
                    keyboardType: TextInputType.number,
                    // initialValue:
                    //     data[(vicinity.row) -1]['quantity'][(vicinity.column) - 2]?.toString() ?? '0',
                    onChanged: (value) {
                      if (value.isEmpty) {
                        returnReconTextController[(vicinity.column) - 2][(vicinity.row) -1].text = (returnReconQty[(vicinity.column) - 2][(vicinity.row) -1]).toString();
                        value = '0';
                      }
                      
                      final int inputQty = int.parse(value);
                      returnReconTextController[(vicinity.column) - 2][(vicinity.row) -1].text = inputQty.toString();

                      int newQtyOld = data[(vicinity.row) -1]['quantity'][0];
                      int newQtyDamaged = data[(vicinity.row) -1]['quantity'][1];
                      int newQtyRecalled = data[(vicinity.row) -1]['quantity'][2];

                      bool checkInput(int index) {
                        if (inputQty > returnReconQty[index][(vicinity.row) -1]) {
                          FloatingSnackBar(message: 'Input exceeds received quantity.', context: context, backgroundColor: category4Color);
                          FocusManager.instance.primaryFocus?.unfocus();
                          
                          setState(() {
                            data[(vicinity.row) -1]['quantity'][index] = returnReconQty[index][(vicinity.row) -1];
                            
                            returnReconTextController[index * 2 + 3][(vicinity.row) -1].text = (returnReconQty[3][(vicinity.row) -1]).toString();
                            returnReconTextController[index * 2 + 4][(vicinity.row) -1].text = (returnReconQty[4][(vicinity.row) -1]).toString();
                          });

                          return true;
                        }
                        return false;
                      }

                      if (inputQty < 0) {
                        FloatingSnackBar(message: 'Cannot place numbers less than 0.', context: context, backgroundColor: category4Color);
                        FocusManager.instance.primaryFocus?.unfocus();

                        setState(() {
                          data[(vicinity.row) -1]['quantity'][0] = returnReconQty[0][(vicinity.row) -1];
                          data[(vicinity.row) -1]['quantity'][1] = returnReconQty[1][(vicinity.row) -1];
                          data[(vicinity.row) -1]['quantity'][2] = returnReconQty[2][(vicinity.row) -1];
                          returnReconTextController[3][(vicinity.row) -1].text = (returnReconQty[3][(vicinity.row) -1]).toString();
                          returnReconTextController[4][(vicinity.row) -1].text = (returnReconQty[4][(vicinity.row) -1]).toString();
                          returnReconTextController[5][(vicinity.row) -1].text = (returnReconQty[5][(vicinity.row) -1]).toString();
                          returnReconTextController[6][(vicinity.row) -1].text = (returnReconQty[6][(vicinity.row) -1]).toString();
                          returnReconTextController[7][(vicinity.row) -1].text = (returnReconQty[7][(vicinity.row) -1]).toString();
                          returnReconTextController[8][(vicinity.row) -1].text = (returnReconQty[8][(vicinity.row) -1]).toString();
                        });

                        return;
                        
                      } else if (header[vicinity.column] == OLD) {
                        if (checkInput(0)) return;
                        
                        final int extra = int.parse(returnReconTextController[4][(vicinity.row) -1].text);
                        newQtyOld = returnReconQty[0][(vicinity.row) -1] - inputQty + extra;

                        debugPrint('CALC ERROR : ${extra.toString()}');
                        debugPrint('CALC ERROR : ${inputQty.toString()}');
                        debugPrint('CALC ERROR : ${returnReconQty[0][(vicinity.row) -1].toString()}');
                        debugPrint('CALC ERROR : ${newQtyOld.toString()}');

                      } else if (header[vicinity.column] == EXTRA_OLD) {
                        if (checkInput(0)) return;
                        
                        final int old = int.parse(returnReconTextController[3][(vicinity.row) -1].text);
                        newQtyOld = returnReconQty[0][(vicinity.row) -1] - old + inputQty;
                        
                        debugPrint('CALC ERROR OLD : ${inputQty.toString()}');
                        debugPrint('CALC ERROR OLD : ${old.toString()}');
                        debugPrint('CALC ERROR OLD : ${returnReconQty[0][(vicinity.row) -1].toString()}');
                        debugPrint('CALC ERROR OLD : ${newQtyOld.toString()}');

                      } else if (header[vicinity.column] == DAMAGED) {
                        if (checkInput(1)) return;
                        
                        final int extra = int.parse(returnReconTextController[6][(vicinity.row) -1].text);
                        newQtyDamaged = returnReconQty[1][(vicinity.row) -1] - inputQty + extra;

                      } else if (header[vicinity.column] == EXTRA_DAMAGED) {
                        if (checkInput(1)) return;
                        
                        final int damaged = int.parse(returnReconTextController[5][(vicinity.row) -1].text);
                        newQtyDamaged = returnReconQty[1][(vicinity.row) -1] - damaged + inputQty;

                      } else if (header[vicinity.column] == RECALLED) {
                        if (checkInput(2)) return;
                        
                        final int extra = int.parse(returnReconTextController[8][(vicinity.row) -1].text);
                        newQtyRecalled = returnReconQty[2][(vicinity.row) -1] - inputQty + extra;

                      } else if (header[vicinity.column] == EXTRA_RECALLED) {
                        if (checkInput(2)) return;
                        
                        final int recalled = int.parse(returnReconTextController[7][(vicinity.row) -1].text);
                        newQtyRecalled = returnReconQty[2][(vicinity.row) -1] - recalled + inputQty;

                      }

                      if (
                        (newQtyOld > returnReconQty[0][(vicinity.row) -1] || newQtyOld < 0) ||
                        (newQtyDamaged > returnReconQty[1][(vicinity.row) -1] || newQtyDamaged < 0) ||
                        (newQtyRecalled > returnReconQty[2][(vicinity.row) -1] || newQtyRecalled < 0)
                      ) {
                        FloatingSnackBar(message: 'New calculated Received quantity cannot exceed original Received quantity.', context: context, backgroundColor: category4Color);
                        FocusManager.instance.primaryFocus?.unfocus();
                        
                        setState(() {
                          data[(vicinity.row) -1]['quantity'][0] = returnReconQty[0][(vicinity.row) -1];
                          data[(vicinity.row) -1]['quantity'][1] = returnReconQty[1][(vicinity.row) -1];
                          data[(vicinity.row) -1]['quantity'][2] = returnReconQty[2][(vicinity.row) -1];
                          returnReconTextController[3][(vicinity.row) -1].text = (returnReconQty[3][(vicinity.row) -1]).toString();
                          returnReconTextController[4][(vicinity.row) -1].text = (returnReconQty[4][(vicinity.row) -1]).toString();
                          returnReconTextController[5][(vicinity.row) -1].text = (returnReconQty[5][(vicinity.row) -1]).toString();
                          returnReconTextController[6][(vicinity.row) -1].text = (returnReconQty[6][(vicinity.row) -1]).toString();
                          returnReconTextController[7][(vicinity.row) -1].text = (returnReconQty[7][(vicinity.row) -1]).toString();
                          returnReconTextController[8][(vicinity.row) -1].text = (returnReconQty[8][(vicinity.row) -1]).toString();
                        });

                        return;
                      }

                      setState(() {
                        data[(vicinity.row) -1]['quantity'][0] = newQtyOld;
                        data[(vicinity.row) -1]['quantity'][1] = newQtyDamaged;
                        data[(vicinity.row) -1]['quantity'][2] = newQtyRecalled;
                      });

                    },
                  )
                : //else
                  fixedDataContainer(
                    child: AutoSizeText(
                      data[(vicinity.row) -1]['quantity'][(vicinity.column) - 2].toString(),
                      style: textStyle,
                                
                      minFontSize: 1,
                      maxLines: 1,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  TableSpan _buildColumnSpan(int index) {
    const TableSpanDecoration decoration = TableSpanDecoration(
      border: TableSpanBorder(
        trailing: BorderSide(
          width: 1,
          color: biruImran2
        ),
      ),
    );

    return TableSpan(
      foregroundDecoration: decoration,
      extent: const FractionalTableSpanExtent(.2),
      onEnter: (_) => print('Entered column $index'),
      recognizerFactories: <Type, GestureRecognizerFactory>{
        TapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(),
          (TapGestureRecognizer t) =>
              t.onTap = () => print('Tap column $index'),
        ),
      },
    );
  }

  TableSpan _buildRowSpan(int index) {
    final TableSpanDecoration decoration = TableSpanDecoration(
      color: index == 0 ? biruImran : null,
      border: const TableSpanBorder(
        trailing: BorderSide(
          width: 1,
          color: biruImran2
        ),
      ),
    );

    return TableSpan(
      backgroundDecoration: decoration,
      extent: const FixedTableSpanExtent(50),
      recognizerFactories: <Type, GestureRecognizerFactory>{
        TapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(),
          (TapGestureRecognizer t) =>
              t.onTap = () => print('Tap row $index'),
        ),
      },
    );
  }

  
}
