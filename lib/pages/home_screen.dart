import 'package:chat_app/controller/auth_controller.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            logout().then(
              (_) => Navigator.of(context).pop(),
            );
          },
          child: const Text("Logout"),
        ),
      ),
    );
  }
}
