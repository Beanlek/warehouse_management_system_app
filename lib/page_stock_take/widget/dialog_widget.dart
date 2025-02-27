// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/utils/color.dart';

class DialogSaveConfirmation extends StatelessWidget {
  const DialogSaveConfirmation({
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
          Text('Stock take is to be acknowledged.',
            style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: biruImran,
                  fontSize: 22.0,
                ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Are you sure you want to acknowledge this stock take?',
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
