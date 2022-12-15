import 'package:flutter/material.dart';

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
        child: Text("Profile"),
      ),
    );
  }
}
