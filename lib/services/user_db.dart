import 'package:hive/hive.dart';

import '../models/user.dart';

class UserDb {
  static const String _boxName = 'users';
  static UserDb? _instance;

  factory UserDb() => _instance ??= UserDb._();
  UserDb._();

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox<User>(_boxName);
  }

  User? get currentUser => _box.get('current_user');

  bool hasUser() => _box.containsKey('current_user');

  Future<void> saveCurrentUser(User user) async {
    await _box.put('current_user', user);
  }

  Future<User?> getCurrentUser() async {
    return _box.get('current_user');
  }

  Future<void> updateUser({
    String? username,
    String? profileImagePath,
  }) async {
    final user = await getCurrentUser();
    if (user == null) return;

    await _box.put('current_user', user);
  }

  Future<void> clearUser() async {
    await _box.delete('current_user');
  }
}