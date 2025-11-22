import 'package:shared_preferences/shared_preferences.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/database/user_database.dart';
import 'package:utspam_if5a_3012310021_filmbioskop/models/user_model.dart';

class AuthService {
  static Future<bool> register(User user) async {
    // Check if email and username are unique
    final isEmailUnique = await UserDatabase.isEmailUnique(user.email);
    final isUsernameUnique = await UserDatabase.isUsernameUnique(user.username);

    if (!isEmailUnique || !isUsernameUnique) {
      return false;
    }

    // Save user to database
    await UserDatabase.saveUser(user);
    return true;
  }

  static Future<User?> login(String emailOrUsername, String password) async {
    // Authenticate user
    final user = await UserDatabase.authenticateUser(emailOrUsername, password);
    
    if (user != null) {
      // Save current user session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', user.username);
      await prefs.setBool('isLoggedIn', true);
    }
    
    return user;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    await prefs.setBool('isLoggedIn', false);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<String?> getCurrentUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('current_user');
  }

  static Future<User?> getCurrentUser() async {
    final username = await getCurrentUsername();
    if (username == null) return null;
    
    final users = await UserDatabase.getAllUsers();
    try {
      return users.firstWhere((user) => user.username == username);
    } catch (e) {
      return null;
    }
  }
}