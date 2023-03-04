import 'dart:ffi';

import 'package:chat_app/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatRoom extends StatelessWidget {
  static const routeName = '/chat';
  final TextEditingController message = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic> user = {};

  ChatRoom({super.key});
  String roomId = "";

  void onSendMessage() async {
    Map<String, dynamic> messages = {
      "sendby": auth.currentUser?.displayName,
      "message": message.text,
      "time": FieldValue.serverTimestamp(),
    };

    if (message.text.isNotEmpty) {
      await firestore
          .collection('chatroom')
          .doc(roomId)
          .collection('chats')
          .add(messages);
    }

    message.clear();
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
                      Text(
                        "online",
                        style: regular12_5.copyWith(color: green2),
                      ),
                    ],
                  )
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
                            snapshot.data!.docs[0].data()
                                as Map<String, dynamic>);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, left: 8, right: 8),
        child: SizedBox(
          width: size.width,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: message,
                  decoration: InputDecoration(
                    hintText: "Type your message here",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: onSendMessage,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget messageWidget(size, Map<String, dynamic> map) {
  return Container();
}
