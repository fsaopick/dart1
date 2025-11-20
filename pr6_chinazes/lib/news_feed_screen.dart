import 'package:flutter/material.dart';
import 'models/post.dart';
import 'services/storage.dart';
import 'widgets/post_card.dart';
import 'widgets/loading.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  List<Post> _posts = [];
  bool _isLoading = true;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _postsPerPage = 5;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadInitialPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 50) {
      _loadMorePosts();
    }
  }

  Future<void> _loadInitialPosts() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    
    final posts = await StorageService.loadPosts();
    
    setState(() {
      _posts = posts;
      _isLoading = false;
      _hasMore = posts.length > _postsPerPage;
    });
  }

  Future<void> _loadMorePosts() async {
    if (_isLoading || !_hasMore) return;
    
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _currentPage++;
      _isLoading = false;
      _hasMore = _posts.length > _currentPage * _postsPerPage;
    });
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _currentPage = 1;
      _hasMore = true;
    });
    await _loadInitialPosts();
  }

  void _showPostDetails(Post post) async {
    // Отмечаем как прочитанный
    if (!post.isRead) {
      await StorageService.markAsRead(post.id);
      setState(() {
        final index = _posts.indexWhere((p) => p.id == post.id);
        if (index != -1) {
          _posts[index] = post.copyWith(isRead: true);
        }
      });
    }

    // Показываем детали
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Courier',
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Полный текст
              SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  child: Text(
                    post.content,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Courier',
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Информация
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF666666)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF666666)),
                      ),
                      child: Text(
                        post.author,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF666666),
                          fontFamily: 'Courier',
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(post.date),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF666666),
                        fontFamily: 'Courier',
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Кнопка закрытия
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Text(
                        'ЗАКРЫТЬ',
                        style: TextStyle(
                          fontFamily: 'Courier',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} мин назад';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} часов назад';
    } else {
      return '${difference.inDays} дней назад';
    }
  }

  List<Post> get _visiblePosts {
    final startIndex = 0;
    final endIndex = _currentPage * _postsPerPage;
    return _posts.sublist(
      startIndex,
      endIndex < _posts.length ? endIndex : _posts.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ПИКСЕЛЬНЫЕ НОВОСТИ',
          style: TextStyle(
            fontFamily: 'Courier',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _isLoading && _posts.isEmpty
          ? const Center(child: PixelLoading())
          : RefreshIndicator(
              onRefresh: _refreshPosts,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _visiblePosts.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _visiblePosts.length) {
                    return _hasMore ? const PixelLoading() : const SizedBox();
                  }
                  
                  final post = _visiblePosts[index];
                  return PostCard(
                    post: post,
                    onTap: () => _showPostDetails(post),
                  );
                },
              ),
            ),
    );
  }
}