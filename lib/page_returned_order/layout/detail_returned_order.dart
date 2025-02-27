// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_print, unnecessary_brace_in_string_interps, prefer_final_fields

import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/page_returned_order/widget/dialog_Widget.dart';

import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/color.dart';

class ReturnedOrderDetail extends StatefulWidget {
  const ReturnedOrderDetail(
      {super.key,
      required this.returnedOrderId,
      required this.siteId,
      required this.soDate,
      required this.vanId,
      required this.outletId,
      required this.outletName,
      required this.awb,
      required this.createdAt,
      required this.status,
      required this.deliveryDate,
      required this.rejectionReason});

  final String returnedOrderId;
  final String siteId;
  final String soDate;
  final String vanId;
  final String outletId;
  final String outletName;
  final String awb;
  final String createdAt;
  final String status;
  final String deliveryDate;
  final String rejectionReason;

  @override
  State<ReturnedOrderDetail> createState() => _ReturnedOrderDetailState();
}

class _ReturnedOrderDetailState extends State<ReturnedOrderDetail> {
  final ScrollController _scrollController = ScrollController();
  List<TextEditingController> _physicalQtyController = [];
  List<Map<String, dynamic>> SKUs = [];
  List<DataRow> skuRow = [];
  bool _showSKUDetails = true;
  bool _showOverStocked = false;
  bool _isLoading = false;

  String? _token;
  String? wms_status;
  String? statusReconfirm;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    final String? token = await TokenUtil.getToken();
    setState(() {
      _token = token!;
    });
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

    if (widget.status == 'delivered') {
      return;
    }

    String _subDirectory = '/api/wms/android/pre_sales_order/o';

    // print('fetch Unacknowledged API');
    final String? _domainName = await TokenUtil.getDomainName();
    String domainName = _domainName!;

    String url = '$domainName$_subDirectory/${widget.returnedOrderId}';
    final uri = Uri.parse(url);

    final request = http.Request(
      'GET',
      uri,
    )..headers.addAll(
        {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    http.StreamedResponse response = await request.send();

    String stringResponse = await response.stream.bytesToString();

    if (response.statusCode == 500) {
      final json = jsonDecode(stringResponse);
      final errMsg = json['errMsg'];

      FloatingSnackBar(
          message: '${widget.returnedOrderId} encounter an error. $errMsg',
          context: context);

      Navigator.of(context).pop();
    }

    else if (response.statusCode == 200) {
      print('response.statusCode: ${response.statusCode}');
      try {
        final json = jsonDecode(stringResponse);
        wms_status = json['data']['wms_status'];
        if (wms_status == null) {
          const errMsg = 'WMS Status does not exist.\nPlease forward this issue to system Admin.';
          FloatingSnackBar(
              message: '${widget.returnedOrderId} encounter an error. $errMsg',
              context: context);

          Navigator.of(context).pop();
        }
        statusReconfirm = json['data']['status'];
        final skus = json['data']['skus'];
        // print('all 3 data: $wms_status,$statusReconfirm\n$skus');

        setState(() {
          SKUs = List<Map<String, dynamic>>.from(skus).toList();
          for (var i = 0; i < SKUs.length; i++) {
            SKUs[i]['updated_qty'] = 0;
          }
          print('SKUs : $SKUs');
          setSKUDataRow();
        });
      } catch (e) {
        print('Failed to parse JSON: $e');
      }
    } else {
      print(
          'Failed to fetch Unacknowledged API. Status code: ${response.statusCode}');
      print('Error Body: ${stringResponse}');
      Navigator.pushNamed(context, AppRoutes.login);

      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
    }
  }

  Future<void> sendReceived(String? token) async {

    if (token == null) {
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
      return;
    }

    String _subDirectory = '/api/wms/android/pre_sales_order/acknowledge';
    File dataImage;
    Map<String, dynamic> dataReceive = {};
    List<Map<String, dynamic>> newSKUs = [];
    List<Map<String, dynamic>> newImages = [];

    final String? _domainName = await TokenUtil.getDomainName();
    String domainName = _domainName!;

    print('sendReceived widget.returnedOrderId : ${widget.returnedOrderId}');

    String url = '$domainName$_subDirectory/${widget.returnedOrderId}';
    final uri = Uri.parse(url);
    
    if (_capturedImage == null) {
      FloatingSnackBar(
        message: 'Error. Image null. Please contact system admin.',
        context: context,
      );
      return;
    } else {
      dataImage = File(_capturedImage!.path);
    }

    // final String imageName = '${widget.returnedOrderId}-image.png';
    final List<int> imageBytes = dataImage.readAsBytesSync();
    final String imageBase64 = base64Encode(imageBytes);

    newImages.add({
      "image" : "data:image/png;base64,${imageBase64}"
      // imageName : "data:${imageName}/png;base64,null"
    });
    
    print('SKU1s : $SKUs');
    for (var i = 0; i < SKUs.length; i++) {
      newSKUs.add(SKUs[i]);
      newSKUs[i].remove('quantity');

      // newSKUs[i]['sku_id'] = "'${newSKUs[i]['sku_id']}'";
      // newSKUs[i]['uom_id'] = "'${newSKUs[i]['uom_id']}'";
    }

    // print('SKU2s : $SKUs');
    // print('newSKUs : $newSKUs');

    dataReceive = {
      'skus' : newSKUs,
      'image' : newImages
    };

    print('dataReceive : ${jsonEncode(dataReceive)}');
    // printLongString('dataReceive : \n$dataReceive');

    final response = await http.post(
      uri,
      headers: 
        {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      body: jsonEncode(dataReceive)
    );

    print('response.statusCode : ${response.statusCode}');

    if (response.statusCode == 500) {
      final json = jsonDecode(response.body);
      final errMsg = json['errMsg'];

      FloatingSnackBar(
          message: '${widget.returnedOrderId} encounter an error. $errMsg',
          context: context);

      Navigator.of(context).pop();
    }

    else if (response.statusCode == 302) {

      // final errBody = jsonDecode(response.body);

      FloatingSnackBar(
          // message: '${widget.returnedOrderId} encounter an error. $json',
          message: 'Error ${response.statusCode}. Please contact system admin.',
          context: context);

    }

    else if (response.statusCode == 200) {

      FloatingSnackBar(
        message: 'Order received.',
        context: context,
      );
      Navigator.pop(context, true);

    }
    
    else {
      print('Failed to fetch Unacknowledged API. Status code: ${response.statusCode}');
      print('Error Body: ${response.body}');
      Navigator.pushNamed(context, AppRoutes.login);

      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
    }
  }

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear
    );
    
    if (pickedImage != null) {
      setState(() {
        _capturedImage = pickedImage;
      });
    }
  }

