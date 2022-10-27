import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gql/language.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_instagram/graphql/queries/queries.dart';
import 'package:graphql_instagram/screen/direct_message_screen.dart';
import 'package:graphql_instagram/screen/new_post_screen.dart';
import 'package:graphql_instagram/screen/notification_screen.dart';

import '../components/feed.dart';
import '../models/post.dart';

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
      body: Query(
        options: QueryOptions(
          operationName: 'getPosts',
          document: parseString(GET_POSTS),
          variables: const {
            'size': 10,
            'lastId': 0,
          },

          // fetchPolicy: FetchPolicy.cacheAndNetwork,
          // pollInterval: const Duration(seconds: 10),
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.isLoading) {
            return CircularProgressIndicator();
          }
          if (result.hasException) {
            return Text('exception occured');
          }

          final List<Post> posts = result.data?['getPosts'].map<Post>((post) {
            return Post.fromJson(post);
          }).toList();
          final List<Widget> feedsWidgets = posts.map<Widget>((post) {
            return Feed(post: post);
          }).toList();

          return ListView(
            children: feedsWidgets,
          );
        },
      ),
    );
  }
}
