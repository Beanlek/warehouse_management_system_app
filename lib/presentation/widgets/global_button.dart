import 'package:flutter/material.dart';
import 'package:warehouse/utils/utils.dart';

class Button extends StatefulWidget {
  final Function()? onPressed;
  final String title;
  final bool warning;
  
  const Button({
    super.key,
    required this.onPressed,
    this.title = 'Confirm',
    this.warning = false
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(widget.warning)
              Padding( padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.warning_rounded, color: Colors.red,),
              ),

            Text(widget.title, style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.white
            )),

          ],
        )
      ),
    );
  }
}