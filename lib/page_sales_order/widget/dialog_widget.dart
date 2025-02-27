import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/utils/color.dart';

class DialogAWBConfirmation extends StatelessWidget {
  const DialogAWBConfirmation({
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
          Text('AWB is to be updated into the following sales order.',
            style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: biruImran,
                  fontSize: 22.0,
                ),
          ),
          SizedBox(height: 8.0),
          Text(
            'WARNING. This action is permanent. Please double check your AWB Code before proceeding.',
            style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: colorMerah,
                  fontSize: 18.0,
                ),),
          SizedBox(height: 24.0),
          Text(
            'Are you sure you want to finalize this code into this sales order?',
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