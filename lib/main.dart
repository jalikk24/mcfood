import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mcfood/MyLocation.dart';
import 'package:mcfood/ui/HomeMain.dart';
import 'package:mcfood/ui/Login.dart';
import 'package:mcfood/ui/TestGeocoding.dart';
import 'package:mcfood/ui/subpage/ListFoodSub.dart';
import 'package:mcfood/ui/subpage/ListTransSub.dart';
import 'package:mcfood/util/CustomColor.dart';
import 'package:request_api_helper/loading.dart';
import 'package:request_api_helper/request.dart';
import 'package:request_api_helper/request_api_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RequestApiHelper.init(RequestApiHelperData(
      baseUrl: "http://192.168.1.4/ppb/",
      onAuthError: (context) =>
          Fluttertoast.showToast(msg: "Error Unauthorize"),
      debug: true));

  Loading.widget = (context) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (builder) {
          Loading.currentContext = builder;
          Loading.lastContext = builder;
          return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                strokeWidth: 3,
              ));
        });
    Loading.loading = false;
    Loading.currentContext = context;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RequestApiHelperApp(
      builder: ((context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child ?? SizedBox());
      }),
      title: 'McFood',
      debugShowCheckedModeBanner: false,
      home: const Login(),
    );
  }
}
