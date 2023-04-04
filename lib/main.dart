import 'package:chat_app/middleware/authenticared.dart';
import 'package:chat_app/pages/chat_room.dart';
import 'package:chat_app/pages/create_account.dart';
import 'package:chat_app/pages/home_screen.dart';
import 'package:chat_app/pages/login_screen.dart';
import 'package:chat_app/pages/select_avatar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: Auth(),
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        CreateAccount.routeName: (context) => const CreateAccount(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        ChatRoom.routeName: (context) => const ChatRoom(),
        SelectAvatar.routeName: (context) => const SelectAvatar(),
        
      },
    );
  }
}
