import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> {
  check_login() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final is_login_value = prefs.get(key) ?? 0;

    if (is_login_value == "1") {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
    print("is_login value: $is_login_value");
  }

  void startTimer() {
    // Start the periodic timer which prints something after 5 seconds and then stop it .

    Timer timer=  new Timer.periodic(new Duration(seconds: 10), (time) {
      check_login();
      time.cancel();
    });
// Start the periodic timer which prints something after 5 minutes and then stop it .


}

  @override
  initState() {
    super.initState();
    // read();
    //check_login();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,

        ),
        child: Center(
          child: Image(image: new AssetImage("assets/images/logo.gif")
          ,width: MediaQuery.of(context).size.width
          ,height: MediaQuery.of(context).size.width),
        ),
      ),
    );
  }
}
