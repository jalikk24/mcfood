import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mcfood/controller/ControllerAuth.dart';
import 'package:mcfood/customStyle/CustomDecoration.dart';
import 'package:mcfood/model/ModelLogin.dart';
import 'package:mcfood/ui/HomeMain.dart';
import 'package:mcfood/ui/Register.dart';
import 'package:mcfood/util/CustomColor.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with ChangeNotifier {

  ValueNotifier<bool> valHidePass = ValueNotifier(true);

  TextEditingController tecUsername = TextEditingController();
  TextEditingController tecPassword = TextEditingController();

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
                  controller: tecUsername,
                  decoration: CustomDecoration().getFormBorderWithIcon(
                      Icons.person, "Username", 10, CustomColor.primary),
                  style: TextStyle(
                      fontFamily: "inter600",
                      fontSize: 15,
                      color: CustomColor.black)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ValueListenableBuilder(
                valueListenable: valHidePass,
                builder: (_, hide, __) {
                  return TextFormField(
                    obscureText: hide,
                    controller: tecPassword,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () {
                          if (valHidePass.value) {
                            valHidePass.value = false;
                          } else {
                            valHidePass.value = true;
                          }
                          valHidePass.notifyListeners();
                        },
                        child: Icon(hide ? Icons.visibility_off : Icons.visibility),
                      ),
                      prefixIcon: Icon(Icons.lock_person_sharp, color: CustomColor.primary, size: 20,),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      hintText: "Password",
                      hintStyle: TextStyle(
                          fontFamily: "inter600",
                          fontSize: 15,
                          color: CustomColor.greyBd),
                      fillColor: CustomColor.greyFb,
                      filled: true,
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 2, color: CustomColor.greyE8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 2, color: CustomColor.greyE8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 2, color: CustomColor.greyE8),
                      ),
                    ),
                    style: TextStyle(
                        fontFamily: "inter600",
                        fontSize: 15,
                        color: CustomColor.black),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                  onPressed: () {
                    ModelLogin login = ModelLogin(username: tecUsername.text, password: tecPassword.text);
                    postLogin(login);
                    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeMain()), (route) => false);
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

  void postLogin(ModelLogin modelLogin) async{
    await ControllerAuth().login(modelLogin, () {
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => HomeMain()),
      //     (route) => false);
      Fluttertoast.showToast(msg: "Login success");
    }, () {
      Fluttertoast.showToast(msg: "Login failed");
    });
  }
}
