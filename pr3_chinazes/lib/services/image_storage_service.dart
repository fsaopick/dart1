import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageStorageService {
  static const String _avatarKey = 'avatar_path';

  Future<String?> getAvatarPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarKey);
  }

  Future<String> saveAvatar(String imagePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedPath = path.join(appDir.path, fileName);

    // Копируем файл в постоянное хранилище
    final File imageFile = File(imagePath);
    await imageFile.copy(savedPath);

    // Сохраняем путь в SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarKey, savedPath);

    return savedPath;
  }

  Future<void> deleteAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final currentPath = prefs.getString(_avatarKey);
    
    if (currentPath != null) {
      final file = File(currentPath);
      if (await file.exists()) {
        await file.delete();
      }
    }
    
    await prefs.remove(_avatarKey);
  }
}