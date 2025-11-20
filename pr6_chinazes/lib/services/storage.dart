import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/post.dart';

class StorageService {
  static const String _postsKey = 'posts_data';
  static const String _readKey = 'read_posts';

  // Сохранить посты
  static Future<void> savePosts(List<Post> posts) async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = posts.map((post) => post.toJson()).toList();
    await prefs.setString(_postsKey, json.encode(postsJson));
  }

  // Загрузить посты
  static Future<List<Post>> loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = prefs.getString(_postsKey);
    
    if (postsJson == null) {
      final newPosts = _createDefaultPosts();
      await savePosts(newPosts);
      return newPosts;
    }
    
    try {
      final List<dynamic> jsonList = json.decode(postsJson);
      final readPosts = await _loadReadPosts();
      
      return jsonList.map((json) {
        final post = Post.fromJson(json);
        return post.copyWith(isRead: readPosts.contains(post.id));
      }).toList();
    } catch (e) {
      final newPosts = _createDefaultPosts();
      await savePosts(newPosts);
      return newPosts;
    }
  }

  // Отметить пост как прочитанный
  static Future<void> markAsRead(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final readPosts = await _loadReadPosts();
    readPosts.add(postId);
    await prefs.setStringList(_readKey, readPosts.map((id) => id.toString()).toList());
  }

  // Загрузить список прочитанных постов
  static Future<Set<int>> _loadReadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final readList = prefs.getStringList(_readKey) ?? [];
    return readList.map((id) => int.parse(id)).toSet();
  }

  // Создать демо-посты
  static List<Post> _createDefaultPosts() {
    final now = DateTime.now();
    return [
      Post(
        id: 1,
        title: 'PixelOS вышла в релиз',
        content: 'Новая операционная система с пиксельным дизайном теперь доступна для всех пользователей. Интерфейс напоминает классические системы 80-х годов.',
        author: 'Техноблогер',
        date: now.subtract(const Duration(hours: 2)),
      ),
      Post(
        id: 2,
        title: 'Ретро игры снова в моде',
        content: 'Продажи классических игр выросли на 250% за последний год. Молодое поколение открывает для себя чарующий мир пиксельной графики.',
        author: 'Игровой журнал',
        date: now.subtract(const Duration(hours: 5)),
      ),
      Post(
        id: 3,
        title: 'Пиксельный дизайн в мобильных приложениях',
        content: 'Крупные компании начинают использовать элементы пиксель-арта в своих продуктах. Это добавляет уникальности и ностальгического шарма.',
        author: 'Дизайн эксперт',
        date: now.subtract(const Duration(hours: 8)),
      ),
      Post(
        id: 4,
        title: 'Мастер-класс по созданию пиксельной графики',
        content: 'Известный художник проведет бесплатный онлайн-воркшоп для всех желающих научиться создавать пиксельное искусство с нуля.',
        author: 'Художественная школа',
        date: now.subtract(const Duration(hours: 12)),
      ),
      Post(
        id: 5,
        title: 'Новые инструменты для пиксель-арта',
        content: 'Вышло обновление популярной программы для создания пиксельной графики. Добавлены новые кисти и палитры цветов.',
        author: 'Разработчик ПО',
        date: now.subtract(const Duration(hours: 16)),
      ),
      Post(
        id: 6,
        title: 'Пиксельные шрифты возвращаются',
        content: 'Дизайнеры возрождают искусство создания bitmap-шрифтов. Новые гарнитуры сочетают в себе ретро-стиль и современную читаемость.',
        author: 'Типограф',
        date: now.subtract(const Duration(hours: 20)),
      ),
      Post(
        id: 7,
        title: 'Создание игрового персонажа в пиксельном стиле',
        content: 'Пошаговое руководство по созданию уникального героя для игр. От эскиза до анимации - все этапы разработки.',
        author: 'Геймдизайнер',
        date: now.subtract(const Duration(hours: 24)),
      ),
      Post(
        id: 8,
        title: 'Оптимизация пиксельной графики',
        content: 'Советы по уменьшению размера файлов без потери качества. Важные техники для веб-разработчиков и мобильных приложений.',
        author: 'Технический специалист',
        date: now.subtract(const Duration(days: 2)),
      ),
      Post(
        id: 9,
        title: 'Цветовые палитры ретро-стиля',
        content: 'Обзор классических цветовых схем из эпохи 8-битных компьютеров. Как использовать их в современных проектах.',
        author: 'Колорист',
        date: now.subtract(const Duration(days: 3)),
      ),
      Post(
        id: 10,
        title: 'Будущее пиксельной графики',
        content: 'Эксперты обсуждают перспективы развития пиксель-арта в эпоху искусственного интеллекта и высоких разрешений.',
        author: 'Арт-критик',
        date: now.subtract(const Duration(days: 4)),
      ),
    ];
  }
}