// lib/services/user_service.dart
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _keyUserData = 'user_data';

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserData, json.encode(userData));
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_keyUserData);
    if (userDataString != null) {
      return json.decode(userDataString) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserData);
  }

  // Add this method to display user data in debug console
  static Future<void> debugUserData() async {
    final userData = await getUserData();
    if (userData != null) {
      developer.log('User Data: ${json.encode(userData)}', name: 'UserService');
      print('User Data: $userData');
    } else {
      developer.log('No user data found', name: 'UserService');
      print('No user data found');
    }
  }
}
