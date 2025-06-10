import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AnimationDemo(),
    );
  }
}

class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo> with SingleTickerProviderStateMixin {
  bool _showFirst = false;
  bool _showSecond = false;
  double _containerSize = 100.0;
  Color _containerColor = Colors.blue;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  final ScrollController _scrollController = ScrollController();
  double _parallaxOffset = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * 3.1415).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scrollController.addListener(() {
      setState(() {
        _parallaxOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleFirst() {
    setState(() {
      _showFirst = !_showFirst;
    });
  }

  void _toggleSecond() {
    setState(() {
      _showSecond = !_showSecond;
      _containerSize = _showSecond ? 150.0 : 100.0;
      _containerColor = _showSecond ? Colors.green : Colors.blue;
    });
  }

  void _toggleExplicitAnimation() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Анимации'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Имплицитные анимации',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _toggleFirst,
                    child: Text(_showFirst ? 'Скрыть' : 'Показать'),
                  ),
                  AnimatedOpacity(
                    opacity: _showFirst ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: const FlutterLogo(size: 100),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _toggleSecond,
                    child: Text(_showSecond ? 'Уменьшить' : 'Увеличить'),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    width: _containerSize,
                    height: _containerSize,
                    color: _containerColor,
                    curve: Curves.easeInOutBack,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Явные анимации',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _toggleExplicitAnimation,
                    child: Text(_controller.isAnimating ? 'Стоп' : 'Запуск'),
                  ),
                  const SizedBox(height: 20),
                  Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: const Icon(Icons.star, size: 100, color: Colors.amber),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Параллакс эффект',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text('Прокрутите вниз для эффекта параллакса'),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 50 + _parallaxOffset * 0.3,
                          left: 20,
                          child: const FlutterLogo(size: 100),
                        ),
                        Positioned(
                          top: 100 + _parallaxOffset * 0.6,
                          right: 30,
                          child: const Icon(Icons.cloud, size: 80, color: Colors.blue),
                        ),
                        Positioned(
                          top: 180 + _parallaxOffset * 0.9,
                          left: 50,
                          child: Container(
                            width: 200,
                            height: 100,
                            color: Colors.green,
                            child: const Center(
                              child: Text('Параллакс эффект', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 400), 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}