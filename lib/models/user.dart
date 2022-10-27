import 'package:graphql_instagram/models/post.dart';

class User {
  String? id;
  String? email;
  bool? isMe;
  String? name;
  String? nickname;
  String? profileImage;
  String? quotes;
  String? postCount;
  List<Post>? posts;

  User();

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        isMe = json['isMe'],
        name = json['name'],
        nickname = json['nickname'],
        profileImage = json['profileImage'],
        quotes = json['quotes'],
        postCount = json['postCount'],
        posts = json['posts'] != null
            ? json['posts'].map((post) => Post.fromJson(json['posts']))
            : null;
}
