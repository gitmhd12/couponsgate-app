import 'dart:async';
import 'package:couponsgate/modules/ApiAssistant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> {

  ApiAssistant api = new ApiAssistant();

  checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final is_login_value = prefs.get(key) ?? 0;

    if (is_login_value == "1") {

      Locale currentLocale = Localizations.localeOf(context);
      api.updateFirebaseToken(currentLocale.languageCode).whenComplete((){
        if(api.firebaseStatus)
        {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
      );

    } else {

      //check if first time go to home
      final key = 'is_first_time';
      final is_first_time = prefs.get(key) ?? 0;

      //or go to login
      Navigator.pushReplacementNamed(context, '/login');
    }
    print("is_login value: $is_login_value");
  }

  void startTimer() {
    // Start the periodic timer which prints something after 5 seconds and then stop it .

    Timer timer=  new Timer.periodic(new Duration(seconds: 7), (time) {
      checkLogin();
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
