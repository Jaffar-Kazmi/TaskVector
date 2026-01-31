import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 4)
class User extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String? profileImagePath;

  User({
    required this.username,
    this.profileImagePath,
  });
}