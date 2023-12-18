import 'package:bookmate/azmy/models/profile.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  LoginUser? _user;

  LoginUser? get user => _user;

  void setUser(LoginUser user) {
    _user = user;
    notifyListeners();
  }
}