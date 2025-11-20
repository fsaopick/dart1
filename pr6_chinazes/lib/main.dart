import 'package:flutter/material.dart';
import 'package:pixel_news_feed/news_feed_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Пиксельные Новости',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const NewsFeedScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}