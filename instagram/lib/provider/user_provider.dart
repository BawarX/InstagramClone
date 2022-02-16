import 'package:flutter/material.dart';
import 'package:instagram/model/user.dart';
import 'package:instagram/resources/auth_methods.dart';

class UserProvider with ChangeNotifier{// this will cause bugs wathc out 
User? _user;// make sure its private
final AuthMethods _authMethods = AuthMethods();
User get getUser => _user!;

Future<void> refreshUser() async {
  User user = await _authMethods.getUserDetails();
  _user = user;
  notifyListeners();
}
}