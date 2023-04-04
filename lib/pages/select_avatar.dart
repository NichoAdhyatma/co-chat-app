import 'package:chat_app/constant/avatar.dart';
import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/pages/home_screen.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SelectAvatar extends StatefulWidget {
  const SelectAvatar({super.key});
  static const routeName = "/avatar";

  @override
  State<SelectAvatar> createState() => _SelectAvatarState();
}

class _SelectAvatarState extends State<SelectAvatar> {
  int isSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Select your avatar",
            style: bold16,
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  isSelected = 0;
                }),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: isSelected == 0 ? 40 : 30,
                  backgroundImage: NetworkImage(avatar[0]),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: isSelected == 0 ? 4 : 0, color: green2),
                        borderRadius: BorderRadius.circular(100)),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () => setState(() {
                  isSelected = 1;
                }),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: isSelected == 1 ? 40 : 30,
                  backgroundImage: NetworkImage(avatar[1]),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: isSelected == 1 ? 4 : 0, color: green2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () => setState(() {
                  isSelected = 2;
                }),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: isSelected == 2 ? 40 : 30,
                  backgroundImage: NetworkImage(avatar[2]),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: isSelected == 2 ? 4 : 0, color: green2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () => setState(() {
                  isSelected = 3;
                }),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: isSelected == 3 ? 40 : 30,
                  backgroundImage: NetworkImage(
                    avatar[3],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: isSelected == 3 ? 4 : 0, color: green2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                backgroundColor: green1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
            onPressed: () async {
              await updateProfile(avatar[isSelected])
                  .then(
                (_) => Navigator.of(context)
                    .pushReplacementNamed(HomeScreen.routeName),
              )
                  .catchError(
                (err) {
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
            },
            child: Text("Continue"),
          ),
        ],
      ),
    );
  }
}
