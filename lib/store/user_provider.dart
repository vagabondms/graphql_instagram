import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/user.dart';

const ACCESS_TOKEN = 'A-TOKEN';
const REFRESH_TOKEN = 'R-TOKEN';
const USER_INFO = 'info';

/// [UserStore] store: Hive store에 user & auth 정보 담당
class UserStore {
  static Future<void> init() async {
    await Hive.openBox('user');
  }

  final box = Hive.box('user');

  static String ACCESS_TOKEN = 'A-TOKEN';
  static String REFRESH_TOKEN = 'R-TOKEN';
  static String USER_INFO = 'info';

  String? get accessToken => box.get(ACCESS_TOKEN);
  String? get refreshToken => box.get(REFRESH_TOKEN);
  User? get userInfo => box.get(USER_INFO);

  set accessToken(String? aToken) => box.put(ACCESS_TOKEN, aToken);
  set refreshToken(String? rToken) => box.put(REFRESH_TOKEN, rToken);
  set userInfo(User? user) => box.put(USER_INFO, user);

  bool get isLoggedIn {
    final accessToken = box.get(ACCESS_TOKEN);
    final refreshToken = box.get(REFRESH_TOKEN);
    final userInfo = box.get(USER_INFO);

    return _isValidToken(accessToken) &&
        _isValidToken(refreshToken) &&
        userInfo != null;
  }

  void setUserInfo({
    required User userInfo,
    required String aToken,
    required String rToken,
  }) {
    box.put(ACCESS_TOKEN, aToken);
    box.put(REFRESH_TOKEN, rToken);
    box.put(USER_INFO, userInfo);
  }

  void removeUserInfo() {
    box.deleteAll(['A-TOKEN', 'R-TOKEN', 'INFO']);
  }

  bool _isValidToken(String? token) {
    return token != null && token.isNotEmpty;
  }
}

/// [AuthProvider] provider
class AuthProvider extends ChangeNotifier {
  final _userStore = UserStore();

  void logIn({
    required User userInfo,
    required String aToken,
    required String rToken,
  }) {
    _userStore.setUserInfo(userInfo: userInfo, aToken: aToken, rToken: rToken);
  }

  void logOut() {
    _userStore.removeUserInfo();
  }

  get isLoggedIn => _userStore.isLoggedIn;
}
