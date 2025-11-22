import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static const String _userKey = 'users';
  static const String _transactionKey = 'transactions';
  static const String _currentUserKey = 'current_user';
  static const String _isLoggedInKey = 'isLoggedIn';

  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  // User operations
  static Future<void> saveUsers(List<Map<String, dynamic>> users) async {
    final prefs = await _prefs;
    await prefs.setString(_userKey, jsonEncode(users));
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final prefs = await _prefs;
    final String? usersString = prefs.getString(_userKey);
    if (usersString != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(usersString));
    }
    return [];
  }

  // Transaction operations
  static Future<void> saveTransactions(List<Map<String, dynamic>> transactions) async {
    final prefs = await _prefs;
    await prefs.setString(_transactionKey, jsonEncode(transactions));
  }

  static Future<List<Map<String, dynamic>>> getTransactions() async {
    final prefs = await _prefs;
    final String? transactionsString = prefs.getString(_transactionKey);
    if (transactionsString != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(transactionsString));
    }
    return [];
  }

  // Current user operations
  static Future<void> saveCurrentUser(Map<String, dynamic> user) async {
    final prefs = await _prefs;
    await prefs.setString(_currentUserKey, jsonEncode(user));
    await prefs.setBool(_isLoggedInKey, true);
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await _prefs;
    final String? userString = prefs.getString(_currentUserKey);
    if (userString != null) {
      return Map<String, dynamic>.from(jsonDecode(userString));
    }
    return null;
  }

  static Future<void> clearCurrentUser() async {
    final prefs = await _prefs;
    await prefs.remove(_currentUserKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
}