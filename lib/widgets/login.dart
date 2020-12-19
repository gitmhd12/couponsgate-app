import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/Language.dart';
import 'package:couponsgate/routes/routes_names.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  int loginBtnChildIndex = 0;

  void _changeLanguage(Language lang) async {
    Locale _locale = await setLocale(lang.code);

    MyApp.setLocale(context, _locale);
  }

  Widget _inputField({controller, hint, icon}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(40),
              ),
            ),
            child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: controller,
                style: TextStyle(color: Color(0xff34495e), fontSize: 16),
                decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: Color(0xff34495e),
                    ),
                    prefixIcon: Icon(
                      icon,
                      color: Color(0xff34495e),
                    ),
                    fillColor: Colors.white,
                    filled: true)),
          )
        ],
      ),
    );
  }

  loginButtonChild({label}) {
    if (loginBtnChildIndex == 0) {
      return Text(
        label,
        style: TextStyle(
            fontSize: 20, color: Colors.green, fontFamily: "CustomIcons"),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  Widget _loginButton({label}) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 7),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Color(0xFF2f3640),
        ),
        child: loginButtonChild(label: label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Color(0xffdcdde1),
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              color: Color(0xFF222222),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(70),
                bottomLeft: Radius.circular(70),
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.12,
                  ),
                  Image.asset("assets/images/demo_logo.PNG"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: DropdownButton(
                          dropdownColor: Colors.white,
                          icon: Icon(
                            Icons.language,
                            color: Colors.white,
                          ),
                          underline: SizedBox(),
                          items: Language.languageList()
                              .map<DropdownMenuItem<Language>>(
                                  (lang) => DropdownMenuItem(
                                        value: lang,
                                        child: Text(
                                          lang.name,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Color(0xff34495e),
                                          ),
                                        ),
                                      ))
                              .toList(),
                          onChanged: (Language lang) {
                            _changeLanguage(lang);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: 60, left: 30, right: 30),
                child: Column(
                  children: <Widget>[
                    _inputField(
                        controller: _emailController,
                        hint: getTranslated(context, 'login_email_hint'),
                        icon: Icons.email),
                    _inputField(
                        controller: _passwordController,
                        hint: getTranslated(context, 'login_password_hint'),
                        icon: Icons.vpn_key),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    _loginButton(
                        label: getTranslated(context, 'login_sign_in_btn')),
                    MaterialButton(
                      child: Text(getTranslated(context, 'login_sign_up_btn')),
                      onPressed: () {
                        Navigator.pushNamed(context, homeRoute);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
              color: Color(0xFF222222),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(70),
                topLeft: Radius.circular(70),
              ),
            ),
            child: Center(
              child: MaterialButton(
                textColor: Color(0xffdcdde1),
                child: Text(getTranslated(context, 'login_sign_later_btn')),
                onPressed: () {
                  Navigator.pushNamed(context, homeRoute);
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
