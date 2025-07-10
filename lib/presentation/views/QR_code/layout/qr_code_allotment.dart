// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unnecessary_brace_in_string_interps, prefer_const_constructors, must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:vibration/vibration.dart';

import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';

class QRScannerPageAllotment extends StatefulWidget {
  QRScannerPageAllotment({
    super.key,
    required this.vanID,
    required this.refID,
    required this.comment,
    required this.imageFile,
    this.dataArr = const [],
    this.isAdhocReturn = false,
  });

  final String vanID;
  final String refID;
  final String comment;
  final XFile imageFile;
  List<Map<String, dynamic>> dataArr;
  bool isAdhocReturn;

  @override
  State<StatefulWidget> createState() => _QRScannerPageAllotmentState();
}

class _QRScannerPageAllotmentState extends State<QRScannerPageAllotment> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;
  QRViewController? controller;
  String? _token;
  
  bool isFlashOn = false;
  bool resumeCamera = false;
  bool snackbarShown = false;
  bool _isLoading = false;
  bool _canVibrate = true;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    _init();
    _getToken();
    debugPrint('widget.dataArr : ${widget.dataArr}');
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _getToken() async {
    final String? token = await TokenUtil.getToken();
    setState(() {
      _token = token!;
    });
  }

  Future<void> _init() async {
    await Vibration.hasVibrator().then((canVibrate) {
      
      setState(() {
        _canVibrate = canVibrate!;
        _canVibrate
            ? debugPrint('This device can vibrate')
            : debugPrint('This device cannot vibrate');
      });
    });
  }

  Future<void> _sendData() async {

    if (_token == null) {
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
      return;
    }

    String _subDirectory = widget.isAdhocReturn ?
      '/api/acknowledgment/wms/submit/acknowledge' :
      '/api/wms/android_acknowledge';
    File dataImage;
    
    final String? _domainName = await TokenUtil.getDomainName();
    String domainName = _domainName!;

    String url = widget.isAdhocReturn ?
      '$domainName$_subDirectory' :
      '$domainName$_subDirectory/${widget.refID}';
    final uri = Uri.parse(url);
    
    dataImage = File(widget.imageFile.path);

    final List<int> imageBytes = dataImage.readAsBytesSync();
    final String imageBase64 = base64Encode(imageBytes);

    Map<String, dynamic> payload = {};

    if (widget.isAdhocReturn) {
      final List<Map<String, dynamic>> customizedDataArr = [];

      for (final skuData in widget.dataArr) {
        final Map<String, dynamic> customizedSkuData = {
          'sku_id': skuData['sku_id'],
          'uom_id': skuData['uom_id'],
          'init_qty': skuData['requested_qty'],
          'updated_qty': skuData['quantity'][0],
        };
        customizedDataArr.add(customizedSkuData);
      }

      payload = {
        'id': widget.refID,
        'skus': customizedDataArr,
        'comment': widget.comment,
        'image': [
          {'image': 'data:image/png;base64,${imageBase64}'}
        ],
      };
    }

    else {
      payload = {
        'comment': widget.comment,
        'image': [
          {'image': 'data:image/png;base64,${imageBase64}'}
        ],
      };

    }
  

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(payload),
      );

      debugPrint('response.statusCode : ${response.statusCode}');

      if (response.statusCode == 500) {
        final json = jsonDecode(response.body);
        final errMsg = json['errMsg'];

        FloatingSnackBar(
            message: '${widget.refID} encounter an error. $errMsg',
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
        debugPrint('at 200 : ${response.statusCode}');
        Navigator.pop(context, true);
        FloatingSnackBar(
          message: 'Allotment ${widget.refID} acknowledged.',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          title: Text(
            'QR Scanner',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: biruImran,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.switch_camera_outlined),
              onPressed: () {
                _onSwitchCamera();
              },
            ),
            IconButton(
              icon: isFlashOn
                  ? const Icon(Icons.flashlight_on_outlined)
                  : const Icon(Icons.flashlight_off_outlined),
              onPressed: () {
                _onToggleFlashlight();
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              const SizedBox(
                height: 12,
              ),
              Expanded(
                flex: 5,
                child: _buildQrView(context),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      resumeCamera ?
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: colorSecond,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    controller?.resumeCamera();
                                    setState(() {
                                      resumeCamera = false;
                                      result = null;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.repeat_rounded,
                                    color: Colors.white, // Icon color
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Rescan',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: colorSecond,
                                ),
                                textAlign: TextAlign.center,
                                softWrap:
                                    true, // Allow text to wrap to the next line
                                overflow: TextOverflow
                                    .clip, // Use ellipsis (...) for overflow
                              ),
                            ],
                          ),
                        ) :

                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: biruImran,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Position the QR code in the center of the scanner.',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: biruImran,
                                ),
                                textAlign: TextAlign.center,
                                softWrap:
                                    true, // Allow text to wrap to the next line
                                overflow: TextOverflow
                                    .clip, // Use ellipsis (...) for overflow
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              )
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
    );
  }

  Widget buildResultText() {
    return result != null
        ? Text(
            'Barcode Type: ${(result!.format)}\n  Data: ${result!.code}',
            textAlign: TextAlign.center,
          )
        : const Text('Scan a code', textAlign: TextAlign.center);
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 500.0
        : 500.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.blue.shade300,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      cameraFacing: CameraFacing.back,
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      snackbarShown = false; // Reset the snackbarShown variable for each scan
      _processQRCode(scanData, widget.vanID);
      debugPrint(scanData.toString());
    });
  }

  Future<void> _processQRCode(Barcode scanData, String myVanId) async {
    if (scanData.code != null) {
      Map<String, dynamic> qrData;
      try {
        qrData = json.decode(scanData.code!);
      } catch (e) {
        // Handle JSON decoding error
        showSnackbar('Invalid QR code format. Please scan again.');
        setState(() {
          Vibration.vibrate();
          controller?.pauseCamera();
          resumeCamera = true;
        });
        return;
      }

      String? allotmentDate = qrData['allotment_date'];
      String? vanId = qrData['van_id'];
      String? generatedTime = qrData['generated_time'];

      if (allotmentDate == null || vanId == null || generatedTime == null) {
        // Show snackbar only if it hasn't been shown for this scan
        setState(() {
          Vibration.vibrate();
          resumeCamera = true;
        });
        if (!snackbarShown) {
          showSnackbar('Invalid QR code. Please scan again.');
          snackbarShown = true; // Mark the snackbar as shown for this scan
          controller?.pauseCamera();
        }
        return;
      }

      // Parse date from ISO 8601 format
      DateTime? allotmentDateTime;
      try {
        allotmentDateTime = DateTime.parse(allotmentDate).add(Duration(hours: int.parse('8')));
      } catch (e) {
        debugPrint('Error parsing allotment date: $e');
      }

      // Convert generated time to DateTime
      DateTime? generatedDateTime;
      try {
        generatedDateTime =
            DateTime.fromMillisecondsSinceEpoch(int.parse(generatedTime));
      } catch (e) {
        debugPrint('Error parsing generated time: $e');
      }

      if (allotmentDateTime == null || generatedDateTime == null) {
        // Handle invalid date or time format
        showSnackbar('Invalid date or time format. Please scan again.');
        setState(() {
          Vibration.vibrate();
          resumeCamera = true;
          controller?.pauseCamera();
        });
        return;
      }

      // Check if the scanned vanId matches the one passed to this page
      if (vanId.toUpperCase() != myVanId.toUpperCase()) {
        showSnackbar(
            'This QR code does not match the van ID. Please scan again.');
        setState(() {
          Vibration.vibrate();
          resumeCamera = true;
          controller?.pauseCamera();
        });
        return;
      }

      // Check if the time difference is more than 5 minutes
      if (DateTime.now().difference(generatedDateTime).inMinutes > 5) {
        showSnackbar('This QR code has expired. Please generate a new QR code.');
        setState(() {
          Vibration.vibrate();
          resumeCamera = true;
          controller?.pauseCamera();
        });
        return;
      }

      // Do your logic here with the extracted data
      // For example, navigate to another page with the data
      setState(() {
        _isLoading = true;
        controller?.pauseCamera();
      });

      await Future.delayed(
        const Duration(seconds: 2),
      ).then((_) {
        setState(() {
          _sendData();
          _isLoading = false;
        });
      });

      // Optionally, you can also update the state to handle the successful scan
      setState(() {
        Vibration.vibrate();
        controller?.pauseCamera();
        resumeCamera = true;
      });
    }
  }

  void showSnackbar(String message) {
    FloatingSnackBar(message: message, context: context);
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().add(Duration(hours: int.parse('8')))}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  void _onSwitchCamera() async {
    await controller?.flipCamera();
  }

  void _onToggleFlashlight() async {
    await controller?.toggleFlash();
    bool flashStatus = await controller?.getFlashStatus() ?? false;
    setState(() {
      isFlashOn = flashStatus;
    });
  }

  
}
