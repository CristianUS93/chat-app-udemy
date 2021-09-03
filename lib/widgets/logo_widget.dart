import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Image.asset('assets/tag-logo.png', height: 80,),
            const SizedBox(height: 20,),
            Text(title,
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}