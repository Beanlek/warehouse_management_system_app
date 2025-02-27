// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/utils/utils.dart';
import 'package:widget_zoom/widget_zoom.dart';

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
                    Navigator.pop(context, true);
                    
                    toHome ?
                      Navigator.pop(context, true) : 
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

class DialogAcknowledgeConfirmation extends StatelessWidget {
  const DialogAcknowledgeConfirmation({
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
          Text('Allotment is to be acknowledged.',
            style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: biruImran,
                  fontSize: 22.0,
                ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Are you sure you want to acknowledge this allotment?',
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
                    "Acknowledge",
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