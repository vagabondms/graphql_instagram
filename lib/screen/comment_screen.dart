import 'package:flutter/material.dart';
import 'package:graphql_instagram/constants/assets.dart';
import 'package:intl/intl.dart';

import '../components/comment.dart';
import '../models/comment.dart';
import '../models/post.dart';

class CommentScreen extends StatelessWidget {
  final Post post;

  const CommentScreen({
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Comments'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_horiz,
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: _CommentInput(), // 로그인된 유저의 profile이 들어가야함.
          ),
          Column(
            children: [
              _OriginalPost(
                post: post,
              ),
              Divider(
                thickness: 1,
                height: 1,
                color: Colors.grey.shade300,
              ),
              _Comments(comments: post.comments ?? []),
            ],
          ),
        ],
      ),
    );
  }
}

class _Comments extends StatelessWidget {
  final List<Comment> comments;

  const _Comments({
    required this.comments,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> commentItemList = comments.map<Widget>((comment) {
      return CommentItem(comment: comment);
    }).toList();

    return ListView(
      shrinkWrap: true,
      children: commentItemList,
    );
  }
}

class _OriginalPost extends StatelessWidget {
  final Post post;

  const _OriginalPost({
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: (post.user?.profileImage != null &&
                    post.user!.profileImage!.isNotEmpty
                ? NetworkImage('https://${post.user!.profileImage!}')
                : const AssetImage(DEFAULT_PROFILE) as ImageProvider),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: post?.user?.nickname ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                        text: ' ${post?.description}',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  DateFormat.yMMMMd('en_US').format(
                    DateTime.parse(post.lastModifiedAt ?? ''),
                  ),
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CommentInput extends StatefulWidget {
  const _CommentInput({
    Key? key,
  }) : super(key: key);

  @override
  State<_CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<_CommentInput> {
  final TextEditingController _controller = TextEditingController();

  bool showPostButton = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (showPostButton != _controller.text.isNotEmpty) {
        setState(() {
          showPostButton = _controller.text.isNotEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
        color: Colors.grey.shade400,
        width: 1,
      ))),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
                suffixIcon: showPostButton
                    ? TextButton(
                        onPressed: () {},
                        child: const Text('Post'),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
