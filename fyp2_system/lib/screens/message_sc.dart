import 'package:flutter/material.dart';

class MessageSc extends StatelessWidget {
  const MessageSc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Message screenvvv',
          style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
