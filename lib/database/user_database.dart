import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/models/user_model.dart';

class UserDatabase {
  static const String _usersKey = 'users';

  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  static Future<List<User>> getAllUsers() async {
    final prefs = await _prefs;
    final String? usersString = prefs.getString(_usersKey);
    if (usersString != null) {
      final List<dynamic> jsonList = jsonDecode(usersString);
      return jsonList.map((json) => User.fromJson(json)).toList();
    }
    return [];
  }

  static Future<void> saveUser(User user) async {
    final prefs = await _prefs;
    final users = await getAllUsers();
    users.add(user);
    await prefs.setString(_usersKey, jsonEncode(users.map((u) => u.toJson()).toList()));
  }

  static Future<bool> isEmailUnique(String email) async {
    final users = await getAllUsers();
    return !users.any((user) => user.email == email);
  }

  static Future<bool> isUsernameUnique(String username) async {
    final users = await getAllUsers();
    return !users.any((user) => user.username == username);
  }

  static Future<User?> authenticateUser(String emailOrUsername, String password) async {
    final users = await getAllUsers();
    try {
      return users.firstWhere(
        (user) =>
            (user.email == emailOrUsername || user.username == emailOrUsername) &&
            user.password == password,
      );
    } catch (e) {
      return null;
    }
  }
}