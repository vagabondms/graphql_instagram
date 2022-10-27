import 'package:flutter/material.dart';
import 'package:graphql_instagram/components/common/user_avatar.dart';
import 'package:graphql_instagram/screen/comment_screen.dart';
import 'package:intl/intl.dart';

import '../models/comment.dart';
import '../models/media.dart';
import '../models/post.dart';

class Feed extends StatelessWidget {
  final Post post;
  const Feed({
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        children: <Widget>[
          _FeedHeader(
            profileUrl: post?.user?.profileImage ?? '',
            nickname: post?.user?.nickname ?? '',
          ),
          _FeedBody(
            medias: post.medias ?? [],
          ),
          _FeedFooter(post: post),
        ],
      ),
    );
  }
}

/// feed 최상단 컴포넌트
/// 프로필과 닉네임 [_UserInfo]
class _FeedHeader extends StatelessWidget {
  final String profileUrl;
  final String nickname;

  const _FeedHeader({
    required this.profileUrl,
    required this.nickname,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _UserInfo(profileUrl: profileUrl, nickname: nickname),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz),
        ),
      ],
    );
  }
}

class _UserInfo extends StatelessWidget {
  final String profileUrl;
  final String nickname;

  const _UserInfo({
    Key? key,
    required this.profileUrl,
    required this.nickname,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserAvatar(profileUrl: profileUrl),
        const SizedBox(
          width: 10,
        ),
        Text(nickname),
      ],
    );
  }
}

/// feed에서 게시 사진/영상, 유저 상호작용 버튼 모음
/// 게시 사진/영상 컴포넌트 [_FeedActions]
/// 페이지 인디케이터[_Indicator]
/// Stack으로 조합.
class _FeedBody extends StatefulWidget {
  final List<Media> medias;

  const _FeedBody({
    required this.medias,
    Key? key,
  }) : super(key: key);

  @override
  State<_FeedBody> createState() => _FeedBodyState();
}

class _FeedBodyState extends State<_FeedBody> {
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage =
            _pageController.page != null ? _pageController.page!.toInt() : 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1 / 1,
          child: PageView(
            controller: _pageController,
            children: widget.medias.map((media) {
              return Container(
                width: 400,
                height: 400,
                color: Colors.blue,
                child: Image.network(
                  media.url != null ? 'https://${media.url}' : '',
                ),
              );
            }).toList(),
          ),
        ),
        Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              const _FeedActions(),
              _Indicator(
                  number: widget.medias.length, currentValue: _currentPage),
            ],
          ),
        )
      ],
    );
  }
}

class _FeedActions extends StatelessWidget {
  const _FeedActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_outline,
              ),
            ),
            IconButton(
              onPressed: () {},
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
        children: [
          _LikesIndicator(likes: post.likeCount ?? 0),
          if (post.description != null && post.description!.isEmpty) ...[
            const SizedBox(
              height: 10,
            ),
            _Description(
              userName: post.user?.nickname ?? '',
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
            lastModifiedAt: post.lastModifiedAt ?? '',
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
        children: [],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String description;
  final String userName;

  const _Description({
    required this.description,
    required this.userName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          userName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

class _TimeInfo extends StatelessWidget {
  final String lastModifiedAt;
  const _TimeInfo({
    required this.lastModifiedAt,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Text(
        DateFormat.yMMMMd('en_US').format(
          DateTime.parse(lastModifiedAt),
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
    ;
  }
}
