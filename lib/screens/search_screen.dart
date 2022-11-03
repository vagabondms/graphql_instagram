import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text('Search'),
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
