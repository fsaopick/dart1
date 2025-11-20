import 'package:flutter/material.dart';
import '../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
  });

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: post.isRead ? const Color(0xFFF0F0F0) : Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Courier',
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Краткое содержание
              Text(
                _getPreview(post.content),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF333333),
                  fontFamily: 'Courier',
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Информация
              Row(
                children: [
                  // Автор
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
                  
                  const SizedBox(width: 8),
                  
                  // Время
                  Text(
                    _formatDate(post.date),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF666666),
                      fontFamily: 'Courier',
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Индикатор прочитанного
                  if (post.isRead) 
                    const Icon(
                      Icons.check,
                      size: 14,
                      color: Color(0xFF666666),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPreview(String content) {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }
}