
import 'package:couponsgate/my_icons_icons.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context)
  {
    return Center(
      child: Image(image: new AssetImage("assets/images/logo.gif")),
    );

  }
}