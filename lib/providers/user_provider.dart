import 'package:flutter/foundation.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User? get getUser {
    return _user;
  }

  Future<void> refreshUser() async {
    _user = await _authMethods.getDetailUser();
    notifyListeners();
  }
}
