import 'package:chat_app/pages/chat_room.dart';
import 'package:chat_app/pages/login_screen.dart';
import 'package:chat_app/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  final TextEditingController user = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic> result = {};
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String input = "";
  bool isInit = true;

  @override
  void didChangeDependencies() async {
    if (isInit) {
      await firestore
          .collection("users")
          .orderBy('email')
          .where(
            'email',
            isNotEqualTo: auth.currentUser?.email,
          )
          .get()
          .then((value) {
        setState(() {
          if (value.docs.isNotEmpty) {
            result.clear();
            for (var e in value.docs) {
              result[e.id] = e.data();
            }
          } else {
            result.clear();
          }
        });
      });
    }
    if (isLoading) {
      setState(() {
        isLoading = false;
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  String chatRoomId(String? user1, String user2) {
    if (user1![0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    await firestore
        .collection("users")
        .where(
          'email',
          isNotEqualTo: auth.currentUser?.email,
        )
        .orderBy('email')
        .orderBy('name')
        .startAt([user.text])
        .endAt(['${user.text}\uf8ff'])
        .get()
        .then(
          (value) {
            setState(() {
              result.clear();
              if (value.docs.isNotEmpty) {
                for (var e in value.docs) {
                  result[e.id] = e.data();
                }
              } else {
                result.clear();
              }
            });
          },
        )
        .whenComplete(() {
          setState(() {
            isLoading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height / 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: bold18.copyWith(color: dark1),
                      ),
                      Text(
                        "${auth.currentUser!.email}",
                        style: semibold14.copyWith(color: green1),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    },
                    icon: const Icon(Icons.logout),
                  ),
                ],
              ),
              SizedBox(
                height: size.height / 20,
              ),
              SizedBox(
                width: size.width,
                child: TextField(
                  autocorrect: false,
                  enableSuggestions: false,
                  controller: user,
                  onChanged: (value) => setState(() {
                    result.clear();
                    isLoading = true;
                    input = value;
                    onSearch();
                  }),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: dark2,
                    ),
                    suffixIcon: user.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              user.clear();
                              setState(() {
                                input = "";
                                isInit = true;
                                result.clear();
                                didChangeDependencies();
                              });
                            },
                            icon: Icon(
                              Icons.close,
                              color: dark2,
                            ),
                          )
                        : null,
                    iconColor: green1,
                    labelText: "Search user",
                    labelStyle: regular14.copyWith(
                      color: green1,
                    ),
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
                    hintText: "Serch someone here",
                    hintStyle: regular14.copyWith(color: dark3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 40,
              ),
              RichText(
                text: TextSpan(
                  text: "Result for ",
                  style: semibold14.copyWith(color: dark1),
                  children: [
                    TextSpan(
                        text: input, style: semibold14.copyWith(color: green1)),
                  ],
                ),
              ),
              SizedBox(
                height: size.height / 30,
              ),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(
                    color: green1,
                  ),
                ),
              ...result.values.map(
                (e) => ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      ChatRoom.routeName,
                      arguments: [
                        chatRoomId(
                          auth.currentUser?.displayName,
                          e["name"],
                        ),
                        e,
                      ],
                    );
                  },
                  leading: const CircleAvatar(),
                  title: Text(
                    e["name"],
                    style: regular14,
                  ),
                  subtitle: Text(
                    "Start new chat",
                    style: regular12_5,
                  ),
                  trailing: Container(
                    alignment: Alignment.center,
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: green2,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
