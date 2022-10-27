import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_instagram/graphql/links.dart';

class Config {
  static late String _token;

  static ValueNotifier<GraphQLClient> initializeClient({
    required String token,
    Store? store,
  }) {
    _token = token;
    ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
      link: Links('Development').generateLink(),
      cache: GraphQLCache(store: store),
    ));

    return client;
  }
}