  void setSKUDataRow() {
    final int skuQty = SKUs.length;
    final TextStyle _thisStyle = TextStyle(
      fontSize: _responsiveFontSize(),
      fontWeight: FontWeight.w400,
      color: biruImran,
    );

    DataRow _singleSKURow;

    for (var i = 0; i < skuQty; i++) {
      final TextEditingController controller = TextEditingController(text: '0');
      final String sku_id = SKUs[i]['sku_id'];
      final String uom_id = SKUs[i]['uom_id'];
      final int orderQty = SKUs[i]['quantity'][0];
      
      _physicalQtyController.add(controller);

      _singleSKURow = DataRow(cells: [
        DataCell(Text(sku_id, style: _thisStyle,)),
        DataCell(Text(uom_id, style: _thisStyle,)),
        DataCell(Text(orderQty.toString(), style: _thisStyle,)),
        DataCell(
          TextFormField(
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.edit, color: biruImran, size: _responsiveFontSize(),),
            ),
            style: _thisStyle,
            controller: _physicalQtyController[i],
            keyboardType: TextInputType.number,
            onChanged: (value) {
              int _valueParsed = int.parse(value);
              print('value : $value');
              if (_valueParsed > orderQty) {
                setState(() {
                  _showOverStocked = true;
                });
              } else {
                _showOverStocked = false;
              }
              setState(() {
                SKUs[i]['updated_qty'] = _valueParsed;
              });
            },
          )
        ),
      ]);

