import 'package:flutter/material.dart';
import 'package:graphql_instagram/components/common/user_avatar.dart';
import 'package:intl/intl.dart';

import '../models/comment.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;

  const CommentItem({
    required this.comment,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserAvatar(profileUrl: comment.user?.profileImage),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(comment?.user?.nickname ?? ''),
              Text(comment.description ?? ''),
              Text(
                '${DateFormat.yMMMMd('en_US').format(
                  DateTime.parse(comment.createdAt ?? ''),
                )}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        )
      ],
    );
  }
}
