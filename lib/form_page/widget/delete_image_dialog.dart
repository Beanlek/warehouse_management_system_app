import 'package:flutter/material.dart';


class DeleteImageDialog extends StatelessWidget {
  const DeleteImageDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Image?'),
      content: const Text('Do you want to delete this image?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
