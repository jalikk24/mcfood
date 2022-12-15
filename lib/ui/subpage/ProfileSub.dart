import 'package:flutter/material.dart';
import 'package:mcfood/ui/Login.dart';
import 'package:request_api_helper/session.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart'
as bottomNav;

class ProfileSub extends StatefulWidget {
  const ProfileSub({Key? key}) : super(key: key);

  @override
  State<ProfileSub> createState() => _ProfileSubState();
}

class _ProfileSubState extends State<ProfileSub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              await Session.clear();
              bottomNav.pushNewScreen(context,
                  withNavBar: false,
                  screen: Login());
            },
            child: Text("Logout")),
      ),
    );
  }
}
