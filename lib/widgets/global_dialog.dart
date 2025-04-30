// ignore_for_file: must_be_immutable, prefer_const_constructors, unnecessary_string_interpolations, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/utils/utils.dart';

class DialogDone extends StatelessWidget {
  DialogDone({
    super.key,
    required this.id,
    required this.status,
    required this.type,
    this.toHome = false,
  });

  final String id;
  final String status;
  final String type;
  bool toHome;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${type.capitalize()}${status}',
            style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: biruImran,
                  fontSize: 22.0,
                ),
          ),
          SizedBox(height: 16.0),
          Text(
            '${type.capitalize()} ${id.toUpperCase()} is ${status}.',
            style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: black,
                  fontSize: 18.0,
                ),),
          SizedBox(height: 16.0),
          SizedBox(
            width: 100,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: TextButton.styleFrom(
                backgroundColor: hijauImran,
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

class DialogActionSuccess extends StatelessWidget {
  DialogActionSuccess({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonConfirmText = 'Okay',
  });

  final String title;
  final String subtitle;
  String buttonConfirmText;

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: biruImran,
              fontSize: 22.0,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            subtitle,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: black,
              fontSize: 18.0,
            ),
          ),
        ],
      ),

      actions: [
        SizedBox(
          width: 150,
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: hijauImran,
            ),
            child: Text(
              buttonConfirmText,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DialogNotice extends StatelessWidget {
  DialogNotice({
    super.key,
    required this.title,
    required this.notice,
    this.buttonText = 'Okay',
  });

  final String title;
  final String notice;
  String buttonText;

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: biruImran,
                  fontSize: 22.0,
                ),
          ),
          SizedBox(height: 16.0),
          Text(
            notice,
            style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: black,
                  fontSize: 18.0,
                ),),
          SizedBox(height: 16.0),
          Center(
            child: SizedBox(
              width: 150,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                style: TextButton.styleFrom(
                  backgroundColor: colorSecond,
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DialogActionConfirmation extends StatelessWidget {
  DialogActionConfirmation({
    super.key,
    required this.title,
    required this.notice,
    this.buttonConfirmText = 'Confirm',
    this.buttonCancelText = 'Cancel',
  });

  final String title;
  final String notice;
  String buttonConfirmText;
  String buttonCancelText;

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: biruImran,
              fontSize: 22.0,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            notice,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: black,
              fontSize: 18.0,
            ),
          ),
        ],
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SizedBox(
            width: 150,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              style: TextButton.styleFrom(
                backgroundColor: colorMerah,
              ),
              child: Text(
                buttonCancelText,
                style: TextStyle(
                  color: Colors.white,
                ),
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
              backgroundColor: hijauImran,
            ),
            child: Text(
              buttonConfirmText,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DialogExitConfirmation extends StatelessWidget {
  DialogExitConfirmation({
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
