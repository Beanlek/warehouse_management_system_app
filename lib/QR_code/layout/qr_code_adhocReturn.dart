// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vibration/vibration.dart';
import 'package:warehouse/form_page/layout/form_page_adhoc_return.dart';
import 'package:warehouse/utils/utils.dart';

class QRScannerPageAdhocReturn extends StatefulWidget {
  final String vanID;
  final String refID;
  final List<Map<String, dynamic>> dataArr;

  const QRScannerPageAdhocReturn(
      {super.key, required this.vanID, required this.refID, required this.dataArr});

  @override
  State<StatefulWidget> createState() => _QRScannerPageAdhocReturnState();
}

class _QRScannerPageAdhocReturnState extends State<QRScannerPageAdhocReturn> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isFlashOn = false;
  bool _canVibrate = true;
  bool resumeCamera = false;
  bool snackbarShown = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'QR Scanner',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorFirst,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
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
      body: Column(
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
                  resumeCamera
                      ? Container(
                          decoration: BoxDecoration(
                            color: colorFirst,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 2), // changes position of shadow
                              ),
                            ],
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
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: colorFirst.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: whiteColor,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Position the QR code in the center of the scanner.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: whiteColor,
                                    ),
                                    textAlign: TextAlign.center,
                                    softWrap:
                                        true, // Allow text to wrap to the next line
                                    overflow: TextOverflow
                                        .clip, // Use ellipsis (...) for overflow
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          )
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: QRView(
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
        ),
      ),
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

  void _processQRCode(Barcode scanData, String myVanId) {
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
      if (vanId != myVanId) {
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
        showSnackbar('This QR code has expired. Please scan again.');
        setState(() {
          Vibration.vibrate();
          resumeCamera = true;
          controller?.pauseCamera();
        });
        return;
      }

      // Do your logic here with the extracted data
      // For example, navigate to another page with the data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  ConfirmationPageCK(
              refID: widget.refID, dataArr: widget.dataArr,
              ),
        ),
      );

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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
