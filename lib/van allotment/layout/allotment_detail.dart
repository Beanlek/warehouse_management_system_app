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
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:easy_stepper/easy_stepper.dart';

import 'package:warehouse/QR_code/layout/qr_code_allotment.dart';
import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';
import 'package:warehouse/van%20allotment/widget/dialog_widget.dart';

class AllotmentDetailView extends StatefulWidget {
  const AllotmentDetailView({
    super.key,
    required this.allotmentId,
    required this.allotmentType,
    required this.status,
    required this.createdAt
  });

  final String allotmentId;
  final String allotmentType;
  final String status;
  final String createdAt;

  @override
  State<AllotmentDetailView> createState() => _AllotmentDetailViewState();
}

class _AllotmentDetailViewState extends State<AllotmentDetailView> {
  final PageController _pageController = PageController();
  final TextEditingController _commentController = TextEditingController(text: 'SKU\'s are okay.');
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  List<Map<String, dynamic>> allotments = [];
  List<Map<String, dynamic>> details = [];
  List<Map<String, dynamic>> allotmentDetails = [];

  Map<String, dynamic> adhocDetails = {};
  Map<String, dynamic> acknowledgeDetails = {};
  Map<String, dynamic> choosedAllotment = {};

  bool isExpanded = false;
  bool _launchLoading = true;
  bool _showAllotmentDetails = true;
  bool allItemsChecked = false;
  
  int activeStep = 0;
  XFile? _capturedImage;
  String? token;

