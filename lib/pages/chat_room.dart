import 'dart:io';

import 'package:chat_app/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class ChatRoom extends StatelessWidget {
  static const routeName = '/chat';
  final TextEditingController message = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic> user = {};

  ChatRoom({super.key});
  String roomId = "";

  File? imageFile;

  Future getImage() async {
    ImagePicker picker = ImagePicker();

    await picker.pickImage(source: ImageSource.gallery).then(
      (xFile) {
        if (xFile != null) {
          imageFile = File(xFile.path);
          print(imageFile);
          uploadImage();
        }
      },
    );
  }

  Future uploadImage() async {
    String fileName = const Uuid().v1();
    var ref =
        FirebaseStorage.instance.ref().child("images").child("$fileName.jpg");
    var uploadTask = await ref.putFile(imageFile!);
    // String imageUrl = uploadTask.ref.getDownloadURL() as String;
    // print(imageUrl);
  }

  void onSendMessage() async {
    Map<String, dynamic> messages = {
      "sendby": auth.currentUser?.displayName,
      "message": message.text,
      "time": FieldValue.serverTimestamp(),
    };

    if (message.text.isNotEmpty) {
      message.clear();
      await firestore
          .collection('chatroom')
          .doc(roomId)
          .collection('chats')
          .add(messages);
    }
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as List;
    roomId = arg[0];
    user = arg[1];
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 20,
            ),
            SizedBox(
              height: size.height / 20,
              width: size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  CircleAvatar(
                    backgroundColor: green1,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user["name"],
                        style: regular14,
                      ),
                      StreamBuilder(
                        stream: firestore
                            .collection("users")
                            .doc(user["uid"])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return Text(
                              snapshot.data!["status"],
                              style: regular12_5.copyWith(color: green2),
                            );
                          } else {
                            return Text(
                              "Unvailable",
                              style: regular12_5,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('chatroom')
                    .doc(roomId)
                    .collection('chats')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return messageWidget(
                            size,
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, left: 8, right: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: message,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: green1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.0,
                            color: green2,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusColor: green1,
                        suffixIcon: IconButton(
                          onPressed: () => getImage(),
                          icon: Icon(
                            Icons.photo_outlined,
                            color: dark2,
                          ),
                        ),
                        hintText: "Type your message here",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onSubmitted: (_) => onSendMessage(),
                    ),
                  ),
                  IconButton(
                    onPressed: onSendMessage,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget messageWidget(Size size, Map<String, dynamic> map) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  return Container(
    width: size.width,
    alignment: map["sendby"] == auth.currentUser?.displayName
        ? Alignment.centerRight
        : Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: map["sendby"] == auth.currentUser?.displayName ? green1 : green2,
      ),
      child: Text(
        map["message"],
        style: regular12_5.copyWith(
          color: Colors.white,
        ),
      ),
    ),
  );
}
