import 'package:graphql_instagram/models/user.dart';

class Comment {
  int? id;
  User? user;
  bool? isMine;
  String? description;
  bool? isLike;
  int? likeCount;
  List<User>? likeMembers;
  int? subCommentCount;
  String? createdAt;

  Comment();

  Comment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user = json['user'],
        isMine = json['isMine'],
        description = json['description'],
        isLike = json['isLike'],
        likeCount = json['likeCount'],
        likeMembers = json['likeMembers'],
        subCommentCount = json['subCommentCount'],
        createdAt = json['createdAt'];
}
