// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables, deprecated_member_use, unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';

import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';
import 'package:warehouse/van_allotment/widgets/dialog_widget.dart';

class AdhocRequestDetailView extends StatefulWidget {
  const AdhocRequestDetailView({
    super.key,
    required this.referenceId,
    required this.status,
  });

  final String referenceId;
  final String status;

  @override
  State<AdhocRequestDetailView> createState() => _AdhocRequestDetailViewState();
}

class _AdhocRequestDetailViewState extends State<AdhocRequestDetailView> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  String referenceId = '';
  String actionTitleAt = '';
  String actionTitleBy = '';
  String actionBy = '';
  String actionAt = '';

  List<Map<String, dynamic>> allotments = [];
  List<Map<String, dynamic>> details = [];
  List<Map<String, dynamic>> allotmentDetails = [];

  Map<String, dynamic> vanReqDetails = {};
  Map<String, dynamic> acknowledgeDetails = {};
  Map<String, dynamic> choosedAllotment = {};

  bool isExpanded = false;
  bool _launchLoading = true;
  bool _showAllotmentDetails = true;
  
  String? token;

  DateTime? requested_at_date;
  String? requested_at;
  DateTime? action_at_date;

  DateFormat? _myFormat;

  @override
  void initState() {
    super.initState();

    setState(() {
      referenceId = widget.referenceId;
      _myFormat = DateFormat('dd-MM-yyyy').add_Hms();
    });

    getToken().whenComplete(() {
      fetchDetails().then((value) => setState(() {
        _launchLoading = false;
      }));
    });
  }

  Future<void> fetchDetails() async {
    final String? token = await TokenUtil.getToken();
    final String? domainName = await TokenUtil.getDomainName();

    String vanAdhocReqUrl = '$domainName/api/wms/van_request/o/';
    final vanAdhocReqUri = Uri.parse('${vanAdhocReqUrl}${referenceId}?wms=true');

    debugPrint('VAN DETAILS referenceId : $referenceId');

    final allotmentResponse = await http.get(vanAdhocReqUri, headers: {'Authorization': 'Bearer $token'});

    debugPrint('VAN DETAILS STATUS : ${allotmentResponse.statusCode.toString()}');

    if (allotmentResponse.statusCode == 200) {
      try {
        final adhocReturnAPI = jsonDecode(allotmentResponse.body);

        final detailsData = adhocReturnAPI['van_request'];
        final adhocReturnDetailsData = adhocReturnAPI['details'];

        String vanReqDetailActionParam = '';

        setState(() {
          details = List<Map<String, dynamic>>.from(adhocReturnDetailsData);
          vanReqDetails = Map<String, dynamic>.from(detailsData);

          debugPrint('VAN DETAILS : ${vanReqDetails.toString()}');

          requested_at_date = DateTime.parse(vanReqDetails['requested_at']).add(Duration(hours: int.parse('8')));
          requested_at = _myFormat!.format(requested_at_date!);

          switch (vanReqDetails['status'].toString().capitalize()) {
            case PENDING:
              actionTitleAt = 'null';
              actionTitleBy = 'null';
              actionBy = 'null';
              actionAt = 'null';
              break;
            case ALLOTTED:
              actionTitleBy = 'Approved By';
              actionTitleAt = 'Approved At';
              vanReqDetailActionParam = vanReqDetails['approved_at'];
              actionBy = vanReqDetails['approved_by'];
              break;
            case REJECTED:
              actionTitleBy = 'Rejected By';
              actionTitleAt = 'Rejected At';
              vanReqDetailActionParam = vanReqDetails['rejected_at'];
              actionBy = vanReqDetails['rejected_by'];
              break;
            case EXPIRED:
              actionTitleBy = 'Expired By';
              actionTitleAt = 'Expired At';
              vanReqDetailActionParam = vanReqDetails['expired_at'];
              actionBy = vanReqDetails['expired_by'];
              break;
            default:
          }

          action_at_date = DateTime.parse(vanReqDetailActionParam).add(Duration(hours: int.parse('8')));
          actionAt = _myFormat!.format(action_at_date!);

        });

        debugPrint('Fetch Allotment API completed');
      } catch (e) {
        debugPrint('Failed to parse Allotment JSON: $e');
      }
    } else {
      debugPrint('Failed to fetch Allotment API. Status code: ${allotmentResponse.statusCode}');
      debugPrint('Allotment Error Body: ${allotmentResponse.body}');

      Navigator.pushNamed(context, AppRoutes.login);

      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> getToken() async {
    token = await TokenUtil.getToken();
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
            '${titleCheck(ADHOC_REQUEST)} Lists',
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
      _launchLoading == false ?
      WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                            Navigator.pop(context, false);
                            Navigator.pop(context, false);
                          },
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: textColorTertiary,
                        ),
                        children: [
                          TextSpan(
                            text: '> ${titleCheck(ADHOC_REQUEST)} ',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context, false);
                                
                              },
                          ),
                          TextSpan(
                            text: '> ${widget.referenceId}',
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
                                'Adhoc Request Details',
                                style: TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                  color: biruImran,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _showAllotmentDetails
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 30,
                                  color: biruImran,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showAllotmentDetails = !_showAllotmentDetails;
                                  });
                                },
                              ),
                            ],
                          ),
                          Text(
                            'Requested At: ${requested_at!.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w300,
                              color: textColorTertiary,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          _showAllotmentDetails == false ?
                          InkWell(
                            onTap: () {
                              setState(() { 
                                _showAllotmentDetails = !_showAllotmentDetails;
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
                                          'Adhoc Request ID',
                                          vanReqDetails['id'],
                                          Icons.info,
                                        ),
                                        _buildInfoContainer(
                                          'Van Allot ID',
                                          vanReqDetails['van_allot_id'],
                                          Icons.directions_car,
                                        ),
                                        _buildInfoContainer(
                                          'Description',
                                          vanReqDetails['desc'],
                                          Icons.description,
                                        ),
                                        _buildInfoContainer(
                                          'Status',
                                          vanReqDetails['status'],
                                          Icons.calendar_today,
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
                                          'Requested By',
                                          vanReqDetails['requested_by'],
                                          Icons.description,
                                        ),
                                        _buildInfoContainer(
                                          'Requested At',
                                          requested_at,
                                          Icons.assignment_turned_in_outlined,
                                        ),
                                        if(actionTitleBy != 'null')
                                          _buildInfoContainer(
                                            actionTitleBy,
                                            actionBy,
                                            Icons.assignment_turned_in_outlined,
                                          ),
                                        if(actionTitleAt != 'null')
                                          _buildInfoContainer(
                                            actionTitleAt,
                                            actionAt,
                                            Icons.assignment_turned_in_outlined,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),
                          
                          _buildItemTable(),
                                  
                          const SizedBox(
                            height: 100,
                          ),
                                  
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if(widget.status != PENDING)
                                SizedBox(
                                  width: 150,
                                  height: 50,
                                  child: TextButton(
                                    onPressed: () {
                                      if (widget.status != PENDING) {
                                        Navigator.pop(context, false);
                                      } else {
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
                              
                              if(widget.status == PENDING)
                                SizedBox(
                                  width: 300,
                                  height: 50,
                                  child: TextButton(
                                    onPressed: () async {
                                    
                                      bool _confirmAcknowledge = false;
                                    
                                      _confirmAcknowledge = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DialogRejectConfirmation();
                                        },
                                      );
                                    
                                      if (_confirmAcknowledge) {
                                        final String refID = vanReqDetails['id'];

                                        String _subDirectory = '/api/acknowledgment/wms/van_adhoc_request/reject';
                                        
                                        final String? _domainName = await TokenUtil.getDomainName();
                                        String domainName = _domainName!;

                                        String url = '$domainName$_subDirectory';
                                        final uri = Uri.parse(url);

                                        Map<String, dynamic> payload = {
                                          'van_req_id': refID,
                                        };

                                        try {
                                          final response = await http.post(
                                            uri,
                                            headers: <String, String>{
                                              'Content-Type': 'application/json',
                                              'Authorization': 'Bearer $token',
                                            },
                                            body: jsonEncode(payload),
                                          );

                                          debugPrint('response.statusCode : ${response.statusCode}');

                                          if (response.statusCode == 500) {
                                            final json = jsonDecode(response.body);
                                            final errMsg = json['errMsg'];

                                            FloatingSnackBar(
                                              message: '${refID} encounter an error ${response.statusCode}. $errMsg',
                                              context: context);
                                          }

                                          else if (response.statusCode == 403) {
                                            Navigator.pushNamed(context, AppRoutes.login);
                                            
                                            FloatingSnackBar(
                                                message: 'Token Expired. Please login back to the system.',
                                                context: context);
                                          }

                                          else if (response.statusCode == 200) {
                                            debugPrint('at 200 : ${response.statusCode}');
                                            
                                            Navigator.pop(context, true);

                                            FloatingSnackBar(
                                              message: 'Adhoc Request ${refID} rejected.',
                                              context: context,
                                            );
                                          } else {
                                            debugPrint('Failed to fetch Unacknowledged API. Status code: ${response.statusCode}');
                                            debugPrint('Error Body: ${response.body}');

                                            
                                            const errMsg = 'This may due to server hickups. Please wait for a while.';

                                            FloatingSnackBar(
                                                message: '${refID} encounter an error ${response.statusCode}. $errMsg',
                                                context: context);

                                            Navigator.of(context).pop();
                                          }
                                        } catch (error) {

                                          FloatingSnackBar(
                                                message: 'Error ${error}. Please contact system admin.',
                                                context: context
                                          );
                                          
                                        }
                                      }
                                    },
                                    
                                    style: TextButton.styleFrom(
                                      backgroundColor: redColor,
                                      side: BorderSide(
                                        color: Colors.transparent,
                                      )
                                    ),
                                    child: Text(
                                      "Reject",
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 16
                                      ),
                                    ),
                                  ),
                                ),

                              if(widget.status == PENDING)
                                SizedBox(
                                  width: 300,
                                  height: 50,
                                  child: TextButton(
                                    onPressed: () async {
                                    
                                      bool _confirmAcknowledge = false;
                                    
                                      _confirmAcknowledge = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DialogApproveConfirmation();
                                        },
                                      );
                                    
                                      if (_confirmAcknowledge) {
                                        final String refID = vanReqDetails['id'];

                                        String _subDirectory = '/api/acknowledgment/wms/van_adhoc_request/approve';
                                        
                                        final String? _domainName = await TokenUtil.getDomainName();
                                        String domainName = _domainName!;

                                        String url = '$domainName$_subDirectory';
                                        final uri = Uri.parse(url);

                                        Map<String, dynamic> payload = {
                                          'van_req_id': refID,
                                        };

                                        try {
                                          final response = await http.post(
                                            uri,
                                            headers: <String, String>{
                                              'Content-Type': 'application/json',
                                              'Authorization': 'Bearer $token',
                                            },
                                            body: jsonEncode(payload),
                                          );

                                          debugPrint('response.statusCode : ${response.statusCode}');

                                          if (response.statusCode == 500) {
                                            final json = jsonDecode(response.body);
                                            final errMsg = json['errMsg'];

                                            debugPrint('APPROVE RES : ${errMsg}');

                                            FloatingSnackBar(
                                              message: '${refID} encounter an error ${response.statusCode}. $errMsg',
                                              context: context);
                                          }

                                          else if (response.statusCode == 403) {
                                            Navigator.pushNamed(context, AppRoutes.login);
                                            
                                            FloatingSnackBar(
                                                message: 'Token Expired. Please login back to the system.',
                                                context: context);
                                          }

                                          else if (response.statusCode == 200) {
                                            debugPrint('at 200 : ${response.statusCode}');
                                            
                                            Navigator.pop(context, true);

                                            FloatingSnackBar(
                                              message: 'Adhoc Request ${refID} approved.',
                                              context: context,
                                            );
                                          } else {
                                            debugPrint('Failed to fetch Unacknowledged API. Status code: ${response.statusCode}');
                                            debugPrint('Error Body: ${response.body}');

                                            
                                            const errMsg = 'This may due to server hickups. Please wait for a while.';

                                            FloatingSnackBar(
                                                message: '${refID} encounter an error ${response.statusCode}. $errMsg',
                                                context: context);

                                            Navigator.of(context).pop();
                                          }
                                        } catch (error) {

                                          FloatingSnackBar(
                                                message: 'Error ${error}. Please contact system admin.',
                                                context: context
                                          );
                                          
                                        }
                                      }
                                    },
                                    
                                    style: TextButton.styleFrom(
                                      backgroundColor: hijauImran,
                                      side: BorderSide(
                                        color: Colors.transparent,
                                      )
                                    ),
                                    child: Text(
                                      "Approve",
                                      style: TextStyle(
                                        color: white,
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
            ],
          ),
        ),
      )

      : Center(child: CircularProgressIndicator())
    ));
  }

  double _responsiveFontSize() {
    final screenWidth = MediaQuery.of(context).size.width;
    const maxResolution = 1200.0;
    const maxSize = 23.0;

    return (screenWidth / maxResolution) * maxSize;
  }

  Widget _buildItemTable() {
    final double tableWidth = MediaQuery.of(context).size.width * 0.8;
    final TextStyle _thisStyle = TextStyle(
      fontSize: _responsiveFontSize(),
      fontWeight: FontWeight.w400,
      color: biruImran,
    );

    return
    _launchLoading == true ?
    Center(child: CircularProgressIndicator()) :
    RawScrollbar(
      radius: Radius.circular(10),
      thickness: 8,
      thumbColor: biruImran4,
      thumbVisibility: true,
      controller: _scrollController2,
      child: SingleChildScrollView(
        controller: _scrollController2,
        child: Column(
          children: [
            Text(
              'SKU Details',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: biruImran,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
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
                  const DataColumn(label: Text('SKU ID'), ),
                  const DataColumn(label: Text('UOM ID'), ),
                  const DataColumn(label: Text('Qty'), ),
                ],
                rows: details.isEmpty ?
                [DataRow(cells: [
                  DataCell(Text('N/A', style: _thisStyle,)),
                  DataCell(Text('N/A', style: _thisStyle,)),
                  DataCell(Text('N/A', style: _thisStyle,)),
                ])] :
                details.asMap().entries.map((entry) {
                  final _thisDetails = entry.value;
                  final int stockTake = _thisDetails['quantity'][0] ?? 0;

                  return DataRow(
                    cells: [
                      DataCell(Text(_thisDetails['sku_id'] ?? 'N/A', style: _thisStyle)),
                      DataCell(Text(_thisDetails['uom_id'] ?? 'N/A', style: _thisStyle)),
                      DataCell(Text(stockTake.toString(), style: _thisStyle)),
                    ],
                  );
                }).toList(),
              ),
            ),

            details.isEmpty ?
             Text(
              '\n\nSKU seems to be empty.\nPlease contact the management to resolve this issue.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.normal,
                color: biruImran,
              ),
            ) : SizedBox(),
          ],
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
}
