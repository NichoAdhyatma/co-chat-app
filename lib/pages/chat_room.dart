import 'dart:io';

import 'package:chat_app/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatRoom extends StatefulWidget {
  static const routeName = '/chat';

  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController message = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FocusNode focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  Map<String, dynamic> user = {};

  String roomId = "";

  File? imageFile;

  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print("on status : $status"),
        onError: (errorNotification) {
          print("on error : $errorNotification");
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
        });

        await _speech.listen(
          onResult: (result) {
            setState(() {
              message.text = result.recognizedWords;
              _isListening = false;
            });
          },
        );
      }
    } else {
      setState(() {
        print("stop");
        _isListening = false;
      });
      _speech.stop();
    }
  }

  // Future getImage() async {
  void onSendMessage() async {
    Map<String, dynamic> messages = {
      "sendby": auth.currentUser?.displayName,
      "message": message.text,
      "time": DateTime.now().toString(),
    };

    focusNode.unfocus();

    if (message.text.isNotEmpty) {
      message.clear();
      await firestore
          .collection('chatroom')
          .doc(roomId)
          .collection('chats')
          .add(messages);
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 1), curve: Curves.easeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as List;
    roomId = arg[0];
    user = arg[1];
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Colors.black),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: CircleAvatar(
                  child:
                      Image.asset("images/Multiavatar-4e696ba9b0ce5043bc.png"),
                ),
              ),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user["name"],
              style: regular14,
            ),
            StreamBuilder(
              stream:
                  firestore.collection("users").doc(user["uid"]).snapshots(),
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
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
                      controller: _scrollController,
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
              padding: const EdgeInsets.only(
                  bottom: 10.0, left: 8, right: 8, top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: focusNode,
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
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: green1),
                            ),
                          ),
                          onPressed: () => _listen(),
                          icon: Icon(
                            _isListening ? Icons.mic_off : Icons.mic,
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

  String date = DateFormat.Hm().format(DateTime.parse(map['time']));

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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              map["message"],
              style: regular14.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            date,
            style: regular12_5.copyWith(color: Colors.grey[400], fontSize: 10),
          ),
        ],
      ),
    ),
  );
}
