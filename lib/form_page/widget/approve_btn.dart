// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/form_page/widget/camera_config.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';

class ApproveButton extends StatelessWidget {
  final String refID;
  final ValueNotifier<List<XFile>> files;
  final GlobalKey<FormState> commentFormKey;

  const ApproveButton({
    super.key,
    required this.files,
    required this.commentFormKey,
    required this.refID,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: colorFirst),
      onPressed: () async {
        if (!commentFormKey.currentState!.validate()) {
          // Form is not valid, show message to user
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Please fill out all required fields.'),
          ));
          return;
        }

        if (files.value.isEmpty) {
          // No image selected, show message to user
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Please select an image.'),
          ));
          return;
        }

        try {
          final String? token = await TokenUtil.getToken();

          // Convert the first selected image to base64
          List<int> imageBytes = await files.value.first.readAsBytes();
          String base64Image = base64Encode(imageBytes);

          // Construct payload for API request
          Map<String, dynamic> payload = {
            'comment': commentFormKey.currentState!.context
                .findAncestorWidgetOfExactType<TextFormField>()!
                .controller!
                .text,
            'image': [
              {'image': 'data:image/png;base64,$base64Image'},
            ],
          };
          final String? domainName = await TokenUtil.getDomainName();

          String url = '$domainName/api/wms/android_acknowledge/$refID';

          // Make API POST request
          final response = await http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(payload),
          );

          // Handle response
          if (response.statusCode == 200) {
            // Data sent successfully
            debugPrint('Data sent successfully!');
          } else {
            // Failed to send data
            debugPrint('Failed to send data. Error: ${response.statusCode}');
          }
        } catch (error) {
          // Handle error
          debugPrint('Error sending data: $error');
        }
      },
      child: const Text(
        'Approve',
        style: TextStyle(color: whiteColor),
      ),
    );
  }
}
