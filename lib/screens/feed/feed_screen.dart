import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_instagram/screens/direct_message_screen.dart';
import 'package:graphql_instagram/screens/feed/feed_query.dart';
import 'package:graphql_instagram/screens/new_post_screen.dart';
import 'package:graphql_instagram/screens/notification_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: SvgPicture.asset(
          'asset/svgs/logo.svg',
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => NewPostScreen()));
            },
            icon: Icon(
              Icons.add_box,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => NotificationScreen()));
            },
            icon: Icon(Icons.favorite),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => DirectMessageScreen()));
            },
            icon: Icon(Icons.send),
          ),
        ],
      ),
      body: FeedList(),
    );
  }
}
