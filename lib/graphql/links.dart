import 'dart:convert';
import 'dart:io';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_instagram/store/user_provider.dart';
import "package:http/http.dart" as http;

final URL = Uri.https('59e2-114-201-54-135.jp.ngrok.io', 'graphql');

class Links {
  final String dummyEnv;

  const Links(this.dummyEnv);

  static final HttpLink httpLink = HttpLink(
    URL.toString(),
  );

  static final AuthLink authLink = AuthLink(
    getToken: () async {
      final String? accessToken = UserStore().accessToken;
      return accessToken;
    },
    headerKey: "A-TOKEN",
  );

  static const Link reissueTokenLink =
      _ReissueTokenLink(_ReissueTokenLink.handleException);

  static const Link errorLoggerLink =
      _ErrorLogLink(_ErrorLogLink.handleException);

  static final DedupeLink dedupeLink = DedupeLink();

  static final LoggerLink loggerLink = LoggerLink();

  Link generateLink() {
    bool isDevelopment = dummyEnv == 'Development';

    return Link.from([
      if (isDevelopment) ...[loggerLink, errorLoggerLink],
      dedupeLink,
      authLink,
      reissueTokenLink,
      httpLink
    ]);
  }
}

class AuthToken extends ContextEntry {
  final String token;

  const AuthToken({required this.token});

  @override
  List<Object> get fieldsForEquality => [];
}

class _ReissueTokenLink extends ErrorLink {
  const _ReissueTokenLink(ExceptionHandler onException)
      : super(onException: onException);

  static Stream<Response> handleException(
      Request request, NextLink forward, LinkException exception) async* {
    // 만약 토큰 에러 status 면?

    if (exception is ServerException &&
        Map.from(exception.parsedResponse!.response)['status'] == 401) {
      print(
          'reissue request starts cause status ${(exception.parsedResponse!.response)["status"]}');

      final String? refreshToken = UserStore().refreshToken;

      late String newAccessToken;

      try {
        newAccessToken =
            await _ReissueToken(URL).getToken(refreshToken ?? '') ?? '';
        UserStore.ACCESS_TOKEN = newAccessToken;
      } catch (e) {
        print(e);
      }

      final updatedRequest =
          request.withContextEntry<HttpLinkHeaders>(HttpLinkHeaders(headers: {
        'a-token': newAccessToken,
      }));
      print(updatedRequest.context.toString());

      print('try request again!');
      yield* forward(updatedRequest);
      return;
    }
    throw exception;
  }
}

class _ErrorLogLink extends ErrorLink {
  const _ErrorLogLink(ExceptionHandler onException)
      : super(onException: onException);

  static Stream<Response> handleException(
      Request request, NextLink forward, LinkException exception) async* {
    // 만약 토큰 에러 status 면?

    if (exception is ServerException) {
      print(Map.from(exception.parsedResponse!.response)['status']);
    }
  }
}

class LoggerLink extends Link {
  LoggerLink();

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    final startTime = DateTime.now();

    print('Operation ${request.operation.operationName} starts at $startTime');

    // context 세팅방법 생각해보기 request.context.

    Stream<Response> response = forward!(request).map((Response fetchResult) {
      final ioStreamedResponse =
          fetchResult.context.entry<HttpLinkResponseContext>();

      // 위에서 context setting 해서 받을 수 있는 방법 찾아보기.
      final endTime = DateTime.now().difference(startTime);

      print(
          'Operation ${request.operation.operationName} took ${endTime} to complete');

      return fetchResult;
    });

    return response;
  }
}

class _ReissueToken {
  final Uri url;

  _ReissueToken(this.url);

  Future<String> getToken(
    String rToken,
  ) async {
    final res = await http.post(url,
        body: jsonEncode({
          "operationName": "getATokenByRToken",
          "query": "mutation getATokenByRToken{\n  getATokenByRToken\n}",
        }),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          "r-token": rToken,
        });

    return jsonDecode(res.body)['data']?['getATokenByRToken'];
  }
}
