import 'package:chat_app/theme.dart';
import 'package:chat_app/widget/button.dart';
import 'package:chat_app/widget/field.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});
  static const routeName = '/register';

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              color: green1,
              child: SizedBox(width: size.width),
            ),
            Container(
              height: size.height - 150,
              margin: const EdgeInsets.only(top: 150),
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height / 50,
                    ),
                    SizedBox(
                      width: size.width / 1.3,
                      child: Text(
                        "Welcome to Co-chat",
                        style: bold18.copyWith(fontSize: 25, color: dark1),
                      ),
                    ),
                    SizedBox(
                      width: size.width / 1.3,
                      child: Text(
                        "Sign up to continue",
                        style: semibold14.copyWith(fontSize: 18, color: dark3),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 25,
                    ),
                    SizedBox(
                      width: size.width,
                      child: field(
                        size,
                        "Name",
                        "Fill your name here",
                        true,
                        false,
                      ),
                    ),
                    SizedBox(
                      height: size.height / 40,
                    ),
                    SizedBox(
                      width: size.width,
                      child: field(
                        size,
                        "Email",
                        "Fill your email here",
                        true,
                        false,
                      ),
                    ),
                    SizedBox(
                      height: size.height / 40,
                    ),
                    SizedBox(
                      width: size.width,
                      child: field(
                        size,
                        "Password",
                        "Fill your Password here",
                        false,
                        true,
                      ),
                    ),
                    SizedBox(
                      height: size.height / 30,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: customButton(size, "Sign up"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have account ?",
                          style: regular14,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Sign in",
                            style: semibold14.copyWith(color: green1),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
