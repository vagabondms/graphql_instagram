import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;

  const ProfileScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('nickname'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add_box,
            ),
          ),
          IconButton(
              onPressed: () {
                return null;
              },
              icon: Icon(Icons.menu))
        ],
      ),
      body: Text('profile'),
    );
  }
}
