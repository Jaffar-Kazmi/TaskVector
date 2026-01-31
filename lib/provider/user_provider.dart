import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_db.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = true;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    _user = await UserDb().getCurrentUser();
    _isLoading = false;
    notifyListeners();
  }
}
