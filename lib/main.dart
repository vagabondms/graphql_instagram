import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_instagram/graphql/config.dart';
import 'package:graphql_instagram/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'store/user_provider.dart';

void main() async {
  await initHiveForFlutter();

  /// initiate Hive userStore
  await UserStore.init();

  runApp(
    GraphQLProvider(
      client: Config.initializeClient(
        token: '',
        store: HiveStore(),
      ),
      child: ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        child: const MaterialApp(
          home: MainScreen(),
        ),
      ),
    ),
  );
}
