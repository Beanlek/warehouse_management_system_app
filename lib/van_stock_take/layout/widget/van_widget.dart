// ignore_for_file: use_build_context_synchronously

import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/utils/color.dart';

class VanWidget extends StatefulWidget {
  final String token;
  final String vanId;
  final String status;
  final String siteId;
  final DateTime selectedDate;
  final Function fetchDataForVan;
  final VoidCallback onCloseCalendar;
  final Future<void> Function() clearVanDetails;
  final void Function(String) onVanSelected;

  bool isSelected;

  VanWidget({
    super.key,
    required this.vanId,
    required this.status,
    required this.siteId,
    required this.selectedDate,
    required this.token,
    required this.fetchDataForVan,
    required this.onCloseCalendar,
    required this.clearVanDetails,
    required this.isSelected,
    required this.onVanSelected,
  });

  @override
  State<VanWidget> createState() => _VanWidgetState();
}

class _VanWidgetState extends State<VanWidget> {
  double _responsiveFontSize() {
    final screenWidth = MediaQuery.of(context).size.width;
    const maxResolution = 1200.0;
    const maxSize = 26.0;

    return (screenWidth / maxResolution) * maxSize;
  }
  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;
    Color cardColor;
    Color fontColor;

    iconData = widget.status == "acknowledged" ?
    Icons.fact_check_outlined :
    iconData = widget.status == "unacknowledged" ?
    Icons.pending_actions :
    Icons.error_outline;

    iconColor = widget.status == "acknowledged" ? hijauImran : colorMerah;
    cardColor = widget.isSelected ? biruImran4 : biruImran;
    fontColor = widget.isSelected ? biruImran : white;

    return GestureDetector(
      onTap: () async {
        if (widget.status == "acknowledged") {
          widget.onVanSelected('');
          FloatingSnackBar(message: 'Van ${widget.vanId} Stock Take had already been acknowledged.', context: context);
          return;
        }
        widget.onVanSelected(widget.vanId);
        await widget.clearVanDetails();
        
        widget.fetchDataForVan(widget.siteId, widget.vanId, widget.selectedDate, widget.token);
      },
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: widget.isSelected ? biruImran : white, width: 1),
            color: cardColor
          ),// Set card color
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      overflow: TextOverflow.visible,
                      text: TextSpan(
                          text: 'Van ID   ',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: fontColor,
                            fontSize: _responsiveFontSize() * 0.8,
                          ),
                          children: [
                            TextSpan(
                              text: widget.vanId,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: _responsiveFontSize(),
                                color: fontColor,
                              ),
                            ),
                          ]),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      overflow: TextOverflow.visible,
                      text: TextSpan(
                          text: 'Status   ',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: fontColor,
                            fontSize: _responsiveFontSize() * 0.8,
                          ),
                          children: [
                            TextSpan(
                              text: widget.status,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: _responsiveFontSize(),
                                color: iconColor,
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Center(
                  child: Icon(
                    iconData,
                    color: iconColor,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
