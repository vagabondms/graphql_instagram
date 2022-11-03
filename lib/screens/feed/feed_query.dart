import 'package:flutter/material.dart';
import 'package:gql/language.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphql/queries/mutations.dart' as mutations;
import '../../graphql/queries/queries.dart' as queries;
import '../../models/post.dart';
import '../../widgets/feed.dart';

class FeedList extends StatelessWidget {
  FeedList({Key? key}) : super(key: key);

  late int lastId;

  int size = 2;

  List<Post> deserializeResult(QueryResult result) {
    return result.data?['getPosts'].map<Post>((post) {
      return Post.fromJson(post);
    }).toList();
  }

  List<Widget> convertIntoWidget(List<Post> list) {
    return list.map<Widget>((post) {
      return MutableFeed(post: post);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        operationName: 'getPosts',
        document: parseString(queries.GET_POSTS),
        variables: {
          "pagingInput": {
            "size": size,
          },
        },
      ),
      builder: (
        QueryResult result, {
        VoidCallback? refetch,
        FetchMore? fetchMore,
      }) {
        if (result.isLoading && result.data == null) {
          return CircularProgressIndicator();
        }

        if (result.hasException) {
          return Text('exception occured');
        }

        final List<Post> posts = deserializeResult(result);
        final feedWidgets = convertIntoWidget(posts);

        lastId = int.parse(posts.last.id!);

        return NotificationListener(
          onNotification: (ScrollNotification scrollNotification) {
            final metrics = scrollNotification.metrics;

            if (metrics.axisDirection != AxisDirection.down) {
              return true;
            }

            if (metrics.extentAfter <= 0 &&
                fetchMore != null &&
                result.isNotLoading) {
              fetchMore(
                FetchMoreOptions(
                  variables: {
                    "pagingInput": {
                      "size": size,
                      "lastId": lastId,
                    },
                  },
                  updateQuery: (previousResultData, fetchMoreResultData) {
                    if (previousResultData != null &&
                        fetchMoreResultData != null) {
                      final List<dynamic> mergedFeeds = [
                        ...previousResultData['getPosts'],
                        ...fetchMoreResultData['getPosts'],
                      ];
                      previousResultData["getPosts"] = mergedFeeds;

                      lastId =
                          int.parse(fetchMoreResultData["getPosts"].last['id']);

                      return previousResultData;
                    }

                    return previousResultData;
                  },
                ),
              );
            }

            return true;
          },
          child: ListView(
            children: [
              ...feedWidgets,
              if (result.isLoading)
                Center(
                  child: CircularProgressIndicator(),
                )
            ],
          ),
        );
      },
    );
  }
}

class MutableFeed extends StatelessWidget {
  const MutableFeed({Key? key, required this.post}) : super(key: key);

  final Post post;

  get update {
    return (String operationName) =>
        (GraphQLDataProxy cache, QueryResult? result) {
          print('postId ${post.id}, isLike ${post.isLike}');
          if (result!.hasException) {
            print(result.exception);
          } else {
            Post copyPost = post.fromPost();
            copyPost.isLike = result.data![operationName];

            cache.writeFragment(
              Fragment(
                  document: parseString(
                '''
                      fragment fields on Post {
                        isLike
                      }
                    ''',
              )).asRequest(idFields: {
                '__typename': "Post",
                'id': post.id,
              }),
              data: copyPost.toJson(),
            );
          }
          print(
            'cahce !!!!! ${cache.readFragment(
              Fragment(
                  document: parseString(
                '''
          fragment fields on Post {
          id
            isLike
            
          }
        ''',
              )).asRequest(
                idFields: {
                  '__typename': "Post",
                  'id': post.id,
                },
              ),
            )}',
          );
        };
  }

  Map<String, dynamic> expectedResult(bool isLike) {
    if (isLike) {
      return <String, dynamic>{'createLike': true};
    } else {
      return <String, dynamic>{'deleteLike': true};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        document: parseString(mutations.CREATE_LIKE),
        operationName: 'createLike',
        update: update('createLike'),
      ),
      builder: (RunMutation _likeFeed, QueryResult? likedResult) {
        likeFeed() {
          _likeFeed(
            {
              "likeInput": {
                "itemId": post.id,
                "type": "POST",
              }
            },
            optimisticResult: expectedResult(true),
          );
        }

        return Mutation(
          options: MutationOptions(
            operationName: 'deleteLike',
            document: parseString(
              mutations.DELETE_LIKE,
            ),
            update: update('deleteLike'),
          ),
          builder: (RunMutation _unlikeFeed, QueryResult? unlikedResult) {
            unlikeFeed() => _unlikeFeed(
                  {
                    "likeInput": {
                      "itemId": post.id,
                      "type": "POST",
                    }
                  },
                  optimisticResult: expectedResult(false),
                );

            return Feed(
              post: post,
              onTapLike: post.isLike! ? unlikeFeed : likeFeed,
            );
          },
        );
      },
    );
  }
}
