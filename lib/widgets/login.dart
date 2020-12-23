import 'dart:convert';

import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/ApiAssistant.dart';
import 'package:couponsgate/modules/Country.dart';
import 'package:couponsgate/modules/Language.dart';
import 'package:couponsgate/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>{
  
  ApiAssistant api = new ApiAssistant();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _pinController = new TextEditingController();
  final TextEditingController _newPassController = new TextEditingController();
  int loginBtnChildIndex = 0;
  int registerBtnChildIndex = 0;
  int emailValBtnChildIndex = 0;
  int resetPassBtnChildIndex = 0;
  int pinValBtnChildIndex = 0;
  int resetBtnChildIndex = 0;
  int form = 0;

  bool _isLoading;
  List<Country> _countries , _rCountries = [];
  String _countryBtnHint , _countryID;


  @override
  void initState() {
    super.initState();

    setState(() {
      _countryBtnHint = '+';
      _isLoading = true;
    });

    _getCountries().then((value) {
      setState(() {
        _rCountries = List.from(value);
        _isLoading = false;
      });
    });
  }

  Future _getCountries() async
  {
    var csResponse = await http
        .get('https://couponsgate.net/app-dash/rest_api/countries/getAllCountries.php');
    var csData = json.decode(csResponse.body);
    Country tCountry;
    _countries = [];

    for (var ques in csData['countries']) {
      tCountry = Country.fromJson(ques);
      print(tCountry.id);

      _countries.add(tCountry);
      //print('depart length is : ' + departs.length.toString());
    }

    return _countries;
  }

  void changeCountry(context , Country country) {
    setState(() {
      _countryBtnHint = countryName(context , country);
      _countryID = country.id;
    });
  }

  String countryName(context , Country country)
  {
    Locale currentLocale = Localizations.localeOf(context);

    if(currentLocale.languageCode == 'ar')
      {
        return country.arName;
      }
    else
      {
        return country.enName;
      }

  }

  void _showCountriesDialog(context, List<Country> countries) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child: StatefulBuilder(builder: (context, setState) {
              return _isLoading ? Container(child: Center(child: CircularProgressIndicator(),),) : Container(
                height: countries.length <= 4
                    ? MediaQuery.of(context).size.height * 0.1 * countries.length
                    : MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          getTranslated(context, 'login_country_btn'),
                          style: TextStyle(
                            fontFamily: 'CustomIcons',
                            fontSize: 20.0,
                            color: Color(0xff275879),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        thickness: 1.0,
                        color: Colors.black54,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: countries.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                countryName(context, countries[index]),
                              ),
                              onTap: () {
                                changeCountry(context, countries[index]);
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }


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

  buttonChild(int bcIndex  , String label) {
    if (bcIndex == 0) {
      return Text(
        label,
        style: TextStyle(fontSize: 20, color:Color(0xff34495e),),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xff34495e),),
      );
    }
  }

  Widget _loginButton() {
    return InkWell(
      onTap: () {
        _processLogin();
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 7),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Color(0xFF7ed6df),
        ),
        child: buttonChild( loginBtnChildIndex , getTranslated(context, 'login_sign_in_btn'),),
      ),
    );
  }

  Widget _registerButton() {
    return InkWell(
      onTap: () {
        _processRegister();
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 7),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Color(0xFF55efc4),
        ),
        child: buttonChild( registerBtnChildIndex , getTranslated(context, 'login_sign_up_btn'),),
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
          color: Color(0xFF7ed6df),
        ),
        child: Text(
          getTranslated(context, 'login_sign_in_btn'),
          style: TextStyle(fontSize: 20, color: Color(0xFF2f3640)),
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
          color: Color(0xFF55efc4),
        ),
        child: Text(
          getTranslated(context, 'login_new_account_btn'),
          style: TextStyle(fontSize: 20, color: Color(0xFF2f3640)),
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
            color: Colors.white,
            border: Border.all(color: Color(0xdddc3400),),
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
                    color: Color(0xdddc3400),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(getTranslated(context, 'login_google_btn'),
                      style: TextStyle(
                          color: Color(0xdddc3400),
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
          border: Border.all(color: Color(0xff1959a9),),
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

  Widget _backButton({formValue}) {
    return InkWell(
      onTap: () {
        setState(() {
          form = formValue;
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

  alertDialog(String text, String title) {
    showDialog(
        context: context,
        builder: (_) => AssetGiffyDialog(
          onlyOkButton: true,
          buttonCancelText: Text(getTranslated(context, 'login_alert_d_cancel'),
              style: TextStyle(fontFamily: "CustomIcons", fontSize: 16)),
          buttonOkText: Text(getTranslated(context, 'login_alert_d_ok'),
              style: TextStyle(
                  fontFamily: "CustomIcons",
                  fontSize: 16,
                  color: Colors.white)),
          buttonOkColor: Colors.redAccent,
          image: Image.asset('assets/images/alert.png', fit: BoxFit.cover),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 18.0,
                fontFamily: "CustomIcons",
                color: Colors.redAccent),
          ),
          description: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "CustomIcons", fontSize: 16),
          ),
          onOkButtonPressed: () {
            Navigator.pop(context);
          },
        ));
  }

  successDialog(String text, String title) {
    showDialog(
        context: context,
        builder: (_) => AssetGiffyDialog(
          onlyOkButton: true,
          buttonCancelText: Text(getTranslated(context, 'login_alert_d_cancel'),
              style: TextStyle(fontFamily: "CustomIcons", fontSize: 16)),
          buttonOkText: Text(getTranslated(context, 'login_alert_d_ok'),
              style: TextStyle(
                  fontFamily: "CustomIcons",
                  fontSize: 16,
                  color: Colors.white)),
          buttonOkColor: Colors.green,
          image: Image.asset('assets/images/success.png', fit: BoxFit.cover),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 18.0,
                fontFamily: "CustomIcons",
                color: Colors.green),
          ),
          description: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "CustomIcons", fontSize: 16),
          ),
          onOkButtonPressed: () {
            Navigator.pop(context);
          },
        ));
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
          _backButton(formValue: 0),
          _inputField(
              controller: _emailController,
              hint: getTranslated(context, 'login_email_hint'),
              icon: Icons.email),
          _inputField(
              controller: _passwordController,
              hint: getTranslated(context, 'login_password_hint'),
              icon: Icons.vpn_key),
          MaterialButton(
            textColor: Colors.black54,
            child: Text(getTranslated(context, 'login_reset_pass_main')),
            onPressed: () {
              setState(() {
                form = 3;
              });
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          _loginButton(),
        ],
      ),
    );
  }

  _processLogin() {
    if (loginBtnChildIndex == 0) {
      setState(() {
        loginBtnChildIndex = 1;
      });
      if (_emailController.text.trim().isEmpty) {
        alertDialog(getTranslated(context, 'login_alert_md_email'), getTranslated(context, 'login_alert_md_title'),);
        setState(() {
          loginBtnChildIndex = 0;
        });
      } else if (_passwordController.text.isEmpty) {
        alertDialog(getTranslated(context, 'login_alert_md_password'), getTranslated(context, 'login_alert_md_title'),);
        setState(() {
          loginBtnChildIndex = 0;
        });
      } else {
        print('logging ...');
        api
            .loginData(_passwordController.text.toString(), _emailController.text.trim().toLowerCase().toString())
            .whenComplete(() {
          if (api.loginStatus == false) {
            alertDialog(getTranslated(context, 'login_alert_Ind_content'), getTranslated(context, 'login_alert_Ind_title'),);
            setState(() {
              loginBtnChildIndex = 0;
            });
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        });
      }
    }
  }

  Widget _registerForm() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      child: Column(
        children: <Widget>[
          _backButton(formValue: 0),
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
          Row(
            children: <Widget>[
            Expanded(child: Text(getTranslated(context, 'login_country_btn'),)),
            Expanded(child: InkWell(
              onTap: () {
                _showCountriesDialog(context, _rCountries);

                setState(() {
                });
              },
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width*0.3,
                padding: EdgeInsets.symmetric(vertical: 3),
                margin: EdgeInsets.symmetric(vertical: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: Color(0xFF55efc4),
                ),
                child: Text(
                  _countryBtnHint,
                  style: TextStyle(fontSize: 14, color: Color(0xFF2f3640)),
                ),
              ),
            ),),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          _registerButton(),
        ],
      ),
    );
  }



  _processRegister() {
    if (registerBtnChildIndex == 0) {
      setState(() {
        registerBtnChildIndex = 1;
      });
      if (_emailController.text.trim().isEmpty) {
        alertDialog(getTranslated(context, 'login_alert_md_email'), getTranslated(context, 'login_alert_md_title'),);
        setState(() {
          registerBtnChildIndex = 0;
        });
      } else if (_passwordController.text.isEmpty) {
        alertDialog(getTranslated(context, 'login_alert_md_password'), getTranslated(context, 'login_alert_md_title'),);
        setState(() {
          registerBtnChildIndex = 0;
        });
      } else if (_nameController.text.isEmpty) {
        alertDialog(getTranslated(context, 'login_alert_md_name'), getTranslated(context, 'login_alert_md_title'),);
        setState(() {
          registerBtnChildIndex = 0;
        });
      } else {
        print('ok');
        api
            .registerData(_passwordController.text.toString(), _nameController.text.trim(), _emailController.text.trim().toLowerCase().toString(), _countryID)
            .whenComplete(() {
          if (api.registerStatus == false && api.isEmailUsed == false) {
            alertDialog(getTranslated(context, 'login_alert_Ind_content'), getTranslated(context, 'login_alert_Ind_title'),);
            setState(() {
              registerBtnChildIndex = 0;
            });
          } else if(api.registerStatus == false && api.isEmailUsed == true){
            alertDialog(getTranslated(context, 'login_alert_Ind_email_used'), getTranslated(context, 'login_alert_Ind_title'),);
            setState(() {
              registerBtnChildIndex = 0;
            });
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        });
      }
    }
  }

  Widget _emailValidationForm()
  {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      child: Column(
        children: <Widget>[
          _backButton(formValue: 2),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    getTranslated(context, 'login_reset_pass_email_label'),
                    style: TextStyle(fontSize: 14, color: Color(0xFF2f3640)),
                  ),
                ),
              ],
            ),
          ),
          _inputField(
              controller: _emailController,
              hint: getTranslated(context, 'login_email_hint'),
              icon: Icons.email),

          InkWell(
            onTap: () {
              _emailValidProcess();
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width*0.4,
              padding: EdgeInsets.symmetric(vertical: 3),
              margin: EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Color(0xFF7ed6df),
              ),
              child:
                buttonChild( emailValBtnChildIndex , getTranslated(context, 'login_reset_pass_next_btn'),),
            ),
          ),
        ],
      ),
    );
  }

  _emailValidProcess() {
    if (emailValBtnChildIndex == 0) {
      setState(() {
        emailValBtnChildIndex = 1;
      });
      if (_emailController.text.trim().isEmpty) {
        alertDialog(getTranslated(context, 'login_alert_md_email'), getTranslated(context, 'login_alert_md_title'),);
        setState(() {
          emailValBtnChildIndex = 0;
        });
      } else {
        api
            .validateEmail( _emailController.text.trim().toLowerCase().toString())
            .whenComplete(() {
          if (api.emailValidStatus == false) {
            alertDialog(getTranslated(context, 'login_alert_Ind_content'), getTranslated(context, 'login_alert_try_again'),);
            setState(() {
              emailValBtnChildIndex = 0;
            });
          } else {
            setState(() {
              emailValBtnChildIndex = 0;
              form = 4;
            });
          }
        });
      }
    }
  }

  Widget _pinValidationForm()
  {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      child: Column(
        children: <Widget>[
          _backButton(formValue: 3),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    getTranslated(context, 'login_reset_pass_pin_label'),
                    style: TextStyle(fontSize: 14, color: Color(0xFF2f3640)),
                  ),
                ),
              ],
            ),
          ),
          _inputField(
              controller: _pinController,
              hint: getTranslated(context, 'login_pin_hint'),
              icon: Icons.vpn_key),

          InkWell(
            onTap: () {
              _pinValidProcess();
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width*0.4,
              padding: EdgeInsets.symmetric(vertical: 3),
              margin: EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Color(0xFF7ed6df),
              ),
              child:
                buttonChild( pinValBtnChildIndex , getTranslated(context, 'login_reset_pass_next_btn'),),
            ),
          ),
        ],
      ),
    );
  }

  _pinValidProcess() {
    if (pinValBtnChildIndex == 0) {
      setState(() {
        pinValBtnChildIndex = 1;
      });
      if (_pinController.text.trim().isEmpty) {
        alertDialog(getTranslated(context, 'login_alert_md_pin'), getTranslated(context, 'login_alert_md_title'),);
        setState(() {
          pinValBtnChildIndex = 0;
        });
      } else {
        if(_pinController.text.trim() != api.pinCode)
          {
            alertDialog(getTranslated(context, 'login_alert_Ind_pin'), getTranslated(context, 'login_alert_Ind_title'),);
            pinValBtnChildIndex = 0;
          }
        else
          {
            setState(() {
              pinValBtnChildIndex = 0;
              form = 5;
            });
          }
      }
    }
  }

  Widget _passwordResetForm()
  {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      child: Column(
        children: <Widget>[
          _backButton(formValue: 4),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    getTranslated(context, 'login_reset_pass_label'),
                    style: TextStyle(fontSize: 14, color: Color(0xFF2f3640)),
                  ),
                ),
              ],
            ),
          ),
          _inputField(
              controller: _newPassController,
              hint: getTranslated(context, 'login_password_hint'),
              icon: Icons.vpn_key),

          InkWell(
            onTap: () {
              _resetPassProcess();
            },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width*0.4,
              padding: EdgeInsets.symmetric(vertical: 3),
              margin: EdgeInsets.symmetric(vertical: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Color(0xFF7ed6df),
              ),
              child:
                buttonChild( resetBtnChildIndex , getTranslated(context, 'login_reset_pass_btn'),),
            ),
          ),
        ],
      ),
    );
  }

  _resetPassProcess() {
    if (resetBtnChildIndex == 0) {
      setState(() {
        resetBtnChildIndex = 1;
      });
      if (_newPassController.text.trim().isEmpty) {
        alertDialog(getTranslated(context, 'login_alert_md_password'), getTranslated(context, 'login_alert_md_title'),);
        setState(() {
          resetBtnChildIndex = 0;
        });
      } else {

        api.resetPassword(_emailController.text.trim().toLowerCase().toString(), _newPassController.text.trim())
            .whenComplete(() {
          if (api.resetPassStatus == false) {
            alertDialog(getTranslated(context, 'login_alert_try_again'), getTranslated(context, 'login_alert_Ind_title'),);
            setState(() {
              resetBtnChildIndex = 0;
            });
          } else {
            setState(() {
              successDialog(getTranslated(context, 'login_alert_success_content'), getTranslated(context, 'login_alert_success_title'),);
              resetBtnChildIndex = 0;
              form = 0;
            });
          }
        });

      }
    }
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
      case 3:
        return _emailValidationForm();
        break;
      case 4:
        return _pinValidationForm();
        break;
      case 5:
        return _passwordResetForm();
        break;
    }

    return _mainForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topRight,
        //     end: Alignment.bottomLeft,
        //     stops: [
        //       0.3,
        //       0.45,
        //     ],
        //     colors: [
        //       Colors.tealAccent,
        //       Colors.white,
        //     ],
        //   ),
        // ),
        height: MediaQuery.of(context).size.height,
        //color: Color(0xffdcdde1),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
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
                //color: Color(0xFF222222),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [
                    0.1,
                    0.5,
                    0.9,
                  ],
                  colors: [
                    Color(0xffe17055),
                    Colors.brown,
                    Colors.pinkAccent,
                  ],
                ),
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
