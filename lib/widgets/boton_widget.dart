import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);
  final title;
  final void Function ()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      autofocus: true,
      child: Container(
        height: 55,
        width: double.infinity,
        child: Center(
          child: Text(title, style: TextStyle(fontSize: 18),)
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: StadiumBorder(),
      ),
    );
  }
}
