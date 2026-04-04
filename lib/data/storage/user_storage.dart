import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../core/constants/app_constants.dart';
import '../models/user_profile.dart';

class UserStorage {
  static const String _themeDirName = 'user_theme';
  static const String _profileFileName = 'profile.json';

  Future<void> init() async {
    final dir = await _getThemeDirectory();
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  Future<Directory> _getThemeDirectory() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    return Directory(path.join(documentsDir.path, _themeDirName));
  }

  Future<String> _getProfilePath() async {
    final dir = await _getThemeDirectory();
    return path.join(dir.path, _profileFileName);
  }

  Future<void> saveProfile(UserProfile profile) async {
    final filePath = await _getProfilePath();
    final file = File(filePath);
    final jsonString = json.encode(profile.toJson());
    await file.writeAsString(jsonString);
  }

  Future<UserProfile?> loadProfile() async {
    final filePath = await _getProfilePath();
    final file = File(filePath);
    if (!await file.exists()) return null;
    final jsonString = await file.readAsString();
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    return UserProfile.fromJson(jsonMap);
  }

  Future<bool> exists() async {
    final filePath = await _getProfilePath();
    final file = File(filePath);
    return await file.exists();
  }

  Future<void> deleteProfile() async {
    final filePath = await _getProfilePath();
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
