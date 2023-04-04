import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      );
    }
    return user;
  } on FirebaseAuthException {
    rethrow;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    User? user = (await auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    return user;
  } on FirebaseAuthException {
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

Future<void> updateProfile(String photoUrl) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    await auth.currentUser!.updatePhotoURL(photoUrl);
  } on FirebaseAuthException {
    rethrow;
  }
}
