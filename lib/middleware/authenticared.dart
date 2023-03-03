import 'package:chat_app/pages/home_screen.dart';
import 'package:chat_app/pages/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends StatelessWidget {
  Auth({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return _auth.currentUser != null ? const HomeScreen() : const LoginScreen();
  }
}
