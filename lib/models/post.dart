import 'package:graphql_instagram/models/user.dart';

import 'comment.dart';
import 'media.dart';

class Post {
  Post({
    this.id,
    this.user,
    this.isMine,
    this.isUpdated,
    this.medias,
    this.description,
    this.isLike,
    this.likeCount,
    this.likeMembers,
    this.commentCount,
    this.comments,
    this.modifiedAt,
  });

  final String __typename = "Post";
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
  String? modifiedAt;

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
    modifiedAt = json['modifiedAt'];
  }

  Map<String, dynamic> toJson() => {
        '__typename': __typename,
        'id': id,
        "user": user,
        "isMine": isMine,
        "isUpdated": isUpdated,
        "medias": medias,
        "description": description,
        "isLike": isLike,
        "likeCount": likeCount,
        "likeMembers": likeMembers,
        "commentCount": commentCount,
        "comments": comments,
        "modifiedAt": modifiedAt,
      };

  Post fromPost() {
    return Post(
      id: id,
      user: user,
      isMine: isMine,
      isUpdated: isUpdated,
      medias: medias,
      description: description,
      isLike: isLike,
      likeCount: likeCount,
      likeMembers: likeMembers,
      commentCount: commentCount,
      comments: comments,
      modifiedAt: modifiedAt,
    );
  }
}
