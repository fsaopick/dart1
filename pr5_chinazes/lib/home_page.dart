import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class HomePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  final AuthService _authService = AuthService();

  Future<void> _signOut(BuildContext context) async {
    await _authService.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная страница'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Добро пожаловать!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            if (user != null) ...[
              Text('Email: ${user!.email}'),
              SizedBox(height: 8),
              Text('UID: ${user!.uid}'),
            ],
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _signOut(context),
              child: Text('Выйти'),
            ),
          ],
        ),
      ),
    );
  }
}