import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  const Labels({
    Key? key,
    required this.text,
    required this.textButtonTitle,
    required this.route,
  }) : super(key: key);
  final String route;
  final String text;
  final String textButtonTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(text,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 10,),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, route),
            child: Text(textButtonTitle,
              style: TextStyle(
                color: Colors.blue[600],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}