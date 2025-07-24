import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/utils/utils.dart';

class Breadcrumb extends StatelessWidget {
  final List<String> paths;
  
  const Breadcrumb({
    super.key,
    required this.paths
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: RichText(
          text: TextSpan(
            text: 'Home ',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                for (var i = 0; i < paths.length; i++) {
                  Navigator.of(context).pop();
                }
              },
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: textColorTertiary,
            ),
            children: paths.asMap().entries.map((e) => TextSpan(
              text: '> ${e.value} ',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  for (var i = paths.length; i > (e.key + 1); i--) {
                    Navigator.of(context).pop();
                  }
                },
            )).toList()
            // children: [
            //   TextSpan(text: '> Picklist Allotment'),
            // ]
          ),
        ),
      ),
    );
  }
}