import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/Language.dart';
import 'package:couponsgate/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _nameController = new TextEditingController();
  int loginBtnChildIndex = 0;
  int form = 0;

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

  loginButtonChild() {
    if (loginBtnChildIndex == 0) {
      return Text(
        getTranslated(context, 'login_sign_in_btn'),
        style: TextStyle(fontSize: 20, color: Colors.green),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  registerButtonChild() {
    if (loginBtnChildIndex == 0) {
      return Text(
        getTranslated(context, 'login_sign_up_btn'),
        style: TextStyle(fontSize: 20, color: Colors.green),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  Widget _loginButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 7),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Color(0xFF2f3640),
        ),
        child: loginButtonChild(),
      ),
    );
  }

  Widget _registerButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 7),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Color(0xFF2f3640),
        ),
        child: registerButtonChild(),
      ),
    );
  }

  Widget _signInButton() {
    return InkWell(
      onTap: () {
        setState(() {
          form = 2;
        });
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 7),
        margin: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Color(0xFF2f3640),
        ),
        child: Text(
          getTranslated(context, 'login_sign_in_btn'),
          style: TextStyle(fontSize: 20, color: Colors.green),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        setState(() {
          form = 1;
        });
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 7),
        margin: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Color(0xFF2f3640),
        ),
        child: Text(
          getTranslated(context, 'login_new_account_btn'),
          style: TextStyle(fontSize: 20, color: Colors.green),
        ),
      ),
    );
  }

  Widget _googleButton() {
    return InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Color(0xdddc3400),
          ),
          height: 50,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Icon(
                    FontAwesomeIcons.google,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(getTranslated(context, 'login_google_btn'),
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "CustomIcons",
                          fontSize: 18,
                          fontWeight: FontWeight.w400)),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _facebookButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.white,
        ),
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Icon(
                  FontAwesomeIcons.facebook,
                  color: Color(0xff1959a9),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                alignment: Alignment.center,
                child: Text(getTranslated(context, 'login_facebook_btn'),
                    style: TextStyle(
                        color: Color(0xff1959a9),
                        fontSize: 18,
                        fontFamily: "CustomIcons",
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        setState(() {
          form = 0;
        });
      },
      child: Container(
        //padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 0, top: 0, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Color(0xFF2f3640)),
            ),
            Text(getTranslated(context, 'login_back_btn'),
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2f3640),
                    fontFamily: "CustomIcons"))
          ],
        ),
      ),
    );
  }

  Widget _mainForm() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      child: Column(
        children: <Widget>[
          _facebookButton(),
          _googleButton(),
          _signInButton(),
          _signUpButton(),
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      child: Column(
        children: <Widget>[
          _backButton(),
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
          _loginButton(),
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      child: Column(
        children: <Widget>[
          _backButton(),
          _inputField(
              controller: _nameController,
              hint: getTranslated(context, 'login_name_hint'),
              icon: Icons.edit),
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
          _registerButton(),
        ],
      ),
    );
  }

  Widget _formRouter() {
    switch (form) {
      case 0:
        return _mainForm();
        break;
      case 1:
        return _registerForm();
        break;
      case 2:
        return _loginForm();
        break;
    }

    return _mainForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
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
                child: _formRouter(),
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
      ),
    ));
  }
}
