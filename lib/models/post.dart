import 'package:graphql_instagram/models/user.dart';

import 'comment.dart';
import 'media.dart';

class Post {
  String? id;
  User? user;
  bool? isMine;
  bool? isUpdated;
  List<Media>? medias;
  String? description;
  bool? isLike;
  int? likeCount;
  List<User>? likeMembers;
  int? commentCount;
  List<Comment>? comments;
  String? lastModifiedAt;

  Post();

  // Post.fromJson(Map<String, dynamic> json)
  //     : id = json['id'],
  //       user = json['user'] ?? User.fromJson(json['user']),
  //       isMine = json['isMine'],
  //       isUpdated = json['isUpdated'],
  //       medias = json['medias'] ?? Media.fromJson(json['medias']),
  //       description = json['description'],
  //       isLike = json['isLike'],
  //       likeCount = json['likeCount'],
  //       likeMembers = json['likeMembers'] ??
  //           json['likeMembers'].map<User>((user) {
  //             print('like $user');
  //             return User.fromJson(user);
  //           }),
  //       commentCount = json['commentCount'],
  //       comments = json['comments'],
  //       lastModifiedAt = json['lastModifiedAt'];

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    isMine = json['isMine'];
    isUpdated = json['isUpdated'];
    if (json['medias'] != null) {
      medias =
          json['medias'].map<Media>((media) => Media.fromJson(media)).toList();
    } else {
      medias = null;
    }
    description = json['description'];
    isLike = json['isLike'];
    likeCount = json['likeCount'];
    if (json['likeMembers'] != null) {
      likeMembers = json['likeMembers'].map<User>((user) {
        return User.fromJson(user);
      }).toList();
    } else {
      likeMembers = null;
    }
    commentCount = json['commentCount'];
    comments = json['comments'];
    lastModifiedAt = json['lastModifiedAt'];
  }
}
