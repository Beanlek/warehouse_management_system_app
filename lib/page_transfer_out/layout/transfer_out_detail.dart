// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables, deprecated_member_use, unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:easy_stepper/easy_stepper.dart';

import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/color.dart';
import 'package:warehouse/van%20allotment/widget/dialog_widget.dart';

class TransferOutDetailView extends StatefulWidget {
  const TransferOutDetailView({
    super.key,
    required this.transferOutId,
    required this.status,
    required this.createdAt
  });

  final String transferOutId;
  final String status;
  final String createdAt;

  @override
  State<TransferOutDetailView> createState() => _TransferOutDetailViewState();
}

class _TransferOutDetailViewState extends State<TransferOutDetailView> {
  final PageController _pageController = PageController();
  final TextEditingController _commentController = TextEditingController(text: 'SKU\'s are okay.');
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  List<Map<String, dynamic>> transferIns = [];
  List<Map<String, dynamic>> details = [];
  List<Map<String, dynamic>> transferInDetails = [];

  Map<String, dynamic> acknowledgeDetails = {};
  Map<String, dynamic> choosedTransferIn = {};

  bool isExpanded = false;
  bool _launchLoading = true;
  bool _showTransferInDetails = true;
  
  int activeStep = 0;
  XFile? _capturedImage;
  String? _token;

