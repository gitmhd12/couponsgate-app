
import 'package:couponsgate/my_icons_icons.dart';
import 'package:flutter/material.dart';

import 'localization/localizationValues.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [
        Center(
          child: Image(image: new AssetImage("assets/images/logo.gif")),
        ),
        Center(
          child: MaterialButton(
            textColor: Color(0xff000000),
            child: Text(getTranslated(context, 'skip'),style: TextStyle(fontFamily: 'CustomFont',fontSize: 20,fontWeight: FontWeight.bold),),
            onPressed: () {
            //checkIfFirstSkip();
            },
            ),
        )
      ],
    );

  }
}