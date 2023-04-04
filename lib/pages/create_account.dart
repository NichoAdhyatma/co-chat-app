import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/pages/home_screen.dart';
import 'package:chat_app/pages/login_screen.dart';
import 'package:chat_app/pages/select_avatar.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/widget/field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});
  static const routeName = '/register';

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  bool isLoading = false;

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
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            width: size.width,
                            child: FieldText(
                              obscure: false,
                              autofocus: false,
                              controller: _name,
                              label: "Name",
                              hintText: "fill your text here",
                              focusNode: focusNode,
                            ),
                          ),
                          SizedBox(
                            height: size.height / 40,
                          ),
                          SizedBox(
                            width: size.width,
                            child: FieldText(
                              obscure: false,
                              autofocus: false,
                              controller: _email,
                              label: "Email",
                              hintText: "Fill your email here",
                              focusNode: focusNode1,
                            ),
                          ),
                          SizedBox(
                            height: size.height / 40,
                          ),
                          SizedBox(
                            width: size.width,
                            child: FieldText(
                              obscure: true,
                              autofocus: false,
                              controller: _password,
                              label: "Password",
                              hintText: "Fill your password here",
                              focusNode: focusNode2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height / 30,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          backgroundColor: green1,
                          fixedSize: Size.fromWidth(size.width),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });

                          focusNode.hasFocus
                              ? focusNode.unfocus()
                              : focusNode1.hasFocus
                                  ? focusNode1.unfocus()
                                  : focusNode2.hasFocus
                                      ? focusNode2.unfocus()
                                      : null;

                          createAccount(_name.text, _email.text, _password.text)
                              .then(
                            (user) {
                              if (user != null) {
                                Navigator.of(context).pushReplacementNamed(
                                    SelectAvatar.routeName);
                              }
                              setState(
                                () {
                                  isLoading = false;
                                },
                              );
                            },
                          ).catchError(
                            (err) {
                              setState(() {
                                isLoading = false;
                              });
                              Fluttertoast.showToast(
                                  msg: "${err.code}",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            },
                          );
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Sign in",
                              style: semibold14.copyWith(
                                  fontSize: 20, color: Colors.white),
                            ),
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
                            Navigator.of(context)
                                .pushReplacementNamed(LoginScreen.routeName);
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
