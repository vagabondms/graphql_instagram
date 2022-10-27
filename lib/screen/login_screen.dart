import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gql/language.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_instagram/models/user.dart';
import 'package:provider/provider.dart';

import '../graphql/queries/mutations.dart';
import '../store/user_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SvgPicture.asset(
                'asset/svgs/logo.svg',
                width: 200,
              ),
              const SizedBox(height: 20.0),
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _idField = TextEditingController();
  final _passwordField = TextEditingController();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _idField,
          decoration: const InputDecoration(
            filled: true,
            labelText: 'Id',
          ),
        ),
        SizedBox(height: 12.0),
        TextField(
          controller: _passwordField,
          decoration: InputDecoration(
            filled: true,
            labelText: 'Password',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ),
          obscureText: _passwordVisible,
        ),
        SizedBox(height: 12.0),
        Mutation(
            options: MutationOptions(
                document: parseString(LOG_IN),
                operationName: "login",
                onCompleted: (resultData) async {
                  if (resultData != null) {
                    final queryResult =
                        Map<String, dynamic>.from(resultData)['login'];
                    final String? accessToken = queryResult['accessToken'];
                    final String? refreshToken = queryResult['refreshToken'];

                    if (accessToken != null && refreshToken != null) {
                      //TODO: change using Provider and Hive Store
                      context.read<AuthProvider>().logIn(
                          userInfo: User.fromJson({'id': 1}),
                          aToken: accessToken,
                          rToken: refreshToken);
                    }
                  }
                }),
            builder: (RunMutation runMutation, queryResult) {
              final isLoading = queryResult != null && queryResult.isLoading!;
              final exception =
                  queryResult != null && queryResult.hasException!;
              print(exception);
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(
                      40), // fromHeight use double.infinity as width and 40 is the height
                ),
                onPressed: () {
                  runMutation({
                    'email': _idField.text,
                    'password': _passwordField.text
                  });
                },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : exception
                        ? const Text('다시')
                        : const Text('로그인'),
              );
            }),
        // ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //       minimumSize: Size.fromHeight(
        //           40), // fromHeight use double.infinity as width and 40 is the height
        //     ),
        //     onPressed: () {},
        //     child: Text('로그인'))
      ],
    );
  }
}
