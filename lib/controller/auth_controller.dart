import 'package:firebase_auth/firebase_auth.dart';

Future<User?> createAccount(String name, String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    User? user = (await auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print("login success");
    } else {
      print("login fail");
    }
    return user;
  } catch (err) {
    rethrow;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    User? user = (await auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      print("login success");
    } else {
      print("login fail");
    }
    return user;
  } catch (err) {
    rethrow;
  }
}

Future<User?> logout() async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    await auth.signOut();
  } catch (err) {
    rethrow;
  }
}
