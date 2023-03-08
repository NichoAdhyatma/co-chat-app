import 'package:chat_app/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<User?> createAccount(String name, String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  try {
    User? user = (await auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      user.updateDisplayName(name);

      await fireStore.collection("users").doc(auth.currentUser?.uid).set(
        {
          "name": name,
          "email": email,
          "status": "Unavailable",
          "uid": auth.currentUser!.uid,
        },
      ).onError((error, stackTrace) => print(error));
    } else {
      print("login fail");
    }
    return user;
  } on FirebaseAuthException catch (e) {
    print('Failed with error code: ${e.code}');
    print(e.message);
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
  } on FirebaseAuthException catch (e) {
    rethrow;
  }
}

Future<void> logout() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .update({"status": "offline"}).then(
      (value) => auth.signOut(),
    );
  } catch (err) {
    rethrow;
  }
}
