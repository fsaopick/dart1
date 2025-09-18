import 'package:flutter/material.dart';

void main() {
  runApp(const GestureApp());
}

class GestureApp extends StatelessWidget {
  const GestureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GestureHomePage(),
    );
  }
}

class GestureHomePage extends StatefulWidget {
  const GestureHomePage({super.key});

  @override
  State<GestureHomePage> createState() => _GestureHomePageState();
}

class _GestureHomePageState extends State<GestureHomePage> {
  String _message = "Попробуйте жест";
  int _gestureCount = 0;
  Color _backgroundColor = Colors.white;
  final List<String> _gestureHistory = [];
  double _scale = 1.0;
  double _previousScale = 1.0;
  double _rotation = 0.0;
  
  bool _isScaling = false;
  Offset? _startPosition;
  bool _swipeDetected = false;
  bool _scaleDetected = false;

  void _handleGesture(String gesture) {
    setState(() {
      _message = gesture;
      _gestureCount++;
      _gestureHistory.insert(0, gesture);
      
      if (_gestureHistory.length > 5) {
        _gestureHistory.removeLast();
      }
    });
  }

  void _handleSwipe(String direction) {
    _handleGesture("Свайп $direction");
    
    setState(() {
      switch (direction) {
        case "влево":
          _backgroundColor = const Color.fromARGB(255, 85, 0, 255);
          break;
        case "вправо":
          _backgroundColor = const Color.fromARGB(255, 255, 0, 0);
          break;
        case "вверх":
          _backgroundColor = const Color.fromARGB(255, 136, 0, 255);
          break;
        case "вниз":
          _backgroundColor = const Color.fromARGB(255, 0, 255, 0);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(title: const Text("Отслеживание жестов")),
      body: Column(
        children: [

          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Text(
              "Счётчик жестов: $_gestureCount",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () => _handleGesture("Обнаружен тап"),
              onDoubleTap: () => _handleGesture("Двойной тап"),
              onLongPress: () => _handleGesture("Долгое нажатие обнаружено"),
              
              onScaleStart: (details) {
                _previousScale = _scale;
                _isScaling = details.pointerCount == 2;
                _startPosition = details.focalPoint;
                _swipeDetected = false;
                _scaleDetected = false;
              },
              
              onScaleUpdate: (details) {
                if (details.pointerCount == 2) {
                  _isScaling = true;
                  
                  setState(() {
                    _scale = _previousScale * details.scale;
                    _rotation = details.rotation;
                  });
                  
                  if ((details.scale - 1.0).abs() > 0.05 && !_scaleDetected) {
                    if (details.scale > 1.0) {
                      _handleGesture("Увеличение (x${_scale.toStringAsFixed(2)})");
                    } else {
                      _handleGesture("Уменьшение (x${_scale.toStringAsFixed(2)})");
                    }
                    _scaleDetected = true;
                  }
                }
                else if (details.pointerCount == 1 && !_isScaling && !_swipeDetected) {
                  final delta = details.focalPoint - _startPosition!;
                  
                  if (delta.distance > 40) {
                    if (delta.dx.abs() > delta.dy.abs()) {
                      if (delta.dx > 0) {
                        _handleSwipe("вправо");
                      } else {
                        _handleSwipe("влево");
                      }
                    } else {
                      if (delta.dy > 0) {
                        _handleSwipe("вниз");
                      } else {
                        _handleSwipe("вверх");
                      }
                    }
                    _swipeDetected = true;
                  }
                }
              },
              
              onScaleEnd: (details) {
                _isScaling = false;
                _previousScale = _scale;
                _startPosition = null;
                _swipeDetected = false;
                _scaleDetected = false;
              },
              
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scale(_scale)
                  ..rotateZ(_rotation),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Center(
                    child: Text(
                      _message,
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Последние 5 жестов:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _gestureHistory.isEmpty
                    ? const Text("Жестов пока нет")
                    : Column(
                        children: _gestureHistory
                            .map((gesture) => Text("• $gesture"))
                            .toList(),
                      ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => setState(() {
                _backgroundColor = Colors.white;
                _scale = 1.0;
                _rotation = 0.0;
              }),
              child: const Text("Сбросить цвет фона"),
            ),
          ),
        ],
      ),
    );
  }
}