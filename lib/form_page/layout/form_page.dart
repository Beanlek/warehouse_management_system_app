// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/page_homepage/homepage.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';

class ConfirmationPageSyukran extends StatefulWidget {
  final String refID;
  const ConfirmationPageSyukran({super.key, required this.refID});

  @override
  _ConfirmationPageSyukranState createState() =>
      _ConfirmationPageSyukranState();
}

class _ConfirmationPageSyukranState extends State<ConfirmationPageSyukran> {
  final TextEditingController _commentController = TextEditingController();
  XFile? _image;
  String? token;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    token = await TokenUtil.getToken();
    setState(() {
      token = token;
    });
  }

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  Future<void> _sendData() async {
    if (_commentController.text.isEmpty || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a comment and capture an image'),
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        );
      },
    );

    final String comment = _commentController.text;

    final bytes = await _image!.readAsBytes();
    final String base64Image = base64Encode(bytes);

    final Map<String, dynamic> payload = {
      'comment': comment,
      'image': [
        {'image': 'data:image/png;base64,$base64Image'}
      ],
    };
    final String? domainName = await TokenUtil.getDomainName();

    String url = '$domainName/api/wms/android_acknowledge/${widget.refID}';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      // Dismiss loading indicator
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        FloatingSnackBar(message: 'Confirmation Success', context: context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomepageV2()));
      } else {
        FloatingSnackBar(
            message: 'Failed to send data. Error: ${response.statusCode}',
            context: context);
      }
    } catch (error) {
      FloatingSnackBar(message: 'Error sending data: $error', context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Confirmation Page',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _image != null
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Material(
                      elevation: 4, // Add elevation
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Add border radius
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.up,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Swipe Up to Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        onDismissed: (_) {
                          setState(() {
                            _image = null;
                          });
                        },
                        child: Center(
                          child: Image.file(
                            File(_image!.path),
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width / 3,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  )
                : const Text(
                    'Please capture image to proceed',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ).paddingAll(20),
            InkWell(
              onTap: () {
                _getImage();
              },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                child: _image == null
                    ? Icon(Icons.camera_alt)
                    : Icon(Icons.replay),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Add a comment:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  child: TextFormField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Type your comment here...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: colorFirst),
                  onPressed: _sendData,
                  child: const Text(
                    'Approve',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
