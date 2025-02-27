import 'package:flutter/material.dart';

class ErrorModal extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final Function() onPressed;

  const ErrorModal({
    super.key,
    required this.title,
    required this.content,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        title: Text(title), // Use the provided title
        content: Text(content), // Use the provided content
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Call the provided onPressed function
                onPressed();
                // Dismiss the dialog
                // Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue), // Set background color
                elevation:
                    MaterialStateProperty.all<double>(4), // Set elevation
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20), // Set border radius
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 24), // Add padding
                child: Text(
                  buttonText, // Use the provided button text
                  style: const TextStyle(
                    fontSize: 16, // Increase text size
                    color: Colors.white, // Change text color
                  ), 
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


class ConfirmationModal extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final Function() onConfirm;
  final Function() onCancel;

  const ConfirmationModal({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(content),
        ),
        actions: [
          TextButton(
            onPressed: onCancel,
            child: Text(
              cancelText,
              style: const TextStyle(color: Colors.blue), // Adjust text color
            ),
          ),
          const SizedBox(width: 8), // Add space between buttons
          ElevatedButton(
            onPressed: onConfirm,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue), // Set background color
              elevation: MaterialStateProperty.all<double>(4), // Set elevation
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Set border radius
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 24), // Add padding
              child: Text(
                confirmText,
                style: const TextStyle(
                  fontSize: 16, // Increase text size
                  color: Colors.white, // Change text color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SuccessModal extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final Function() onPressed;

  const SuccessModal({
    super.key,
    required this.title,
    required this.content,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(content),
        ),
        actions: [
          ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue), // Set background color
              elevation: MaterialStateProperty.all<double>(4), // Set elevation
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Set border radius
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 24), // Add padding
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 16, // Increase text size
                  color: Colors.white, // Change text color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
