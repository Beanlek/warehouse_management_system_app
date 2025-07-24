import 'package:flutter/material.dart';
import 'package:warehouse/utils/utils.dart';

class Button extends StatefulWidget {
  final Function()? onPressed;
  final String title;
  
  const Button({
    super.key,
    required this.onPressed,
    this.title = 'Confirm'
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: biruImran
      ),
      child: TextButton(onPressed: widget.onPressed,
        child: Text(widget.title, style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Colors.white
        ))
      ),
    );
  }
}