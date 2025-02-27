// ignore_for_file: file_names, prefer_const_constructors, must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:widget_zoom/widget_zoom.dart';
import 'package:warehouse/utils/color.dart';
import 'package:warehouse/warehouse_stock_take/layout/inventorylist.dart';

//this is dialog that will showned in dialog before proceed warehouse stock take
class DialogAllow extends StatelessWidget {
  final String siteId;
  final String warehouseName;

  const DialogAllow(
      {super.key, required this.siteId, required this.warehouseName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Warning",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            "Please ensure that to complete the entire process, any incomplete steps will not be saved.",
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 100,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return InventoryList(
                            id: siteId,
                            warehouseName: warehouseName,
                          );
                        },
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Proceed",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DialogDisallow extends StatelessWidget {
  const DialogDisallow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Error",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            "There are pending allotments that are not in the 'packed' status.The Warehouse Stock Take is not permitted for Site ID",
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 100,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Okay",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DialogConfirmation extends StatelessWidget {
  DialogConfirmation({
    super.key,
    this.toHome = false,
  });

  bool toHome;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('All of your progress will NOT be saved.',
            style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: biruImran,
                  fontSize: 22.0,
                ),
          ),
          SizedBox(height: 16.0),
          Text('Are you sure you want to leave this page?',
            style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: black,
                  fontSize: 18.0,
                ),),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 200,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: colorSecond,
                  ),
                  child: const Text(
                    "No",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    
                    toHome ?
                      Navigator.of(context).pop() : 
                      null;
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: colorMerah,
                  ),
                  child: const Text(
                    "Leave",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class DialogReceiveConfirmation extends StatelessWidget {
  const DialogReceiveConfirmation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('SKU is to be picked.',
            style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: biruImran,
                  fontSize: 22.0,
                ),
          ),
          SizedBox(height: 8.0),
          Text(
            'WARNING. This action is permanent. Please double check your SKU pick status before proceeding.',
            style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: colorMerah,
                  fontSize: 18.0,
                ),),
          SizedBox(height: 24.0),
          Text(
            'Are you sure you want to set these following SKU as picked?',
            style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: black,
                  fontSize: 18.0,
                ),),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 100,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: colorSecond,
                  ),
                  child: const Text(
                    "No",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: hijauImran,
                  ),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class DialogDeleteConfirmation extends StatelessWidget {
  const DialogDeleteConfirmation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Deleting image.',
            style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: biruImran,
                  fontSize: 22.0,
                ),
          ),
          SizedBox(height: 16.0),
          Text('Are you sure you want to delete this image?',
            style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: black,
                  fontSize: 18.0,
                ),),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 200,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: colorSecond,
                  ),
                  child: const Text(
                    "No",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: colorMerah,
                  ),
                  child: const Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class DialogImagePreview extends StatelessWidget {
  const DialogImagePreview({
    super.key,
    required this.capturedImage,
  });

  final XFile capturedImage;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: screenWidth * 0.9,
            height: screenHeight * 0.8,
            // child: PhotoView(
            //   imageProvider: AssetImage(capturedImage.path),
            // )
            child: WidgetZoom(
              heroAnimationTag: '_',
              zoomWidget: Image.file(
                File(capturedImage.path),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 150,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: biruImran4,
                  ),
                  child: const Text(
                    "Back",
                    style: TextStyle(
                      color: biruImran,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: colorSecond,
                  ),
                  child: const Text(
                    "Retake",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DialogInfo extends StatelessWidget {
  const DialogInfo({
    super.key,
    required this.returnedOrderId,
    required this.status,
    required this.info,
  });

  final String returnedOrderId;
  final String status;
  final String info;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
                text: returnedOrderId,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: biruImran,
                  fontSize: 22.0,
                ),
                children: [
                  TextSpan(
                    text: '   ${status.capitalize()}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: status == 'delivered' ? colorSecond : colorMerah,
                      fontSize: 18.0,
                    ),
                  ),
                ]),
          ),
          SizedBox(height: 16.0),
          RichText(
            text: TextSpan(
                text: status == 'delivered' ? 
                  'Delivered At\n' : 
                  'Rejection Reason\n',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: black,
                  fontSize: 18.0,
                ),
                children: [
                  TextSpan(
                    text: info.capitalize(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22.0,
                    ),
                  ),
                ]),
          ),
          SizedBox(height: 16.0),
          SizedBox(
            width: 100,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: colorSecond,
              ),
              child: const Text(
                "Okay",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}