import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/post.dart';

class StorageService {
  static const String _postsKey = 'cached_posts';
  static const String _readPostsKey = 'read_posts';

  static Future<void> savePosts(List<Post> posts) async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = posts.map((post) => post.toJson()).toList();
    await prefs.setString(_postsKey, json.encode(postsJson));
  }

  static Future<List<Post>> getPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = prefs.getString(_postsKey);
    
    if (postsJson == null) {
      return _generateUniquePosts();
    }
    
    try {
      final List<dynamic> jsonList = json.decode(postsJson);
      final readPosts = await _getReadPosts();
      
      return jsonList.map((json) {
        final post = Post.fromJson(json);
        return post.copyWith(isRead: readPosts.contains(post.id));
      }).toList();
    } catch (e) {
      return _generateUniquePosts();
    }
  }

  static Future<void> markAsRead(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final readPosts = await _getReadPosts();
    readPosts.add(postId);
    await prefs.setStringList(_readPostsKey, readPosts.map((id) => id.toString()).toList());
    
    final posts = await getPosts();
    final updatedPosts = posts.map((post) => 
      post.id == postId ? post.copyWith(isRead: true) : post
    ).toList();
    await savePosts(updatedPosts);
  }

  static Future<Set<int>> _getReadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final readPostsList = prefs.getStringList(_readPostsKey) ?? [];
    return readPostsList.map((id) => int.parse(id)).toSet();
  }

  static List<Post> _generateUniquePosts() {
    final now = DateTime.now();
    final List<Post> posts = [];
    
    final newsData = [
      {
        'title': 'PixelOS: новая эра дизайна',
        'content': 'RetroTech анонсировала PixelOS - операционную систему с уникальным пиксельным интерфейсом. Пользователи отмечают необычный, но приятный опыт использования.',
        'author': 'Техноблогер'
      },
      {
        'title': 'Ретро-игры побили рекорды',
        'content': 'Продажи классических игр выросли на 300% в прошлом квартале. Молодежь активно интересуется игровым наследием 80-90х годов.',
        'author': 'Игровой аналитик'
      },
      {
        'title': 'Пиксели в банковских приложениях',
        'content': 'Крупные банки внедряют элементы пиксель-арта в свои мобильные приложения. Неожиданный тренд объясняется ростом популярности ностальгического дизайна.',
        'author': 'Финансовый эксперт'
      },
      {
        'title': 'Мастер-класс по пиксельной анимации',
        'content': 'Известный аниматор проведет бесплатный воркшоп по созданию плавного движения в пиксельном стиле. Регистрация уже открыта на официальном сайте.',
        'author': 'Аниматор'
      },
      {
        'title': 'Эволюция компьютерной графики',
        'content': 'От первых мониторов с зеленым текстом до современных OLED-экранов. Как технологии изменили наше визуальное восприятие за 40 лет развития.',
        'author': 'IT-историк'
      },
      {
        'title': 'Топ-5 инструментов для пиксель-арта',
        'content': 'Мы протестировали 12 популярных программ и выбрали лучшие для разных уровней подготовки. От простых редакторов до профессиональных студий.',
        'author': 'Обозреватель'
      },
      {
        'title': 'Пиксели улучшают пользовательский опыт',
        'content': 'Согласно исследованию Стэнфордского университета, интерфейсы в пиксельном стиле снижают когнитивную нагрузку на пользователей.',
        'author': 'UX-аналитик'
      },
      {
        'title': 'Классические консоли возвращаются',
        'content': 'Nintendo готовит к выпуску обновленную версию легендарной консоли с поддержкой современных стандартов подключения.',
        'author': 'Игровой журналист'
      },
      {
        'title': 'Pixel Perfect - новый стандарт',
        'content': 'Методика точной пиксельной верстки становится отраслевым стандартом. Крупные компании уже переходят на эту технологию.',
        'author': 'Веб-разработчик'
      },
      {
        'title': 'Создание игры: от идеи до релиза',
        'content': 'Подробное руководство по разработке пиксельной игры на популярном движке Unity. Все этапы от концепции до публикации.',
        'author': 'Геймдев-эксперт'
      },
    ];

    for (int i = 0; i < newsData.length; i++) {
      final hoursAgo = (i + 1) * 3;
      final postDate = now.subtract(Duration(hours: hoursAgo));
      
      posts.add(Post(
        id: i + 1,
        title: newsData[i]['title']!,
        content: newsData[i]['content']!,
        author: newsData[i]['author']!,
        date: postDate,
      ));
    }
    
    return posts;
  }
}