      skuRow.add(_singleSKURow);
    }
  }

  double _responsiveFontSize() {
    final screenWidth = MediaQuery.of(context).size.width;
    const maxResolution = 1200.0;
    const maxSize = 26.0;

    return (screenWidth / maxResolution) * maxSize;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          centerTitle: true,
          title: AutoSizeText(
            'Returned Order',
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, top: 20.0, right: 20),
                    child: RichText(
                      text: TextSpan(
                        text: 'Home ',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogConfirmation(toHome: true);
                                  },
                                );
                          },
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: textColorTertiary,
                        ),
                        children: [
                          TextSpan(
                            text: '> Returned Order ',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogConfirmation();
                                  },
                                );
                              },
                          ),
                          TextSpan(
                            text: '> ${widget.returnedOrderId.toUpperCase()}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
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
                                  '${widget.returnedOrderId.toUpperCase()} Details',
                                  style: TextStyle(
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.bold,
                                    color: biruImran,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _showSKUDetails
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    size: 30,
                                    color: biruImran,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      // print(_showSKUDetails);
                                      _showSKUDetails = !_showSKUDetails;
                                      // print(_showActionSummary);
                                    });
                                  },
                                ),
                              ],
                            ),
                            Text(
                              'Created At: ${widget.createdAt.toUpperCase()}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w300,
                                color: textColorTertiary,
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            _showSKUDetails ?
                            _buildDetailTable(
                              widget.returnedOrderId,
                              widget.siteId,
                              widget.vanId,
                              widget.outletId,
                            
                              widget.outletName,
                              widget.awb,
                            
                              widget.createdAt,
                              widget.soDate,
                              widget.status,
                              widget.deliveryDate,
                            
                              widget.rejectionReason,
                            ) : 
                            InkWell(
                              onTap: () {
                                setState(() { 
                                  _showSKUDetails = !_showSKUDetails;
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
                            ),
                            widget.status == 'delivered' ?
                              SizedBox() :
                              _buildSKUTable(skuRow)
                          ],
                        ),
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
    ));
  }

  Widget _buildSKUTable(List<DataRow> _skuRow) {
    final double tableWidth = MediaQuery.of(context).size.width * 0.8;

    return Column(
        children: [
          const SizedBox(
            height: 32,
          ),
          Divider(),
          const SizedBox(
            height: 32,
          ),
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
                fontSize: _responsiveFontSize() * 0.9,
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
                    'Order Qty',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Physical Qty',
                  ),
                ),
              ],
              rows: _skuRow
            ),
          ),
          const SizedBox(
            height: 150,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 150,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    // Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogConfirmation();
                      },
                    );
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
              SizedBox(
                width: 300,
                height: 50,
                child: TextButton(
                  onPressed: _capturedImage != null ? () async {
                    // Navigator.of(context).pop();
                    bool _hasZero = false;
                    bool _confirmReceive = false;

                    for (var i = 0; i < SKUs.length; i++) {
                      final int num = SKUs[i]['updated_qty'];
                      num == 0 ? _hasZero = true : null;
                    }
                            
                    _confirmReceive = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogReceiveConfirmation(hasZero: _hasZero,);
                      },
                    );

                    if (_confirmReceive) {
                      setState(() {
                        _isLoading = true;
                      });

                      await Future.delayed(
                        const Duration(seconds: 2),
                      ).then((_) {
                        setState(() {
                          sendReceived(_token);
                          _isLoading = false;
                        });
                      });
                    }
                    
                  } :
                  () {
                    FloatingSnackBar(
                      message: 'Please take an image to proceed.',
                      context: context,
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: _capturedImage != null ? colorSecond : Colors.transparent,
                    side: BorderSide(
                      color: _capturedImage != null ? Colors.transparent : greyColor
                    )
                  ),
                  child: Text(
                    "Receive",
                    style: TextStyle(
                      color: _capturedImage != null ? white : greyColor,
                      fontSize: 16
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 200,
          ),
        ],
      );
  }

  Widget _buildDetailTable(
    String returnedOrderId,
    String siteId,
    String vanId,
    String outletId,
    String outletName,
    String awb,
    String createdAt,
    String soDate,
    String status,
    String deliveryDate,
    String rejectionReason,
  ) {
    final double tableWidth = MediaQuery.of(context).size.width * 0.8;
    final double screenHeight = MediaQuery.of(context).size.height * 0.8;
    const double cellHeight = 60;
    const double imageCellHeight = 300;

    return Stack(
      children: [
        Positioned(
          left: 0,
          child: Container(
            color: biruImran,
            width: tableWidth * 0.3,
            height: screenHeight,
          ),
        ),
        Container(
          color: Colors.transparent,
          width: tableWidth,
          child: Table(
            border: TableBorder(
              horizontalInside: BorderSide(
                  width: 1, color: biruImran2, style: BorderStyle.solid),
              verticalInside: BorderSide(
                  width: 1, color: biruImran2, style: BorderStyle.solid),
            ),
            columnWidths: {
              0: FractionColumnWidth(0.3),
              1: FractionColumnWidth(0.7)
            },
            children: [
              _buildDetailCell('SO ID',returnedOrderId,cellHeight),
              _buildDetailCell('Site ID',siteId,cellHeight),
              _buildDetailCell('SO Date',soDate,cellHeight),
              _buildDetailCell('Van ID',vanId,cellHeight),
              _buildDetailCell('Outlet ID',outletId,cellHeight),
              _buildDetailCell('Outlet Name',outletName,cellHeight),
              _buildDetailCell('AWB',awb,cellHeight),
              _buildDetailCell('SO Status',status,cellHeight),
              _buildDetailCell('WMS Status',wms_status ?? 'null',cellHeight),
              status == 'delivered' ?
                _buildDetailCell('Delivered At',deliveryDate,cellHeight) :
                _buildDetailCell('Rejection\nReason',rejectionReason.capitalize(),cellHeight),
              //Sini Image
              TableRow( children: [
                  SizedBox(
                    height: (status == 'delivered' || wms_status == 'acknowledged') ? cellHeight : imageCellHeight,
                    child: Center(
                      child: Text('Image',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: (status == 'delivered' || wms_status == 'acknowledged') ? cellHeight : imageCellHeight,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 32.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: (status == 'delivered' || wms_status == 'acknowledged') ?
                        Text('null',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w400,
                              color: greyColor,
                            ),
                        ) :
                        _capturedImage == null ?
                        InkWell(
                          onTap: () {
                            _getImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, color: colorSecond, size: 16+10,),
                              SizedBox(width: 20,),
                              Text(
                                'Take Image',
                                style: TextStyle(
                                  color: colorSecond,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 20,),
                              Transform.scale(
                                scaleX: -1,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: colorSecond,
                                  size: 16+10,
                                ),
                              ),
                            ],
                          ),
                        ) :
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                bool _isRetake = false;
                            
                                _isRetake = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogImagePreview(capturedImage: _capturedImage!,);
                                  },
                                );
                            
                                setState(() {
                                  print('_isRetake : $_isRetake');
                                  _isRetake ?
                                    _capturedImage = null : 
                                    null;
                                });
                            
                              },
                              child: Material(
                                elevation: 12,
                                child: SizedBox(
                                  width: tableWidth / 4,
                                  child: Image.file(
                                    File(_capturedImage!.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: tableWidth*0.05),
                            IconButton(onPressed: () async {
                                bool _isDelete = false;
                            
                                _isDelete = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogDeleteConfirmation();
                                  },
                                );
                            
                                setState(() {
                                  _isDelete ?
                                    _capturedImage = null : 
                                    null;
                                });
                            }, icon: Icon(Icons.delete, color: colorMerah, size: 16+20,))
                          ],
                        )
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  TableRow _buildDetailCell(String header, String data, double cellHeight) {
    Color _colorCheck(String _data) {
      switch (_data) {
        case 'failed':
          return colorMerah;
        case 'delivered':
          return colorSecond; //biru
        case 'acknowledged':
          return hijauImran; //biru
        case 'unacknowledged':
          return colorMerah; //biru
        case 'null':
          return greyColor;
        default:
          return biruImran;
      }
    }
    String _stringCheck(_data) {
      switch (_data) {
        case 'failed':
          _data = "${_data[0].toUpperCase()}${_data.substring(1).toLowerCase()}";
          return _data;
        case 'delivered':
          _data = "${_data[0].toUpperCase()}${_data.substring(1).toLowerCase()}";
          return _data;
        case 'acknowledged':
          _data = "${_data[0].toUpperCase()}${_data.substring(1).toLowerCase()}";
          return _data;
        case 'unacknowledged':
          _data = "${_data[0].toUpperCase()}${_data.substring(1).toLowerCase()}";
          return _data;
        default:
          return _data;
      }
    }
    double _heightCheck(_header) {
      switch (_header) {
        case 'Rejection\nReason':
          return cellHeight + 80;
        case 'delivered':
          return cellHeight;
        default:
          return cellHeight;
      }
    }
    return TableRow(children: [
        SizedBox(
          height: _heightCheck(header),
          child: Center(
            child: AutoSizeText(header,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: white,
                ),
            ),
          ),
        ),
        SizedBox(
          height: _heightCheck(header),
          child: Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(_stringCheck(data),
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w400,
                    color: _colorCheck(data),
                  ),
              ),
            ),
          ),
        ),
      ]);
  }
}
