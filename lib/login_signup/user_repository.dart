import 'package:bcrypt/bcrypt.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newsapp/login_signup/JsonModels/users.dart';
import 'dart:io';

class UserRepository {
  static const String _boxName = 'users';
  static const String _currentUserKey = 'current_user';
  static const String _profileImageKey = 'profile_image_';
  late Box<Map<dynamic, dynamic>> _userBox;
  late SharedPreferences _prefs;

  // Initialize Hive and SharedPreferences
  Future<void> init() async {
    await Hive.initFlutter();
    _userBox = await Hive.openBox<Map<dynamic, dynamic>>(_boxName);
    _prefs = await SharedPreferences.getInstance();
  }

  // Register new user
  Future<bool> register(Users user) async {
    // Check if username already exists
    if (await getUser(user.usrName) != null) {
      return false;
    }

    // Hash password
    String hashedPassword = BCrypt.hashpw(user.usrPassword, BCrypt.gensalt());
    
    // Create user map
    Map<String, dynamic> userMap = {
      'usrName': user.usrName,
      'usrPassword': hashedPassword,
      'nama': user.nama ?? user.usrName, // Default nama sama dengan username jika tidak diisi
    };

    // Save to Hive
    await _userBox.put(user.usrName, userMap);
    return true;
  }

  // Login user
  Future<bool> login(Users user) async {
    Map<dynamic, dynamic>? userData = _userBox.get(user.usrName);
    
    if (userData != null) {
      String storedHash = userData['usrPassword'] as String;
      if (BCrypt.checkpw(user.usrPassword, storedHash)) {
        // Save current user to SharedPreferences
        await _prefs.setString(_currentUserKey, user.usrName);
        return true;
      }
    }
    return false;
  }

  // Get user by username
  Future<Users?> getUser(String username) async {
    Map<dynamic, dynamic>? userData = _userBox.get(username);
    if (userData != null) {
      return Users(
        usrName: userData['usrName'],
        usrPassword: userData['usrPassword'],
        nama: userData['nama'],
      );
    }
    return null;
  }

  // Get current logged in user
  Future<String?> getCurrentUser() async {
    return _prefs.getString(_currentUserKey);
  }

  // Update user profile
  Future<bool> updateProfile(String username, String newNama) async {
    Map<dynamic, dynamic>? userData = _userBox.get(username);
    if (userData != null) {
      userData['nama'] = newNama;
      await _userBox.put(username, userData);
      return true;
    }
    return false;
  }

  // Save profile image path
  Future<void> saveProfileImage(String username, String imagePath) async {
    await _prefs.setString(_profileImageKey + username, imagePath);
  }

  // Get profile image path
  Future<String?> getProfileImagePath(String username) async {
    return _prefs.getString(_profileImageKey + username);
  }

  // Logout user
  Future<void> logout() async {
    await _prefs.remove(_currentUserKey);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return _prefs.containsKey(_currentUserKey);
  }
} 