  @override
  void initState() {
    super.initState();
    debugPrint('TYPE : ${widget.allotmentType}');

    getToken().whenComplete(() {
      widget.allotmentType == ADHOC_RETURN ?
      fetchAdhocReturnDetails(widget.allotmentId).then((value) => setState(() {
        _launchLoading = false;
      })) :
      fetchAllotmentDetails(widget.allotmentId).then((value) => setState(() { debugPrint(details.length.toString());
        _launchLoading = false;
      }));
    });
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
            '${titleCheck(widget.allotmentType)} Lists',
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
                            text: '> ${titleCheck(widget.allotmentType)} ',
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
                            text: '> ${widget.allotmentId}',
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
                                widget.allotmentType == ADHOC_RETURN ?
                                  'Adhoc Return Details' :
                                widget.allotmentType == ADHOC_REQUEST ?
                                  'Adhoc Request Details' :
                                  'Allotment Details',
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
                                    // debugPrint(_showActionSummary);
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
                                widget.allotmentType == ADHOC_RETURN ?
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        
                                        _buildInfoContainer(
                                          'Adhoc Return ID',
                                          adhocDetails['id'],
                                          Icons.info,
                                        ),
                                        _buildInfoContainer(
                                          'Van ID',
                                          adhocDetails['van_id'],
                                          Icons.directions_car,
                                        ),
                                        _buildInfoContainer(
                                          'Date',
                                          adhocDetails['date'],
                                          Icons.calendar_today,
                                        ),
                                      ],
                                    ),
                                  ),
                                ) :
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        _buildInfoContainer(
                                          'Allotment ID',
                                          choosedAllotment['id'],
                                          Icons.info,
                                        ),
                                        _buildInfoContainer(
                                          'Van ID',
                                          choosedAllotment['van_id'],
                                          Icons.directions_car,
                                        ),
                                        _buildInfoContainer(
                                          'Date',
                                          choosedAllotment['date'],
                                          Icons.calendar_today,
                                        ),
                                        _buildInfoContainer(
                                          'Status',
                                          (choosedAllotment['status'] as String).capitalize(),
                                          Icons.assignment_turned_in_outlined,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                
                                
                                widget.allotmentType == ADHOC_RETURN ?
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        _buildInfoContainer(
                                          'Description',
                                          adhocDetails['desc'],
                                          Icons.description,
                                        ),
                                        _buildInfoContainer(
                                          'Status',
                                          (adhocDetails['status'] as String).capitalize(),
                                          Icons.assignment_turned_in_outlined,
                                        ),
                                        _buildInfoContainer(
                                          'Time Created',
                                          adhocDetails['createdAt'],
                                          Icons.access_time,
                                        ),
                                      ],
                                    ),
                                  ),
                                ) :
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        _buildInfoContainer(
                                          'Packed At',
                                          choosedAllotment['packed_at'],
                                          Icons.timer,
                                        ),
                                        _buildInfoContainer(
                                          'Added to Picklist By',
                                          (choosedAllotment['packed_by'] as String).capitalize(),
                                          Icons.person,
                                        ),
                                        _buildInfoContainer(
                                          'Added to Picklist At',
                                          choosedAllotment['packed_at'],
                                          Icons.access_time,
                                        ),
                                        _buildInfoContainer(
                                          'Sent for Picking At',
                                          choosedAllotment['created_at'],
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
                              lineType: allItemsChecked ?
                                LineType.normal : LineType.dotted,
                              lineLength: _responsiveFontSize() * 6,
                              lineThickness: 1,
                              defaultLineColor: biruImran,
                              finishedLineColor: hijauImran
                            ),
                            stepRadius: 20,
                                  
                            unreachedStepBorderType: BorderType.normal,
                            unreachedStepIconColor: allItemsChecked ?
                              colorSecond :
                              greyColor,
                            unreachedStepBorderColor: allItemsChecked ?
                              colorSecond :
                              greyColor,
                            unreachedStepTextColor: allItemsChecked ?
                              colorSecond :
                              greyColor,
                                  
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
                              if (index == 1 && allItemsChecked == false) {
                                debugPrint('no');
                                FloatingSnackBar(
                                  message:'Please tick all the following SKUs. Any problem please forward to management.',
                                  context: context,
                                );
                                return;
                              }
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
                              physics: allItemsChecked ?
                                AlwaysScrollableScrollPhysics() :
                                NeverScrollableScrollPhysics(),
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  debugPrint('index');
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
                                    if (allItemsChecked == false) {
                                      FloatingSnackBar(
                                        message:
                                          'Please tick all the following SKUs. Any problem please forward to management.',
                                        context: context,
                                      );
                                      return;
                                    }
                                    
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
                                      String comment = _commentController.text.trim();

                                      switch (widget.allotmentType) {
                                        case ADHOC_RETURN:

                                          final String refID = adhocDetails['id'];
                                          
                                          final List<Map<String, dynamic>> dataArr = details;

                                          if (token == null) {
                                            Navigator.pushNamed(context, AppRoutes.login);
                                            FloatingSnackBar(
                                                message: 'Token Expired. Please login back to the system.',
                                                context: context);
                                            return;
                                          }

                                          String _subDirectory = '/api/acknowledgment/wms/submit/acknowledge';
                                          File dataImage;
                                          
                                          final String? _domainName = await TokenUtil.getDomainName();
                                          String domainName = _domainName!;

                                          String url = '$domainName$_subDirectory';
                                          final uri = Uri.parse(url);
                                          
                                          dataImage = File(_capturedImage!.path);

                                          final List<int> imageBytes = dataImage.readAsBytesSync();
                                          final String imageBase64 = base64Encode(imageBytes);

                                          Map<String, dynamic> payload = {};

                                          final List<Map<String, dynamic>> customizedDataArr = [];

                                          for (final skuData in dataArr) {
                                            final Map<String, dynamic> customizedSkuData = {
                                              'sku_id': skuData['sku_id'],
                                              'uom_id': skuData['uom_id'],
                                              'init_qty': skuData['requested_qty'],
                                              'updated_qty': skuData['quantity'][0],
                                            };
                                            customizedDataArr.add(customizedSkuData);
                                          }

                                          payload = {
                                            'id': refID,
                                            'skus': customizedDataArr,
                                            'comment': comment,
                                            'image': [
                                              {'image': 'data:image/png;base64,${imageBase64}'}
                                            ],
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
                                                  message: '${refID} encounter an error. $errMsg',
                                                  context: context);
                                            }

                                            else if (response.statusCode == 302) {

                                              FloatingSnackBar(
                                                  message: 'Error ${response.statusCode}. Please contact system admin.',
                                                  context: context);

                                            }

                                            else if (response.statusCode == 200) {
                                              debugPrint('at 200 : ${response.statusCode}');
                                              Navigator.pop(context, true);
                                              FloatingSnackBar(
                                                message: 'Adhoc ${refID} acknowledged.',
                                                context: context,
                                              );
                                            } else {
                                              debugPrint('Failed to fetch Unacknowledged API. Status code: ${response.statusCode}');
                                              debugPrint('Error Body: ${response.body}');
                                              Navigator.pushNamed(context, AppRoutes.login);

                                              FloatingSnackBar(
                                                  message: 'Token Expired. Please login back to the system.',
                                                  context: context);
                                            }
                                          } catch (error) {
                                            FloatingSnackBar(
                                                  // message: '${widget.returnedOrderId} encounter an error. $json',
                                                  message: 'Error ${error}. Please contact system admin.',
                                                  context: context);
                                          }
                                          break;
                                        case ADHOC_REQUEST:
                                        
                                          final String refID = adhocDetails['id'];

                                          if (token == null) {
                                            Navigator.pushNamed(context, AppRoutes.login);
                                            FloatingSnackBar(
                                                message: 'Token Expired. Please login back to the system.',
                                                context: context);
                                            return;
                                          }

                                          String _subDirectory = '/api/wms/android_acknowledge';
                                          File dataImage;
                                          
                                          final String? _domainName = await TokenUtil.getDomainName();
                                          String domainName = _domainName!;

                                          String url = '$domainName$_subDirectory/${refID}';
                                          final uri = Uri.parse(url);
                                          
                                          dataImage = File(_capturedImage!.path);

                                          final List<int> imageBytes = dataImage.readAsBytesSync();
                                          final String imageBase64 = base64Encode(imageBytes);

                                          Map<String, dynamic> payload = {};

                                          payload = {
                                            'comment': comment,
                                            'image': [
                                              {'image': 'data:image/png;base64,${imageBase64}'}
                                            ],
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

                                            print('response.statusCode : ${response.statusCode}');

                                            if (response.statusCode == 500) {
                                              final json = jsonDecode(response.body);
                                              final errMsg = json['errMsg'];

                                              FloatingSnackBar(
                                                  message: '${refID} encounter an error. $errMsg',
                                                  context: context);

                                              // Navigator.of(context).pop();
                                            }

                                            else if (response.statusCode == 302) {

                                              // final errBody = jsonDecode(response.body);

                                              FloatingSnackBar(
                                                  // message: '${widget.returnedOrderId} encounter an error. $json',
                                                  message: 'Error ${response.statusCode}. Please contact system admin.',
                                                  context: context);

                                            }

                                            else if (response.statusCode == 200) {
                                              print('at 200 : ${response.statusCode}');
                                              Navigator.pop(context, true);
                                              FloatingSnackBar(
                                                message: 'Adhoc ${refID} acknowledged.',
                                                context: context,
                                              );
                                            } else {
                                              print('Failed to fetch Unacknowledged API. Status code: ${response.statusCode}');
                                              print('Error Body: ${response.body}');
                                              Navigator.pushNamed(context, AppRoutes.login);

                                              FloatingSnackBar(
                                                  message: 'Token Expired. Please login back to the system.',
                                                  context: context);
                                            }
                                          } catch (error) {
                                            FloatingSnackBar(
                                              
                                                  message: 'Error ${error}. Please contact system admin.',
                                                  context: context);
                                          }

                                          break;
                                        default:
                                          bool tempRefresh = false;
                                          tempRefresh = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => QRScannerPageAllotment(
                                                  refID: choosedAllotment['id'] ?? adhocDetails['id'],
                                                  vanID: choosedAllotment['van_id'] ?? adhocDetails['van_id'],
                                                  comment: comment,
                                                  imageFile: _capturedImage!,
                                                  
                                                  isAdhocReturn: false,
                              
                                                  dataArr: [],
                                                ),
                                              ),
                                          );
                                          if (tempRefresh) {
                                            setState(() {
                                              Navigator.pop(context, true);
                                              tempRefresh = false;
                                            });
                                          }
                                      }
                                    }
                                  
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: 
                                      activeStep == 1 ?
                                        _capturedImage == null || _commentController.text == '' ?
                                          Colors.transparent
                                          : hijauImran
                                        : allItemsChecked ? hijauImran
                                      : Colors.transparent
                                    ,
                                    side: BorderSide(
                                      color:
                                        activeStep == 1 ?
                                          _capturedImage == null || _commentController.text == '' ?
                                            greyColor
                                            : Colors.transparent
                                          : allItemsChecked ? Colors.transparent
                                        : greyColor
                                      ,
                                    )
                                  ),
                                  child: Text(
                                    activeStep == 1 ?
                                      "Acknowledge" :
                                      "Next",
                                    style: TextStyle(
                                      color:
                                        activeStep == 1 ?
                                          _capturedImage == null || _commentController.text == '' ?
                                            greyColor
                                            : white
                                          : allItemsChecked ? white
                                        : greyColor
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
                  const DataColumn(
                    label: Text(
                      'SKU ID',
                    ),
                  ),
                  const DataColumn(
                    label: Text(
                      'UOM ID',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      widget.allotmentType == 'Adhoc Return' ?
                      'Req Qty' :
                      'Qty',
                    ),
                  ),
                  if (widget.status == 'unacknowledged' || widget.allotmentType == 'Adhoc Return')
                    DataColumn(
                      label:
                      widget.allotmentType == 'Adhoc Return' ?
                      Text('Stock Take') :
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: RoundCheckBox(
                              disabledColor: grey,
                              isChecked: details.isEmpty ?
                                false :
                                allItemsChecked,
                              onTap: details.isEmpty ? null :
                              (value) {
                                setState(() {
                                  allItemsChecked = value!;
                                  for (final item in details) {
                                    item['checked'] = value;
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                ],
                rows: details.isEmpty ?
                [DataRow(cells: [
                  DataCell(Text('N/A', style: _thisStyle,)),
                  DataCell(Text('N/A', style: _thisStyle,)),
                  DataCell(Text('N/A', style: _thisStyle,)),
                  DataCell(Text('N/A', style: _thisStyle,)),
                ])] :
                widget.allotmentType == 'Adhoc Return' ?
                details.asMap().entries.map((entry) {
                  final _thisDetails = entry.value;
                  final int stockTake = _thisDetails['quantity'][0] ?? 0;

                  return DataRow(
                    cells: [
                      DataCell(Text(_thisDetails['sku_id'] ?? 'N/A', style: _thisStyle)),
                      DataCell(Text(_thisDetails['uom_id'] ?? 'N/A', style: _thisStyle)),
                      DataCell(Text('${_thisDetails['requested_qty'] ?? 'N/A'}', style: _thisStyle)),
                      DataCell(
                        widget.status == 'unacknowledged' ?
                          TextFormField(
                            initialValue: stockTake.toString(),
                            style: _thisStyle,
                            onChanged: (value) {
                              setState(() {
                                _thisDetails['quantity'][0] = int.parse(value);
                                debugPrint(_thisDetails['quantity'][0]);
                              });
                            },
                          ) : 
                          Text(stockTake.toString(), style: _thisStyle),
                      ),
                    ],
                  );
                }).toList() :
                details.asMap().entries.map((entry) {
                  final _thisDetails = entry.value;
                  DataRow dataToShow;
                      
                  dataToShow = DataRow(
                    cells: [
                      DataCell(Text(_thisDetails['sku_id'] ?? 'N/A', style: _thisStyle,)),
                      DataCell(Text(_thisDetails['uom_id'] ?? 'N/A', style: _thisStyle,)),
                      DataCell(Text('${_thisDetails['quantity'][0] ?? 'N/A'}', style: _thisStyle,)),
                      
                      if (widget.status == 'unacknowledged')
                        DataCell(
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: RoundCheckBox(
                              size: 30,
                              isChecked: _thisDetails['checked'] ?? false,
                              onTap: (value) {
                                setState(() {
                                  _thisDetails['checked'] = value;
                                  allItemsChecked = _areAllItemsChecked();
                                });
                              },
                            ),
                          ),
                        ),
                    ],
                  );

                  return dataToShow;
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

  bool _areAllItemsChecked() {
    if (details.isEmpty) {
      return false;
    }

    if (widget.allotmentType == 'Adhoc Return') {
      return true;
    }

    for (final item in details) {
      if (!(item['checked'] ?? false)) {
        return false;
      }
    }
    return true;
  }

  Future<void> fetchAdhocReturnDetails(String allotmentId) async {
    final String? token = await TokenUtil.getToken();
    final String? domainName = await TokenUtil.getDomainName();

    String allotmentUrl =
        '$domainName/api/van/stock/reduce/adhoc/o/';
    final allotmentUri = Uri.parse('$allotmentUrl$allotmentId');
    debugPrint('allotmentId : $allotmentId');

    final allotmentResponse = await http.get(allotmentUri, headers: {'Authorization': 'Bearer $token'});

    if (allotmentResponse.statusCode == 200) {
      try {
        final adhocReturnAPI = jsonDecode(allotmentResponse.body);
        final detailsData = adhocReturnAPI['data'];
        final adhocReturnDetailsData = adhocReturnAPI['details'];
        final acknowledgeDetailsData = adhocReturnAPI['acknowledge_details'];

        setState(() {
          details = List<Map<String, dynamic>>.from(detailsData);
          adhocDetails = Map<String, dynamic>.from(adhocReturnDetailsData);
          acknowledgeDetails =
              Map<String, dynamic>.from(acknowledgeDetailsData);
          allItemsChecked = _areAllItemsChecked();
        });

        debugPrint('Fetch Allotment API completed');
      } catch (e) {
        debugPrint('Failed to parse Allotment JSON: $e');
      }
    } else {
      debugPrint(
          'Failed to fetch Allotment API. Status code: ${allotmentResponse.statusCode}');
      debugPrint('Allotment Error Body: ${allotmentResponse.body}');
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
    }
  }

  Future<void> fetchAllotmentDetails(String allotmentId) async {
    final String? token = await TokenUtil.getToken();
    final String? domainName = await TokenUtil.getDomainName();

    String allotmentUrl = '$domainName/api/allotment/o/';
    final allotmentUri = Uri.parse('$allotmentUrl$allotmentId');

    final allotmentResponse = await http
        .get(allotmentUri, headers: {'Authorization': 'Bearer $token'});

    if (allotmentResponse.statusCode == 200) {
      try {
        final allotmentJson = jsonDecode(allotmentResponse.body);
        final allotmentData = allotmentJson['allotment'];
        final detailsData = allotmentJson['details'];

        setState(() {
          choosedAllotment = allotmentData;
          if (choosedAllotment['van_id'] == null) {
            FloatingSnackBar(
                message: 'Error in allotment ${widget.allotmentId}: van_id=null. Please contact system admin.',
                context: context);
            Navigator.of(context).pop();
          }
          details = List<Map<String, dynamic>>.from(detailsData);
          allItemsChecked = _areAllItemsChecked();
        });

        debugPrint('Fetch Allotment API completed');
      } catch (e) {
        debugPrint('Failed to parse Allotment JSON: $e');
      }
    }
    else if(allotmentResponse.statusCode == 404) {
      final json = jsonDecode(allotmentResponse.body);
      final errMsg = json['errMsg'];

      FloatingSnackBar(
          message: 'Error in allotment ${widget.allotmentId}: ${errMsg}.\nPlease contact system admin.',
          context: context);
      Navigator.of(context).pop();
    }
    else {
      debugPrint('Failed to fetch Allotment API. Status code: ${allotmentResponse.statusCode}');
      debugPrint('Allotment Error Body: ${allotmentResponse.body}');
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
    }
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
