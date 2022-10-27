import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('nickname'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
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
