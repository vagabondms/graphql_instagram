import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

const ACCESS_TOKEN = 'A-TOKEN';
const REFRESH_TOKEN = 'R-TOKEN';

/// [UserStore] store: Hive store에 user & auth 정보 담당
class UserStore {
  static Future<void> init() async {
    await Hive.openBox('user');
  }

  final box = Hive.box('user');

  static String ACCESS_TOKEN = 'A-TOKEN';
  static String REFRESH_TOKEN = 'R-TOKEN';

  String? get accessToken => box.get(ACCESS_TOKEN);
  String? get refreshToken => box.get(REFRESH_TOKEN);

  set accessToken(String? aToken) => box.put(ACCESS_TOKEN, aToken);
  set refreshToken(String? rToken) => box.put(REFRESH_TOKEN, rToken);

  bool get isLoggedIn {
    final accessToken = box.get(ACCESS_TOKEN);
    final refreshToken = box.get(REFRESH_TOKEN);

    return _isValidToken(accessToken) && _isValidToken(refreshToken);
  }

  void setUserInfo({
    required String aToken,
    required String rToken,
  }) {
    box.put(ACCESS_TOKEN, aToken);
    box.put(REFRESH_TOKEN, rToken);
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
    required String aToken,
    required String rToken,
  }) {
    _userStore.setUserInfo(aToken: aToken, rToken: rToken);
    notifyListeners();
  }

  void logOut() {
    _userStore.removeUserInfo();
    notifyListeners();
  }

  get isLoggedIn => _userStore.isLoggedIn;
}
