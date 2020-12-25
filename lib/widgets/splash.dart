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

  @override
  initState() {
    super.initState();
    // read();
    check_login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          //color: Color(0xFF222222),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [
              0.1,
              0.4,
              0.6,
              0.9,
            ],
            colors: [
              Colors.amber,
              Colors.red,

              Colors.pinkAccent,
              Colors.brown,
            ],
          ),

        ),
        child: Center(
          child: Image.asset("assets/images/logo.png"),
        ),
      ),
    );
  }
}
