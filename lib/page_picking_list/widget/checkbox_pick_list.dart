// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:warehouse/utils/utils.dart';

class CustomCheckbox extends StatefulWidget {
  CustomCheckbox({
    super.key,
    this.width = 24.0,
    this.height = 24.0,
    this.color,
    this.iconSize,
    this.onChanged,
    this.checkColor,
    required this.isPicked,
    this.fixedPicked = false,
  });

  final double width;
  final double height;
  final Color? color;
  // Now you can set the checkmark size of your own
  final double? iconSize;
  final Color? checkColor;
  final void Function(bool?)? onChanged;

  final bool isPicked;
  bool fixedPicked;

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();

    if (widget.isPicked == true) {
      isChecked = true;
    } else {
      isChecked = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() => isChecked = !isChecked);
        widget.onChanged?.call(isChecked);
      },
      child: widget.fixedPicked ? 
      Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: hijauImran3,
          border: Border.all(
            color: hijauImran2,
            // color: widget.color ?? Colors.grey.shade500,
            width: 4.0,
          ),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Icon(
                Icons.flag,
                size: widget.iconSize,
                color: hijauImran2,
              ),
      )
      : Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: isChecked == true ? hijauImran2 : Colors.transparent,
          border: Border.all(
            color: isChecked == true ? Colors.white : widget.color ?? Colors.grey.shade500,
            // color: widget.color ?? Colors.grey.shade500,
            width: 4.0,
          ),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: isChecked
            ? Icon(
                Icons.flag,
                size: widget.iconSize,
                color: widget.checkColor,
              )
            : null,
      ),
    );
  }
}