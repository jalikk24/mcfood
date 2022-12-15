import 'package:flutter/material.dart';
import 'package:mcfood/customStyle/CustomDecoration.dart';
import 'package:mcfood/ui/HomeMain.dart';
import 'package:mcfood/ui/Register.dart';
import 'package:mcfood/util/CustomColor.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Mc'Food",
                style: TextStyle(
                    fontFamily: "inter600",
                    fontSize: 20,
                    color: CustomColor.primary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                  decoration: CustomDecoration().getFormBorderWithIcon(
                      Icons.person, "Username", 10, CustomColor.primary),
                  style: TextStyle(
                      fontFamily: "inter600",
                      fontSize: 15,
                      color: CustomColor.greyBd)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                decoration: CustomDecoration().getFormBorderWithIcon(
                    Icons.lock_person_sharp,
                    "Password",
                    10,
                    CustomColor.primary),
                style: TextStyle(
                    fontFamily: "inter600",
                    fontSize: 15,
                    color: CustomColor.greyBd),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeMain()), (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(45),
                      backgroundColor: CustomColor.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontFamily: "inter600",
                        fontSize: 15,
                        color: CustomColor.white),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Register()));
                },
                child: Text(
                  "Register",
                  style: TextStyle(
                      fontFamily: "inter600",
                      fontSize: 15,
                      color: CustomColor.primary),
                ),
                style:
                    TextButton.styleFrom(foregroundColor: CustomColor.primary),
              ),
            )
          ],
        ),
      ),
    );
  }
}
