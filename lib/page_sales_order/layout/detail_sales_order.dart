// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_print

// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:warehouse/page_sales_order/widget/dialog_widget.dart';

import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/color.dart';
import 'package:warehouse/widgets/global_dialog.dart';

class SalesOrderDetail extends StatefulWidget {
  const SalesOrderDetail({
    super.key,
    required this.AWBCheck,
    required this.salesOrderId,
    required this.siteId,
    required this.vanId,
    required this.outletId,
    required this.outletName,
    required this.status,
    required this.stockAvailability,
    required this.soDate,
  });

  final int AWBCheck;
  final String salesOrderId;
  final String siteId;
  final String vanId;
  final String outletId;
  final String outletName;
  final String status;
  final String stockAvailability;
  final String soDate;

  @override
  State<SalesOrderDetail> createState() => _SalesOrderDetailState();
}

class _SalesOrderDetailState extends State<SalesOrderDetail> {

  TextEditingController _codeInputController = TextEditingController();
  bool _isLoading = false;
  String AWBCode = '';
  String errmsg = '';

  DateFormat? _myFormat;
  String? _token;

  @override
  void initState() {
    _myFormat = DateFormat('dd-MM-yyyy').add_Hms();
    _getToken();
    _codeInputController = TextEditingController(text: AWBCode);
    super.initState();
  }

  Future<void> _getToken() async {
    final String? token = await TokenUtil.getToken();
    setState(() {
      _token = token!;
    });
    if (widget.status == 'NULL') {
      FloatingSnackBar(
          message: '${widget.salesOrderId} encounter an error. AWB is ${widget.status}\nPlease contact system admin.',
          context: context);

      Navigator.of(context).pop();
    }
    if (token != null) {
      await fetchAPI(_token);
    }
  }

  Future<void> fetchAPI(String? token) async {
    if (token == null) {
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
      return;
    }

    // print('fetch Unacknowledged API');
    final String? _domainName = await TokenUtil.getDomainName();
    String domainName = _domainName!;
    String url = '$domainName/api/sale/order/list/all?limit_rows=1';
    final uri = Uri.parse(url);

    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    print(response.statusCode);

    if (response.statusCode != 200) {
      print('Failed to fetch Unacknowledged API. Status code: ${response.statusCode}');
      print('Error Body: ${response.body}');
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
    }
  }

