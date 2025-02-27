// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:warehouse/Homepage%20Re-design/homepage.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/stock_recon/widget/dialog_widget.dart';
import 'package:warehouse/utils/color.dart';
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
  final List<String> _tableNames = [
    'Inventory Details',
    'Sales Details',
    'Return Summary',
    'Physical Quantity',
  ];
  final PageController _pageController = PageController();
  final NumberPaginatorController _paginatorController =
      NumberPaginatorController();

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollInventoryController = ScrollController();
  final ScrollController _scrollSalesController = ScrollController();
  final ScrollController _scrollSummaryController = ScrollController();
  final ScrollController _scrollQuantityController = ScrollController();

  List<Map<String, dynamic>> details = [];
  List<Map<String, dynamic>> returnSummary = [];
  List<Map<String, dynamic>> salesSummary = [];
  List<Map<String, dynamic>> returnReconciliation = [];
  List<Map<String, dynamic>> salesReconcilation = [];

  Map<String, dynamic> stockRecon = {};
  int activeStep = 0;
  
  bool _showReconDetails = true;
  bool _launchLoading = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    fetchUnacknowledgedData(widget.reconId).then((value) => setState(() {
      _launchLoading = false;
    }));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _paginatorController.dispose();
    _scrollController.dispose();
    _scrollInventoryController.dispose();
    _scrollSalesController.dispose();
    _scrollSummaryController.dispose();
    _scrollQuantityController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> fetchUnacknowledgedData(String id) async {
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
            salesSummary =
                List<Map<String, dynamic>>.from(jsonData["salesSummary"]);
            returnReconciliation = List<Map<String, dynamic>>.from(
                jsonData["returnReconcilation"]);
            returnSummary =
                List<Map<String, dynamic>>.from(jsonData["returnSummary"]);
            salesReconcilation =
                List<Map<String, dynamic>>.from(jsonData["salesReconcilation"]);
          },
        );
        return jsonData;
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
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Request successful
        print('Data posted successfully');
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
        print(data);

        print('Failed to post data');
        Navigator.pop(context);
        print(response.statusCode);
        print(response.body);
      }
    } else {
      // Handle case where token is null
      print('Token is null');
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
                    child: RawScrollbar(
                      radius: Radius.circular(10),
                      thickness: 8,
                      thumbColor: biruImran4,
                      thumbVisibility: true,
                      controller: _scrollController,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
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
                                        // print(_showActionSummary);
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
                              SizedBox(
                                width: (MediaQuery.of(context).size.width / 7) * 4,
                                child: NumberPaginator(
                                  controller: _paginatorController,
                                  contentBuilder: (index) => Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        index == 2 ?
                                          returnSummary.isNotEmpty ?
                                            _tableNames[index] :
                                            _tableNames[index+1] :
                                          _tableNames[index]
                                        ,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: biruImran,
                                        ),
                                      ),
                                    ),
                                  ),
                                  numberPages: 3,
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
                                    color: activeStep == 2 ? greyColor : biruImran,),
                                  prevButtonContent: Icon(Icons.chevron_left, size: _responsiveFontSize() * 3,
                                    color: activeStep == 0 ? greyColor : biruImran,),
                                ),
                              ),
                              const SizedBox(
                                height: 48,
                              ),
                              
          
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.92,
                                height: MediaQuery.of(context).size.height * 0.3,
                                child: PageView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      print('index');
                                      activeStep = index;
                                      _paginatorController.currentPage = index;
                                    });
                                  },
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    final double _tableWidth = MediaQuery.of(context).size.width * 0.9;
                                    final TextStyle _thisStyle = TextStyle(
                                      fontSize: _responsiveFontSize(),
                                      fontWeight: FontWeight.w400,
                                      color: biruImran,
                                    );
          
          
                                    if (index == 0) {
                                      return _buildInventoryTable(_tableWidth,_thisStyle);
                                    }
                                    if (index == 1) {
                                      return _buildSalesTable(_tableWidth,_thisStyle); 
                                    }
                                    
                                    else {
                                      return
                                      widget.status == 'ready' || widget.status == 'received' ?
                                        _buildQuantityTable(_tableWidth, _thisStyle) :  
                                        _buildSummaryTable(_tableWidth, _thisStyle);
                                    }
                                  },
                                )
                              ),
                                      
                              const SizedBox(
                                height: 12,
                              ),
          
                              Row(
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
                                        if (activeStep == 2) {
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
                                        }
                                        
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: activeStep == 2 ? hijauImran : Colors.transparent,
                                        side: BorderSide(
                                          color: activeStep == 2 ? Colors.transparent : greyColor,
                                        )
                                      ),
                                      child: Text(
                                        'Receive',
                                        style: TextStyle(
                                          color: activeStep == 2 ? white : greyColor,
                                          fontSize: 16
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 150,
                              ),
                            ]
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                ],
              ),
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
      )));
  }

  double _responsiveFontSize() {
    final screenWidth = MediaQuery.of(context).size.width;
    const maxResolution = 1200.0;
    const maxSize = 20.0;

    return (screenWidth / maxResolution) * maxSize;
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

  Widget _buildInventoryTable(double tableWidth, TextStyle thisStyle) {
    
    return
    _launchLoading == true ?
    Center(child: CircularProgressIndicator()) :
    RawScrollbar(
      radius: Radius.circular(10),
      thickness: 8,
      thumbColor: biruImran4,
      thumbVisibility: true,
      controller: _scrollInventoryController,
      child: SingleChildScrollView(
        controller: _scrollInventoryController,
        child: Column(
          children: [
            SizedBox(
              width: tableWidth,
              child: DataTable(
                dataRowMaxHeight: 60.0,
                border: TableBorder(
                  horizontalInside: BorderSide(
                      width: 1, color: biruImran2, style: BorderStyle.solid),
                  verticalInside: BorderSide(
                      width: 1, color: biruImran2, style: BorderStyle.solid),
                ),
                headingRowColor: MaterialStateProperty.all(biruImran),
                headingTextStyle: TextStyle(
                  fontSize: _responsiveFontSize(),
                  fontWeight: FontWeight.bold,
                  color: white,
                ),
                columns: [
                  DataColumn(
                    label: Text(
                      'SKU ID',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'UOM',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Opening',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Sales',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Fresh',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Closing',
                    ),
                  ),
                ],
                rows: salesSummary.isEmpty ?
                [DataRow(cells: [
                  DataCell(Text('N/A', style: thisStyle,)),
                  DataCell(Text('N/A', style: thisStyle,)),
                  DataCell(Text('N/A', style: thisStyle,)),
                  DataCell(Text('N/A', style: thisStyle,)),
                  DataCell(Text('N/A', style: thisStyle,)),
                  DataCell(Text('N/A', style: thisStyle,)),
                ])] :
                salesSummary.asMap().entries.map((entry) {
                  final details = entry.value;
                  
                  return DataRow(
                    cells: [
                      DataCell(Text(details['sku_id'] ?? 'N/A', style: thisStyle,)),
                      DataCell(Text(details['uom_id'] ?? 'N/A', style: thisStyle,)),
                      DataCell(Text('${details['quantity'][0] ?? 'N/A'}', style: thisStyle,)),
                      DataCell(Text('${details['quantity'][1] ?? 'N/A'}', style: thisStyle,)),
                      DataCell(Text('${details['quantity'][2] ?? 'N/A'}', style: thisStyle,)),
                      DataCell(Text('${details['quantity'][6] ?? 'N/A'}', style: thisStyle,)),
                    ],
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  Widget _buildSalesTable(double tableWidth, TextStyle thisStyle) {

    return
    _launchLoading == true ?
    Center(child: CircularProgressIndicator()) :
    RawScrollbar(
      radius: Radius.circular(10),
      thickness: 8,
      thumbColor: biruImran4,
      thumbVisibility: true,
      controller: _scrollSalesController,
      child: SingleChildScrollView(
        controller: _scrollSalesController,
        child: Column(
          children: [
            SizedBox(
              width: tableWidth,
              child: DataTable(
                dataRowMaxHeight: 60.0,
                border: TableBorder(
                  horizontalInside: BorderSide(
                      width: 1, color: biruImran2, style: BorderStyle.solid),
                  verticalInside: BorderSide(
                      width: 1, color: biruImran2, style: BorderStyle.solid),
                ),
                headingRowColor: MaterialStateProperty.all(biruImran),
                headingTextStyle: TextStyle(
                  fontSize: _responsiveFontSize(),
                  fontWeight: FontWeight.bold,
                  color: white,
                ),
                columns: [
                  DataColumn(
                    label: Text(
                      'SKU ID',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Consignment\nIn',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Consignment\nOut',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Van Adhoc Return',
                    ),
                  ),
                ],
                rows: salesSummary.isEmpty ?
                [DataRow(cells: [
                  DataCell(Text('N/A', style: thisStyle,)),
                  DataCell(Text('N/A', style: thisStyle,)),
                  DataCell(Text('N/A', style: thisStyle,)),
                  DataCell(Text('N/A', style: thisStyle,)),
                ])] :
                salesSummary.asMap().entries.map((entry) {
                  final details = entry.value;
                          
                  return DataRow(
                    cells: [
                      DataCell(Text(details['sku_id'] ?? 'N/A', style: thisStyle,)),
                      DataCell(Text('${details['quantity'][3] ?? 'N/A'}', style: thisStyle,)),
                      DataCell(Text('${details['quantity'][4] ?? 'N/A'}', style: thisStyle,)),
                      DataCell(Text('${details['quantity'][5] ?? 'N/A'}', style: thisStyle,)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSummaryTable(double tableWidth, TextStyle thisStyle) {
    
    return
    _launchLoading == true ?
    Center(child: CircularProgressIndicator()) :
    RawScrollbar(
      radius: Radius.circular(10),
      thickness: 8,
      thumbColor: biruImran4,
      thumbVisibility: true,
      controller: _scrollSummaryController,
      child: SingleChildScrollView(
        controller: _scrollSummaryController,
        child: Column(
          children: [
            SizedBox(
              width: tableWidth,
              child: DataTable(
                dataRowMaxHeight: 60.0,
                border: TableBorder(
                  horizontalInside: BorderSide(
                      width: 1, color: biruImran2, style: BorderStyle.solid),
                  verticalInside: BorderSide(
                      width: 1, color: biruImran2, style: BorderStyle.solid),
                ),
                headingRowColor: MaterialStateProperty.all(biruImran),
                headingTextStyle: TextStyle(
                  fontSize: _responsiveFontSize(),
                  fontWeight: FontWeight.bold,
                  color: white,
                ),
                columns: [
                  DataColumn(
                    label: Text(
                      'SKU ID',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'UOM',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Old',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Damaged',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Recalled',
                    ),
                  ),
                ],
                
                rows: returnSummary.isEmpty ?
                [DataRow(cells: [
                  DataCell(Text('N/A', style: thisStyle,)),
                  DataCell(Text('N/A', style: thisStyle,)),
                  DataCell(Text('N/A', style: thisStyle,)),
                  DataCell(Text('N/A', style: thisStyle,)),
                  DataCell(Text('N/A', style: thisStyle,)),
                ])] :
                returnSummary.asMap().entries.map((entry) {
                  final details = entry.value;
                    
                  return DataRow(
                    cells: [
                      DataCell(Text(details['sku_id'] ?? 'N/A', style: thisStyle,)),
                      DataCell(Text(details['uom_id'] ?? 'N/A', style: thisStyle,)),
                      DataCell(Text('${details['quantity'][0] ?? 'N/A'}', style: thisStyle,)),
                      DataCell(Text('${details['quantity'][1] ?? 'N/A'}', style: thisStyle,)),
                      DataCell(Text('${details['quantity'][2] ?? 'N/A'}', style: thisStyle,)),
                    ],
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  Widget _buildQuantityTable(double tableWidth, TextStyle thisStyle) {
    
    return
    _launchLoading == true ?
    Center(child: CircularProgressIndicator()) :
    RawScrollbar(
      radius: Radius.circular(10),
      thickness: 8,
      thumbColor: biruImran4,
      thumbVisibility: true,
      controller: _scrollQuantityController,
      child: SingleChildScrollView(
        controller: _scrollQuantityController,
        child: Column(
          children: [
            SizedBox(
              width: tableWidth,
              child: DataTable(
                dataRowMaxHeight: 60.0,
                border: TableBorder(
                  horizontalInside: BorderSide(
                      width: 1, color: biruImran2, style: BorderStyle.solid),
                  verticalInside: BorderSide(
                      width: 1, color: biruImran2, style: BorderStyle.solid),
                ),
                headingRowColor: MaterialStateProperty.all(biruImran),
                headingTextStyle: TextStyle(
                  fontSize: _responsiveFontSize(),
                  fontWeight: FontWeight.bold,
                  color: white,
                ),
                columns: [
                  DataColumn(
                    label: Text(
                      'SKU ID',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'UOM',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Received',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Not Received',
                    ),
                  ),
                ],
                
                rows: salesReconcilation.isEmpty ?
                [DataRow(cells: [
                  DataCell(Text('N/A', style: thisStyle,)),
                  DataCell(Text('N/A', style: thisStyle,)),
                  DataCell(Text('N/A', style: thisStyle,)),
                  DataCell(Text('N/A', style: thisStyle,)),
                ])] :
                salesReconcilation.asMap().entries.map((entry) {
                  final details = entry.value;

                  return DataRow(
                      cells: [
                        DataCell(Text(details['sku_id'] ?? 'N/A', style: thisStyle,)),
                        DataCell(Text(details['uom_id'] ?? 'N/A', style: thisStyle,)),
                        DataCell(
                          widget.status == "ready" ?
                            TextFormField(
                              style: thisStyle,
                              initialValue:
                                  details['quantity'][0]?.toString() ??
                                      '0',
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                // Update the received quantity
                                setState(() {
                                  details['quantity'][0] =
                                      int.parse(value);
                                });
                              },
                            ) :
                            Text(details['quantity'][0]?.toString() ?? 'N/A', style: thisStyle,),
                        ),
                        DataCell(
                          widget.status == "ready" ?
                            TextFormField(
                              style: thisStyle,
                              initialValue:
                                  details['quantity'][1]?.toString() ??
                                      '0',
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                // Update the not received quantity
                                setState(() {
                                  details['quantity'][1] =
                                      int.parse(value);
                                  print(salesReconcilation);
                                  print([stockRecon["id"]]);
                                });
                              },
                            ) :
                            Text(details['quantity'][1]?.toString() ?? 'N/A', style: thisStyle,),
                        ),
                      ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
