import 'package:flutter/material.dart';

class DirectMessageScreen extends StatelessWidget {
  const DirectMessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Direct',
        ),
      ),
    );
  }
}
