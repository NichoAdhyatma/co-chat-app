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
  bool isLoading = false;
  final TextEditingController user = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic> result = {};
  String input = "";

  void onSearch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore
        .collection("users")
        .where("name", isEqualTo: user.text)
        .get()
        .then((value) {
      setState(() {
        if (value.docs.isNotEmpty) {
          result = value.docs[0].data();
        } else {
          result.clear();
        }
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
                    input = value;
                    onSearch();
                  }),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () => user.clear(),
                      icon: const Icon(Icons.close),
                    ),
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
                height: size.height / 20,
              ),
              result.isNotEmpty
                  ? ListTile(
                      leading: const CircleAvatar(),
                      title: Text(
                        result["name"],
                        style: regular14,
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
                    )
                  : Text(
                      "No result",
                      style: regular14.copyWith(color: dark3),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