  @override
  void initState() {
    super.initState();

    fetchTransferInDetails(widget.transferOutId).then((value) => setState(() {
      _launchLoading = false;
    }));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> getToken() async {
    final String? token = await TokenUtil.getToken();
    setState(() {
      _token = token!;
    });
  }

  Future<void> acknowledge({
    required String reference_id,
  }) async {
    
    await getToken();

    if (_token == null) {
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
      return;
    }

    String _subDirectory = '/api/wms/android/transfer_out/acknowledge';
    File dataImage;
    
    final String? _domainName = await TokenUtil.getDomainName();
    String domainName = _domainName!;

    String url = '$domainName$_subDirectory/${reference_id}';
    final uri = Uri.parse(url);
    
    dataImage = File(_capturedImage!.path);

    final List<int> imageBytes = dataImage.readAsBytesSync();
    final String imageBase64 = base64Encode(imageBytes);

    Map<String, dynamic> payload = {};

    final List<Map<String, dynamic>> customizedDataArr = [];

    for (final skuData in details) {
      final Map<String, dynamic> customizedSkuData = {
        'sku_id': skuData['sku_id'],
        'uom_id': skuData['uom_id'],
        'condition': skuData['condition'],
        'updated_qty': skuData['quantity'][1],
      };
      customizedDataArr.add(customizedSkuData);

      print(customizedSkuData);
    }

    payload = {
      'id': reference_id,
      'image': [{"image": "data:image/jpeg;base64,${imageBase64}"}],
      'comment': _commentController.text.trim(),
      'skus': customizedDataArr,
    };  

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(payload),
      );

      print('response.statusCode : ${response.statusCode}');

      if (response.statusCode == 500) {
        final json = jsonDecode(response.body);
        final errMsg = json['errMsg'];
        print('errMsg: $errMsg');

        FloatingSnackBar(
          message: '${reference_id} encounter an error. $errMsg',
          context: context
        );
      }
      
      else if (response.statusCode == 302) {

        FloatingSnackBar(
            message: 'Error ${response.statusCode}. Please contact system admin.',
            context: context);

      }
      
      else if (response.statusCode == 200) {
        print('at 200 : ${response.statusCode}');
        Navigator.pop(context, true);
        FloatingSnackBar(
          message: '${reference_id} is acknowledged.',
          context: context,
        );
      } else {
        print('Failed to fetch Unacknowledged API. Status code: ${response.statusCode}');
        print('Error Body: ${response.body}');
        Navigator.pushNamed(context, AppRoutes.login);

        FloatingSnackBar(
            message: 'Failed to acknowledge. Status code: ${response.statusCode}',
            context: context);
      }
    } catch (error) {
      print('Error ${error}. Please contact system admin.');
      FloatingSnackBar(
            message: 'Error ${error}. Please contact system admin.',
            context: context);
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
            'Transfer Out Detail',
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
          if (widget.status == 'acknowledged') {
            return true;
          }
          bool willPop = false;
          willPop = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogConfirmation();
            },
          );

          return willPop;
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
                            if (widget.status == 'acknowledged') {
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
                            text: '> Transfer Out ',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                if (widget.status == 'acknowledged') {
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
                            text: '> ${widget.transferOutId}',
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
                                'Transfer Out Details',
                                style: TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                  color: biruImran,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _showTransferInDetails
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 30,
                                  color: biruImran,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showTransferInDetails = !_showTransferInDetails;
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
                          _showTransferInDetails == false ?
                          InkWell(
                            onTap: () {
                              setState(() { 
                                _showTransferInDetails = !_showTransferInDetails;
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
                                          'From Site ID',
                                          choosedTransferIn['site_id'],
                                          Icons.assignment_turned_in_outlined,
                                        ),
                                        _buildInfoContainer(
                                          'To Site ID',
                                          choosedTransferIn['to_site_id'] ?? 'NA',
                                          Icons.assignment_turned_in_outlined,
                                          // isString: true
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
                                          'Transfer Date',
                                          choosedTransferIn['trans_date'],
                                          Icons.date_range,
                                        ),
                                        _buildInfoContainer(
                                          'Status',
                                          (choosedTransferIn['status'] as String).capitalize(),
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
                                          'Read Notification',
                                          (choosedTransferIn['read_notification'].toString()).capitalize(),
                                          Icons.notification_add,
                                        ),
                                        widget.status == 'acknowledged' ? 
                                        _buildInfoContainer(
                                          'Acknowledged At',
                                          choosedTransferIn['acknowledged_at'],
                                          Icons.date_range,
                                        ) :
                                        _buildInfoContainer(
                                          'Created At',
                                          choosedTransferIn['created_at'],
                                          Icons.date_range,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          widget.status == 'acknowledged' ?
                          SizedBox() :
                          EasyStepper(
                            finishedStepIconColor: white,
                            finishedStepBackgroundColor: hijauImran,
                            finishedStepTextColor: hijauImran,
                            activeStepBorderType: BorderType.normal,
                            activeStepIconColor: biruImran,
                            activeStepBorderColor: biruImran,
                            activeStepTextColor: biruImran,
                                  
                            activeStep: activeStep,
                            lineStyle: LineStyle(
                              lineType: LineType.normal,
                              lineLength: _responsiveFontSize() * 6,
                              lineThickness: 1,
                              defaultLineColor: biruImran,
                              finishedLineColor: hijauImran
                            ),
                            stepRadius: 20,
                                  
                            unreachedStepBorderType: BorderType.normal,
                            unreachedStepIconColor: colorSecond,
                            unreachedStepBorderColor: colorSecond,
                            unreachedStepTextColor: colorSecond,
                                  
                            showLoadingAnimation: false,
                            steps: [
                              EasyStep(
                                icon: Icon(Icons.list_alt),
                                title: activeStep != 0 ?
                                  'Done!' :
                                  'SKU\nCheck',
                              ),
                              EasyStep(
                                icon: Icon(Icons.camera_alt),
                                title: 'Take\nImage',
                                // enabled: allItemsChecked
                              ),
                            ],
                            onStepReached: (index) {
                              setState(() {
                                activeStep = index;
                                _pageController.animateToPage(
                                  activeStep,
                                  duration: Duration(milliseconds: 700),
                                  curve: Curves.easeInOut,
                                );
                              });
                            },
                          ),
                          
                          widget.status == 'acknowledged' ?
                          _buildItemTable() :
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 
                              details.length < 8 ?
                                MediaQuery.of(context).size.height * 0.3
                              : MediaQuery.of(context).size.height * 0.5
                            ,
                            child: PageView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  print('index');
                                  activeStep = index;
                                });
                              },
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return _buildItemTable();
                                } else {
                                  return _buildImage();  
                                }
                              },
                            )
                          ),
                                  
                          const SizedBox(
                            height: 100,
                          ),
                                  
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 150,
                                height: 50,
                                child: TextButton(
                                  onPressed: () {
                                    if (widget.status == 'acknowledged') {
                                      Navigator.pop(context, false);
                                    }
                                    else if (activeStep == 1) {
                                      setState(() {
                                        activeStep = 0;
                                        _pageController.animateToPage(
                                          activeStep,
                                          duration: Duration(milliseconds: 700),
                                          curve: Curves.easeInOut,
                                        );
                                      });
                                      return;
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
                              
                              widget.status == 'acknowledged' ?
                              SizedBox() :
                              SizedBox(
                                width: 300,
                                height: 50,
                                child: TextButton(
                                  onPressed: () async {
                                    
                                    if (activeStep == 0) {
                                      setState(() {
                                        activeStep = 1;
                                        _pageController.animateToPage(
                                          activeStep,
                                          duration: Duration(milliseconds: 700),
                                          curve: Curves.easeInOut,
                                        );
                                      });
                                      return;
                                    }
                                  
                                    if (_capturedImage == null || _commentController.text == '') {
                                      FloatingSnackBar(
                                        message:
                                          'Please comment and take an image of the SKU.',
                                        context: context,
                                      );
                                      return;
                                    }
                                  
                                    bool _confirmAcknowledge = false;
                                  
                                    _confirmAcknowledge = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DialogAcknowledgeConfirmation();
                                      },
                                    );
                                  
                                    if (_confirmAcknowledge) {
                                      print("choosedTransferIn['reference_id']: ${choosedTransferIn['reference_id']}");
                                      
                                      await acknowledge(reference_id: choosedTransferIn['reference_id']);
                                    }
                                  
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: 
                                      activeStep == 1 ?
                                        _capturedImage == null || _commentController.text == '' ?
                                          Colors.transparent
                                          : hijauImran
                                        : hijauImran
                                    ,
                                    side: BorderSide(
                                      color:
                                        activeStep == 1 ?
                                          _capturedImage == null || _commentController.text == '' ?
                                            greyColor
                                            : Colors.transparent
                                          : Colors.transparent
                                      ,
                                    )
                                  ),
                                  child: Text(
                                    activeStep == 1 ?
                                      "Accept" :
                                      "Next",
                                    style: TextStyle(
                                      color:
                                        activeStep == 1 ?
                                          _capturedImage == null || _commentController.text == '' ?
                                            greyColor
                                            : white
                                          : white
                                      ,
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
      ),
    ));
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

  Widget _buildImage() {
    final double containerWidth = MediaQuery.of(context).size.width * 0.8;
    final double containerHeight = 
      details.length < 8 ?
        MediaQuery.of(context).size.height * 0.2
      : MediaQuery.of(context).size.height * 0.3;

    return Column(
      children: [
        Text(
          'Take Image',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: biruImran,
          ),
        ),
        const SizedBox(
          height: 56,
        ),
        SizedBox(
          width: containerWidth,
          height: containerHeight,
          child: Row(
            children: [
              _capturedImage == null ?
                Expanded(
                  flex: 2,
                  child: InkWell(
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
                        
                      ],
                    ),
                  ),
                ) :
                Expanded(
                  flex: 2,
                  child: Center(
                    child: InkWell(
                      onTap: () async {
                        bool _isRetake = false;
                    
                        _isRetake = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogImagePreview(capturedImage: _capturedImage!,);
                          },
                        );
                    
                        setState(() {
                          if (_isRetake) {
                            _capturedImage = null;
                            _getImage();
                          }
                        });
                  
                    
                      },
                      child: Stack(
                        children: [
                          Material(
                            elevation: 12,
                            borderRadius: BorderRadius.circular(24.0),
                            child: SizedBox(
                              width: containerWidth * (2/5) - 20,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24.0),
                                child: Image.file(
                                  File(_capturedImage!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: IconButton(onPressed: () async {
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
                            }, icon: Icon(Icons.delete, color: colorMerah, size: 16+20,)),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
          
                SizedBox(width: 12,),
                
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Comment', style: TextStyle(
                          fontSize: _responsiveFontSize(),
                          fontWeight: FontWeight.bold,
                          color: biruImran,
                        ),
                      ),
                      const SizedBox(height: 12,),
                      TextFormField(
                        controller: _commentController,
                        keyboardType: TextInputType.multiline,
                        minLines: 5,
                        maxLines: 5,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: biruImran,
                              width: 2
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: biruImran,
                              width: 1
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  double _responsiveFontSize() {
    final screenWidth = MediaQuery.of(context).size.width;
    const maxResolution = 1200.0;
    const maxSize = 19.0;

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
                  DataColumn( label: Text( 'SKU' ) ),
                  DataColumn( label: Text( 'UOM' ) ),
                  DataColumn( label: Text( 'Condition' ) ),
                  DataColumn( label: Text( 'System' ) ),
                  DataColumn( label: Text( 'Qty' ) ),
                ],
                rows: details.isEmpty ?
                [DataRow(cells: [
                  DataCell(Text('N/A', style: _thisStyle,)),
                  DataCell(Text('N/A', style: _thisStyle,)),
                  DataCell(Text('N/A', style: _thisStyle,)),
                  DataCell(Text('N/A', style: _thisStyle,)),
                  DataCell(Text('N/A', style: _thisStyle,)),
                ])] :
                details.asMap().entries.map((entry) {
                  final _thisDetails = entry.value;
                  final int stockChecked = _thisDetails['quantity'][1] ?? 0;
                  DataRow dataToShow;
                      
                  dataToShow = DataRow(
                    cells: [
                      DataCell(Text(_thisDetails['sku_id'] ?? 'N/A', style: _thisStyle,)),
                      DataCell(Text(_thisDetails['uom_id'] ?? 'N/A', style: _thisStyle,)),
                      DataCell(Text(_thisDetails['condition'] ?? 'N/A', style: _thisStyle,)),
                      DataCell(Text(_thisDetails['quantity'][0].toString(), style: _thisStyle,)),
                      DataCell(
                        widget.status == 'unacknowledged' ?
                          TextFormField(
                            initialValue: stockChecked.toString(),
                            style: _thisStyle,
                            onChanged: (value) {
                              setState(() {
                                _thisDetails['quantity'][1] = int.parse(value);
                                print(_thisDetails['quantity'][1]);
                              });
                            },
                          ) : 
                          Text(_thisDetails['quantity'][1].toString(), style: _thisStyle),
                      ),
                      
                    ],
                  );

                  return dataToShow;
                }).toList(),
              ),
            ),

            details.isEmpty ?
             Text(
              '\n\nSKU seems to be empty.\nPlease contact management if this is an issue.',
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

  Future<void> fetchTransferInDetails(String transferOutId) async {
    final String? token = await TokenUtil.getToken();
    final String? domainName = await TokenUtil.getDomainName();

    String marketReturnUrl = '$domainName/api/wms/android/transfer_out/o/';
    final marketReturnUri = Uri.parse('$marketReturnUrl$transferOutId');

    final marketReturnResponse = await http
        .get(marketReturnUri, headers: {'Authorization': 'Bearer $token'});

    if (marketReturnResponse.statusCode == 200) {
      try {
        final marketReturnJson = jsonDecode(marketReturnResponse.body);
        final marketReturnData = marketReturnJson['data'];
        final detailsData = marketReturnData['skus'];
        print('detailsData: $detailsData');

        setState(() {
          choosedTransferIn = marketReturnData;
          // if (choosedTransferIn['van_id'] == null) {
          //   FloatingSnackBar(
          //       message: 'Error in marketReturn ${widget.transferOutId}: van_id=null. Please contact system admin.',
          //       context: context);
          //   Navigator.of(context).pop();
          // }
          details = List<Map<String, dynamic>>.from(detailsData);
          print('details: $details');
          // allItemsChecked = _areAllItemsChecked();
        });

        print('Fetch MarketReturn API completed');
      } catch (e) {
        print('Failed to parse MarketReturn JSON: $e');
      }
    }
    else if(marketReturnResponse.statusCode == 404) {
      final json = jsonDecode(marketReturnResponse.body);
      final errMsg = json['errMsg'];

      FloatingSnackBar(
          message: 'Error in marketReturn ${widget.transferOutId}: ${errMsg}.\nPlease contact system admin.',
          context: context);
      Navigator.of(context).pop();
    }
    else {
      print('Failed to fetch MarketReturn API. Status code: ${marketReturnResponse.statusCode}');
      print('MarketReturn Error Body: ${marketReturnResponse.body}');
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
    }
  }

  Widget _buildInfoContainer(String label, dynamic value, IconData icon, {
    bool isString = false
  }) {
    String formattedValue = '';

    if (!isString) {
      if (value is DateTime) {
        formattedValue = DateFormat.yMMMd().add_jm().format(value);

      } else if (value is String && DateTime.tryParse(value) != null) {
        
        DateTime dateTimeValue = DateTime.parse(value).add(Duration(hours: int.parse('8')));
        formattedValue = DateFormat.yMMMd().add_jm().format(dateTimeValue);

      } else {
        formattedValue = value.toString();
      }
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
