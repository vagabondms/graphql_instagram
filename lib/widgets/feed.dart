import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:graphql_instagram/screens/comment_screen.dart';
import 'package:graphql_instagram/screens/profile_screen.dart';
import 'package:graphql_instagram/widgets/common/user_avatar.dart';
import 'package:intl/intl.dart';

import '../models/comment.dart';
import '../models/media.dart';
import '../models/post.dart';
import '../models/user.dart';

class Feed extends StatefulWidget {
  const Feed({
    Key? key,
    required this.post,
    required this.onTapLike,
  }) : super(key: key);

  final Post post;
  final VoidCallback onTapLike;

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final PageController pageController = PageController(
    initialPage: 0,
  );
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currentPage =
            pageController.page != null ? pageController.page!.toInt() : 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        children: <Widget>[
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _UserInfo(user: widget.post.user!),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
              ),
            ],
          ),
          // Pictures
          _Pictures(
            medias: widget.post.medias!,
            pageController: pageController,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              _FeedActions(
                post: widget.post,
                onTapLike: widget.onTapLike,
              ),
              _Indicator(
                  number: widget.post.medias!.length,
                  currentValue: _currentPage),
            ],
          ),
          _FeedFooter(post: widget.post),
        ],
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserAvatar(
          profileUrl: user.profileImage!,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          user.nickname!,
        ),
      ],
    );
  }
}

class _Pictures extends StatelessWidget {
  const _Pictures({
    Key? key,
    required this.medias,
    required this.pageController,
  }) : super(key: key);

  final List<Media> medias;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: PageView(
        controller: pageController,
        children: medias.map((media) {
          return Container(
            width: 400,
            height: 400,
            color: Colors.blue,
            child: Image.network(
              media.url != null ? media.url! : '',
              fit: BoxFit.fill,
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// feed에서 게시 사진/영상, 유저 상호작용 버튼 모음
/// 게시 사진/영상 컴포넌트 [_FeedActions]
/// 페이지 인디케이터[_Indicator]
/// Stack으로 조합.

class _FeedActions extends StatelessWidget {
  const _FeedActions({
    Key? key,
    required this.onTapLike,
    required this.post,
  }) : super(key: key);

  final VoidCallback onTapLike;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onTapLike,
              icon: Icon(
                post.isLike! ? Icons.favorite_rounded : Icons.favorite_outline,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CommentScreen(post: post),
                  ),
                );
              },
              icon: const Icon(
                Icons.chat_bubble_outline,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.send_outlined,
              ),
            )
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.bookmark_outline),
        ),
      ],
    );
  }
}

/// 좋아요 수, 게시글 내용, 답글 등의 내용을 표시하는 컴포넌트.
/// 조건에 따라 (답글이 없/있는 경우)등에 따라 UI가 달라짐
/// 좋아요 표시[_LikesIndicator]
/// 게시글 내용 표시 [_Description],
/// 게시글 및 답글 페이지로 이동하는 버튼 [_ViewCommentsButton],
/// 답글 리스트 [_CommentsView]
/// 시간 표시 [_TimeInfo]
class _FeedFooter extends StatelessWidget {
  final Post post;

  const _FeedFooter({
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _LikesIndicator(likes: post.likeCount ?? 0),
          if (post.description != null && post.description!.isNotEmpty) ...[
            const SizedBox(
              height: 10,
            ),
            _Description(
              userId: post.user?.id ?? '',
              nickname: post.user?.nickname ?? '',
              description: post.description ?? '',
            ),
          ],
          // if (post.commentCount != 0 &&
          //     post.comments != null &&
          //     post.comments!.isEmpty)
          ...[
            const SizedBox(
              height: 10,
            ),
            _ViewCommentsButton(
              post: post,
              commentCount: post.commentCount ?? 0,
            ),
            const SizedBox(
              height: 10,
            ),
            _CommentsView(comments: post.comments ?? []),
          ],
          _TimeInfo(
            modifiedAt: post.modifiedAt ?? '',
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class _LikesIndicator extends StatelessWidget {
  final int likes;

  const _LikesIndicator({
    required this.likes,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(),
      child: Text(
        '$likes likes',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ViewCommentsButton extends StatelessWidget {
  final Post post;
  final int commentCount;

  const _ViewCommentsButton({
    required this.commentCount,
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CommentScreen(post: post),
            ),
          );
        },
        child: Text(
          'View all $commentCount comments',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ),
    );
  }
}

class _CommentsView extends StatelessWidget {
  final List<Comment> comments;

  const _CommentsView({
    required this.comments,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: const [],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String description;
  final String nickname;
  final String userId;

  const _Description({
    required this.description,
    required this.nickname,
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableText(
      description,
      maxLines: 2,
      expandText: 'more',
      prefixText: nickname,
      prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
      onPrefixTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProfileScreen(
              userId: userId,
            ),
          ),
        )
      },
    );
  }
}

class _TimeInfo extends StatelessWidget {
  final String modifiedAt;
  const _TimeInfo({
    required this.modifiedAt,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        DateFormat.yMMMMd('en_US').format(
          DateTime.parse(modifiedAt),
        ),
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final int number;
  final int currentValue;

  const _Indicator({
    required this.number,
    required this.currentValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = <Widget>[];

    for (int i = 0; i < number; i++) {
      list.add(
        i == currentValue
            ? const _Circle(isActive: true)
            : const _Circle(isActive: false),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: list,
    );
  }
}

class _Circle extends StatelessWidget {
  final bool isActive;

  const _Circle({
    required this.isActive,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 6,
      width: 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: const BorderRadius.all(
          Radius.circular(3),
        ),
      ),
    );
  }
}