  Future<bool> _postAWB(String _response) async {
    if (_token == null) {
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
      return false;
    }
    String _subDirectory = '/api/sale/order/awb/add';

    final String? domainName = await TokenUtil.getDomainName();

    String url = '${domainName}${_subDirectory}';
    final uri = Uri.parse(url);

    print('_postAWB widget.salesOrderId : ${widget.salesOrderId}');
    print('_postAWB _response : ${_response}');

    final Map<String, dynamic> payload = {
      'pso_id': widget.salesOrderId,
      'awb': _response
    };

    final response = await http.post(
      uri,
      headers: 
        {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      body: jsonEncode(payload)
    );

    if (response.statusCode == 500) {
      errmsg = response.body;
      return false;
    }

    else if (response.statusCode == 302) {
      errmsg = response.body;
      return false;
    }

    else if (response.statusCode == 200) {
      errmsg = response.body;
      return true;
    }

    else if (response.statusCode == 422) {
      var body = jsonDecode(response.body);
      errmsg = body['errMsg'];
      return false;
    }

    else {
      errmsg = response.body;
      print('Failed to complete process. Status code: ${response.statusCode}');
      print('Error Body: ${response.body}');
      return false;
    }
  }
  
  Color colorCheck(String _status) {
    switch (_status) {
      case 'confirmed':
        return hijauImran2;
      case 'cancelled':
        return colorMerah;
      case 'failed':
        return colorMerah;
      case 'delivered':
        return colorSecond; //biru
      case 'in-transit':
        return category4Color; //oren
      default:
        return textColorSecondary;
    }
  }

  double _responsiveFontSize() {
    final screenWidth = MediaQuery.of(context).size.width;
    const maxResolution = 1200.0;
    const maxSize = 64.0;

    return (screenWidth / maxResolution) * maxSize;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
      backgroundColor: biruImran,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          centerTitle: true,
          title: AutoSizeText(
            'Sales Order',
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
      
      WillPopScope(
        onWillPop: () async {
          if (widget.AWBCheck == 1) {
            return true;
          }
          bool willPop = false;
          willPop = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogExitConfirmation();
            },
          );

          return willPop;
        },
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, top: 20.0, right: 20),
                          child: RichText(
                            text: TextSpan(
                              text: 'Home ',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  if (widget.AWBCheck == 1) {
                                    Navigator.pop(context, false);
                                    Navigator.pop(context, false);
                                  }
                                  else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DialogExitConfirmation(toHome: true,);
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
                                  text: '> Sales Order ',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      if (widget.AWBCheck == 1) {
                                        Navigator.pop(context, false);
                                      }
                                      else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DialogExitConfirmation();
                                          },
                                        );
                  
                                      }
                                    },
                                ),
                                TextSpan(
                                  text: '> ${widget.salesOrderId.toUpperCase()}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ),
                ),
                Container(
                  height: 12,
                  color: white,
                ),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width, 
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: white,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.circle_rounded,
                                          size: 8,
                                          color: widget.AWBCheck == 0
                                              ? colorCheck(widget.status)
                                              : hijauImran,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          widget.AWBCheck == 0
                                              ? widget.status.capitalize()
                                              : 'AWB Present',
                                          style: TextStyle(
                                              color: widget.AWBCheck == 0
                                                  ? colorCheck(widget.status)
                                                  : hijauImran,
                                              fontWeight: FontWeight.w500,
                                              fontSize: _responsiveFontSize() * 0.3),
                                        ),
                                      ],
                                    ),
                                    widget.AWBCheck == 0 ? SizedBox(width: 12) : SizedBox(),
                                    widget.AWBCheck == 0
                                        ? Row(
                                            children: [
                                              Icon(
                                                Icons.circle_rounded,
                                                size: 8,
                                                color: category4Color,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'AWB Absent',
                                                style: TextStyle(
                                                    color: category4Color,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: _responsiveFontSize() * 0.3),
                                              ),
                                            ],
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                                Text(widget.salesOrderId,
                                    style: TextStyle(
                                        color: widget.AWBCheck == 0 ? category4Color : hijauImran,
                                        fontWeight: FontWeight.w800,
                                        fontSize: _responsiveFontSize() * 0.65)),
                                Text(widget.soDate,
                                    style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: _responsiveFontSize() * 0.3)),
                                Text(widget.outletName,
                                    style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: _responsiveFontSize() * 0.4)),
                                Text('${widget.outletId} | ${widget.siteId}',
                                    style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: _responsiveFontSize() * 0.4)),
                                widget.stockAvailability != 'NNN'
                                    ? Text('Stock ${widget.stockAvailability}',
                                        style: TextStyle(
                                            color: black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: _responsiveFontSize() * 0.3))
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          
                          Container(
                            height: 20,
                            color: white,
                          ),
        
                          Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(widget.AWBCheck == 0 ? 'Get AWB by' : 'AWB Code',
                                  style: TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: _responsiveFontSize() * 0.5),
                                  ),
                              const SizedBox(
                                height: 24,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2 + 200,
                                child: InkWell(
                                  onTap: 
                          
                                  // null,
                                  
                                  widget.AWBCheck == 0 ? () async {
                                              
                                    setState(() {
                                      _isLoading = true;
                                    });
                                              
                                    var response = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SimpleBarcodeScannerPage(),
                                      )
                                    );
        
                                    if (response.toString() == '-1') {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      return;
                                    }
                                              
                                    setState(() {
                                      AWBCode = response.toString();
                                      _codeInputController = TextEditingController(text: AWBCode);
                                      _isLoading = false;
                                    });
        
                                    // setState(() {
                                    //   if (res is String) {
                                    //     result = res;
                                    //   }
                                    // });
                                  } : null,
                          
                          
                                  child: 
                                  
                                  widget.AWBCheck == 0 ?
                                  Column(
                                    children: [
                                      ClipRRect(
                                        child: SizedBox(
                                          height: 120,
                                          width: 120,
                                          child: Image.asset('assets/qr-code-dummy.png')
                                        ),
                                      ),
        
                                      const SizedBox(height: 12,),
        
                                      Text('Tap to scan barcode',
                                        style: TextStyle(
                                          color: colorThird,
                                          fontWeight: FontWeight.w500,
                                          fontSize: _responsiveFontSize() * 0.5),
                                        ),
                                    ],
                                  ) : 
                                  
                                  Center(
                                    child: Text(
                                      widget.status.toUpperCase(),
                                      style: TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: _responsiveFontSize(),
                                      )
                                    ),
                                  ),
                                  
                                  // Card(
                                  //   elevation: 0,
                                  //   color: widget.AWBCheck == 0 ? Colors.transparent : greyColor2,
                                  //   shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(32.0),
                                  //   ),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(24),
                                  //     child: Center(
                                  //       child: 
                                  //       widget.AWBCheck == 0 ?
                                  //       Row(
                                  //         mainAxisAlignment: MainAxisAlignment.center,
                                  //         children: [
                                  //           Icon(Icons.barcode_reader, color: colorThird, size: _responsiveFontSize()+10,),
                                  //           SizedBox(width: 20,),
                                  //           Text(
                                  //             'Scan Barcode',
                                  //             style: TextStyle(
                                  //               color: colorThird,
                                  //               fontWeight: FontWeight.normal,
                                  //               fontSize: _responsiveFontSize(),
                                  //             ),
                                  //           ),
                                  //           SizedBox(width: 20,),
                                  //           Transform.scale(
                                  //             scaleX: -1,
                                  //             child: Icon(
                                  //               Icons.arrow_back_ios,
                                  //               color: colorThird,
                                  //               size: _responsiveFontSize()+10,
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       )
                                  //       : Text(
                                  //         widget.status,
                                  //         style: TextStyle(
                                  //           color: textColorTertiary,
                                  //           fontWeight: FontWeight.normal,
                                  //           fontSize: _responsiveFontSize(),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                              ),
                              SizedBox(height: 32,),
                              widget.AWBCheck == 0 ?
                              SizedBox()
                              : RichText(
                                    text: TextSpan(
                                      text: 'Contact us',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          await launchURL();
                                        },
                                      //contact here
                                      style: TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                        decoration: TextDecoration.underline,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' for code change',
                                          style: TextStyle(
                                            color: white,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 18,
                                            fontFamily: 'Poppins',
                                            decoration: TextDecoration.none,
                                          ),
                                        )
                                      ]
                                    ),
                                  ),
                              widget.AWBCheck == 0 ?
                              Text('Your AWB code', style: TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: _responsiveFontSize() * 0.5,
                                  ),
                                )
                              : 
                              SizedBox(),
        
                              widget.AWBCheck == 0 ?
                              SizedBox(height: 12,)
                              : 
                              SizedBox(),
        
                              widget.AWBCheck == 0 ?
                              SizedBox(
                                width: _responsiveFontSize() * 10,
                                child: TextField(
                                  onChanged: (value) => AWBCode = value,
                                  style: TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: _responsiveFontSize() * 0.5,
                                  ),
                                  controller: _codeInputController,
                                  
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(      
                                      borderSide: BorderSide(color: colorThird),   
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: white),
                                    ),  
                                    prefixIcon: const Icon(Icons.keyboard, color: colorThird, size: 20,),
                                    hintText: 'Enter AWB code ...',
                                    hintStyle: TextStyle(
                                      color: biruImran3,
                                      fontWeight: FontWeight.w300,
                                      fontSize: _responsiveFontSize() * 0.5,
                                    ),
                                  ),
                                ),
                              )
                              : 
                              SizedBox(),
        
                              widget.AWBCheck == 0 ?
                              SizedBox(height: 40,)
                              : 
                              SizedBox(),
        
                              widget.AWBCheck == 0 ?
                              SizedBox(
                                width: 300,
                                height: 50,
                                child: TextButton(
                                  onPressed: AWBCode != '' ? () async {
                                    bool _confirmPicked = false;
        
                                    _confirmPicked = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DialogAWBConfirmation();
                                      },
                                    );
        
                                    if (_confirmPicked) {
                                      setState(() {
                                        _isLoading = true;
                                      });
        
                                      _postAWB(AWBCode).then((value) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                                
                                        if (value == false) {
                                          FloatingSnackBar(
                                            context: context,
                                            message: 'Operation failed: ${errmsg}.\nPlease forward issue to system admin.',
                                          );
                                        }
                                                
                                        else {
                                          FloatingSnackBar(
                                            context: context,
                                            message: 'AWB Success.',
                                          );
                                          Navigator.pop(context, true);
                                        }
                                      });
                                    }
                                  } :
                                  () {
                                    FloatingSnackBar(
                                      message: 'Please scan barcode or enter AWB code to continue.',
                                      context: context,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: AWBCode != '' ? hijauImran : Colors.transparent,
                                    side: BorderSide(
                                      color: AWBCode != '' ? Colors.transparent : biruImran3
                                    )
                                  ),
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(
                                      color: AWBCode != '' ? white : biruImran3,
                                      fontSize: 16
                                    ),
                                  ),
                                ),
                              )
                              : 
                              SizedBox(),          
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                
              ],
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
      ),
    ));
  }

  Widget shimmerList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          period: const Duration(milliseconds: 800),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200]!,
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(50, 12, 50, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 60.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget showEmptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Add your Lottie animation widget here
          // Lottie.asset('assets/lottie/no_pending_list.json', width: 200, height: 400),
          AutoSizeText(
            'No pending list for now',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
