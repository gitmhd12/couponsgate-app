import 'dart:convert';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/ApiAssistant.dart';
import 'package:couponsgate/modules/Country.dart';
import 'package:couponsgate/modules/Language.dart';
import 'package:couponsgate/widgets/countries.dart';
import 'package:couponsgate/widgets/favorites.dart';
import 'package:couponsgate/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../my_icons_icons.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  ApiAssistant api = new ApiAssistant();

  bool _isGuest = false;
  bool _isLoading = true;
  TextEditingController _usernameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confPasswordController;

  String _userId = ' ';
  String _username = ' ';
  String _password = ' ';
  String _email = ' ';
  String _token = ' ';
  String _countryCode = ' ';
  String _language = ' ';
  List<Country> _countries , _rCountries = [];
  String _countryBtnHint = ' ';
  int _form = 0 , _saveBtnChildIndex =0;

  Future _getUserdata() async {
    final prefs = await SharedPreferences.getInstance();

    final key = 'is_login';
    final value = prefs.get(key);
    print('$value');

    if (value == '1')
    {
      setState(() {
        _isGuest = false;
      });

      final key0 = 'user_id';
      final key1 = 'name';
      final key2 = 'email';
      final key3 = 'pass';
      final key4 = 'token';
      final key5 = 'country_code';

      final value0 = prefs.get(key0);
      print(value0);
      final value1 = prefs.get(key1);
      print(value1);
      final value2 = prefs.get(key2);
      print(value2);
      final value3 = prefs.get(key3);
      print(value3);
      final value4 = prefs.get(key4);
      print(value4);
      final value5 = prefs.get(key5);
      print(value5);

      setState(() {
        _userId = value0;
        _username = value1;
        _email = value2;
        _password = value3;
        _token = value4;
        _countryCode = value5;

        _usernameController.text = _username;
        _emailController.text = _email;
      });

      Locale currentLocale = Localizations.localeOf(context);

      if(currentLocale.languageCode == 'ar')
      {
        setState(() {
          _language = 'العربية';
        });
      }
      else
      {
        setState(() {
          _language = 'English';
        });
      }

    }
    else
      {
        setState(() {
          _isGuest = true;
        });
      }
  }

  Future _getCountries() async
  {
    var csResponse = await http
        .get('https://yalaphone.com/appdash/rest_api/countries/getAllCountries.php');
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

  Future _getUserCountry() async
  {
    var csResponse = await http
        .post('https://yalaphone.com/appdash/rest_api/countries/get_user_country.php' ,
        body: {'country_id' : _countryCode});
    var csData = json.decode(csResponse.body);
    Country tCountry;
    tCountry = Country.fromJson(csData['country']);

    return tCountry;
  }

  void changeCountry(context , Country country) {
    setState(() {
      _countryBtnHint = countryName(context , country);
      _countryCode = country.id;
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
                            fontFamily: 'CustomFont',
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

  Future _submitUserData(String token , String name , String email , String pass , String cc) async
  {
    var csResponse = await http
        .post('https://yalaphone.com/appdash/rest_api/update_user.php',
    body: {'token' : token,
            'name' : name,
            'email' : email,
            'password' : pass,
            'country' : cc}
    );
    var csData = json.decode(csResponse.body);
    print(csData.toString());

    return csData.toString();
  }

  void _changeLanguage(Language lang) async {
    Locale _locale = await setLocale(lang.code);

    MyApp.setLocale(context, _locale);
  }

  Widget _inputField({controller, hint, icon , inputType}) {
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
                keyboardType: inputType,
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

  buttonChild(int bcIndex  , String label) {
    if (bcIndex == 0) {
      return Text(
        label,
        style: TextStyle(fontSize: 20, color:Color(0xff34495e),fontFamily: "CustomFont",),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xff34495e),),
      );
    }
  }

  Widget _saveButton() {
    return InkWell(
      onTap: () {
        _processSaveChanges();
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
        child: buttonChild( _saveBtnChildIndex , getTranslated(context, 'settings_save_btn'),),
      ),
    );
  }

  _processSaveChanges()
  {
    if (_saveBtnChildIndex == 0) {
      setState(() {
        _saveBtnChildIndex = 1;
      });
      if (_emailController.text.trim().isEmpty) {
        alertDialog(getTranslated(context, 'login_alert_md_email'), getTranslated(context, 'login_alert_md_title'),);
        setState(() {
          _saveBtnChildIndex = 0;
        });
      } else if (_usernameController.text.isEmpty) {
        alertDialog(getTranslated(context, 'login_alert_md_name'), getTranslated(context, 'login_alert_md_title'),);
        setState(() {
          _saveBtnChildIndex = 0;
        });
      } else if (_passwordController.text.isEmpty && _confPasswordController.text.isNotEmpty
                  || _passwordController.text.isNotEmpty && _confPasswordController.text.isEmpty) {
        alertDialog(getTranslated(context, 'settings_pass_reset_alert_hint'), getTranslated(context, 'login_alert_md_title'),);
        setState(() {
          _saveBtnChildIndex = 0;
        });
      } else if (_passwordController.text.isNotEmpty && _confPasswordController.text.isNotEmpty
          && _passwordController.text != _confPasswordController.text) {
        alertDialog(getTranslated(context, 'settings_pass_reset_alert_hint_2'), getTranslated(context, 'login_alert_Ind_title'),);
        setState(() {
          _saveBtnChildIndex = 0;
        });
      } else if (_passwordController.text.trim().isNotEmpty && _confPasswordController.text.trim().isNotEmpty
          && _passwordController.text.trim() == _confPasswordController.text.trim())
        {
          _submitUserData(_token,
              _usernameController.text,
              _emailController.text.trim().toLowerCase(),
              _passwordController.text.trim(),
              _countryCode).then((value) {
            if (value.toString().contains('server error')) {
              alertDialog(getTranslated(context, 'login_alert_Ind_content'), getTranslated(context, 'login_alert_Ind_title'),);
              setState(() {
                _saveBtnChildIndex = 0;
              });
            } else if(value.toString().contains('email used')){
              alertDialog(getTranslated(context, 'login_alert_Ind_email_used'), getTranslated(context, 'login_alert_Ind_title'),);
              setState(() {
                _saveBtnChildIndex = 0;
              });
            } else {
              setState(() {
                api.saveUserParams(_userId, _passwordController.text.trim(), _usernameController.text, _emailController.text.trim().toLowerCase(), _token, _countryCode);
                successDialog(getTranslated(context, 'settings_alert_success_content'), getTranslated(context, 'settings_alert_success_title'),);
                _saveBtnChildIndex = 0;
              });
            }
          });

        } else {
        print('ok');
        _submitUserData(_token,
            _usernameController.text,
            _emailController.text.trim().toLowerCase(),
            _password,
            _countryCode).then((value) {
          if (value.toString().contains('server error')) {
            alertDialog(getTranslated(context, 'login_alert_Ind_content'), getTranslated(context, 'login_alert_Ind_title'),);
            setState(() {
              _saveBtnChildIndex = 0;
            });
          } else if(value.toString().contains('email used')){
            alertDialog(getTranslated(context, 'login_alert_Ind_email_used'), getTranslated(context, 'login_alert_Ind_title'),);
            setState(() {
              _saveBtnChildIndex = 0;
            });
          } else {
            setState(() {
              api.saveUserParams(_userId, _password, _usernameController.text, _emailController.text.trim().toLowerCase(), _token, _countryCode);
              successDialog(getTranslated(context, 'settings_alert_success_content'), getTranslated(context, 'settings_alert_success_title'),);
              _saveBtnChildIndex = 0;
            });
          }
        });
      }
    }
  }

  Widget _formRouter() {
    switch (_form) {
      case 0:
        return _mainSettings();
        break;
      case 1:
        return _userAccountSettingsForm();
        break;
    }

    return _mainSettings();
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        setState(() {
          _form = 0;
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
                    fontFamily: "CustomFont"))
          ],
        ),
      ),
    );
  }

  Widget _mainSettings()
  {
    return Column(
      children: <Widget>[

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),

        ListTile(
          title: Text(
            getTranslated(context, 'settings_user_info_label'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "CustomFont",),
          ),
          // subtitle: Text(
          //   getTranslated(context, 'settings_lang_label'),
          //   style: TextStyle(fontSize: 18,color: Colors.black54, fontFamily: "CustomFont",),
          // ),
          trailing: IconButton(icon: Icon(Icons.chevron_right),
            color: Color(0xFF2196f3),
            onPressed: (){
              setState(() {
                _form = 1;
              });
            },
          ),
        ),

        ListTile(
          title: Text(
            getTranslated(context, 'settings_lang_label'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "CustomFont",),
          ),
          // subtitle: Text(
          //   getTranslated(context, 'settings_lang_label'),
          //   style: TextStyle(fontSize: 18,color: Colors.black54, fontFamily: "CustomFont",),
          // ),
          trailing: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: DropdownButton(
              icon: Icon(Icons.language , color: Color(0xFF2196f3),),
              underline: SizedBox(),
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                      (lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(lang.name),
                  ))
                  .toList(),
              onChanged: (Language lang) {
                _changeLanguage(lang);
              },
            ),
          ),
        ),

      ],
    );
  }

  Widget _userAccountSettingsForm() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      child: Column(
        children: <Widget>[
          _backButton(),
          Text(
            getTranslated(context, 'settings_username_label'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "CustomFont",),
          ),
          _inputField(
              controller: _usernameController,
              hint: getTranslated(context, 'login_name_hint'),
              icon: Icons.person_outline,
              inputType: TextInputType.text),
          Text(
            getTranslated(context, 'settings_email_label'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "CustomFont",),
          ),
          _inputField(
              controller: _emailController,
              hint: getTranslated(context, 'login_email_hint'),
              icon: Icons.email,
              inputType: TextInputType.emailAddress),
          Text(
            getTranslated(context, 'settings_password_label'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "CustomFont",),
          ),
          _inputField(
              controller: _passwordController,
              hint: getTranslated(context, 'settings_pass_reset_hint'),
              icon: Icons.vpn_key,
              inputType: TextInputType.visiblePassword),
          Text(
            getTranslated(context, 'settings_conf_password_label'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "CustomFont",),
          ),
          _inputField(
              controller: _confPasswordController,
              hint: getTranslated(context, 'settings_pass_reset_hint'),
              icon: Icons.vpn_key,
              inputType: TextInputType.visiblePassword),
          Row(
            children: <Widget>[
              Expanded(child: Text(getTranslated(context, 'settings_country_label'),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "CustomFont",))),
              Expanded(child: InkWell(
                onTap: () {
                  setState(() {
                    _isLoading = true;
                  });

                  _getCountries().then((value) {
                    setState(() {
                      _rCountries = List.from(value);
                      _isLoading = false;
                      _showCountriesDialog(context, _rCountries);
                    });
                  });

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
          _saveButton(),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confPasswordController = TextEditingController();

    //_checkIfGuest();
    _getUserdata().whenComplete(() {
      _getUserCountry().then((value){
        setState(() {
          _countryBtnHint = countryName(context, value);
        });
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text(getTranslated(context, 'settings_title'),
          style: TextStyle(fontFamily: 'CustomFont',color: Colors.black),),
      ),
      body: _isGuest ?
      InkWell(

        borderRadius: BorderRadius.circular(5),
        onTap: () {},
        child: Card(


          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.only(top:10.0),
          //color: Colors.grey,
          elevation: 0,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  getTranslated(context, 'settings_sign_in_note'),
                                  style: TextStyle(
                                    fontFamily: 'CustomFont',
                                  ),
                                ),
                              ),
                              FlatButton(
                                color: Colors.white,
                                textColor: Colors.black,
                                disabledColor: Colors.white,
                                disabledTextColor: Colors.white,
                                padding: EdgeInsets.all(8.0),
                                splashColor: Colors.tealAccent,
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/');
                                },
                                child: Text(
                                  getTranslated(context, 'settings_sign_in_btn'),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: "CustomFont",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          :SingleChildScrollView(
        child: _formRouter(),
      ),
        bottomNavigationBar: StyleProvider(
            style: Style(),
            child: ConvexAppBar(
              color: Colors.white,
              //backgroundColor: Colors.white,
              //activeColor: Colors.deepOrange,
              height: 50,
              //top: -30,
              //curveSize: 100,
              style: TabStyle.react,
              items: [
                TabItem(icon: MyIcons.globe, title: getTranslated(context, 'home_b_bar_countries')),
                TabItem(icon: Icons.shopping_bag, title: getTranslated(context, 'home_b_bar_stores')),
                TabItem(icon: Icons.home, title: getTranslated(context, 'home_b_bar_home')),
                TabItem(icon: Icons.favorite, title: getTranslated(context, 'home_b_bar_fav')),
                TabItem(icon: Icons.people, title: getTranslated(context, 'home_b_bar_profile')),
              ],
              initialActiveIndex: 4,//optional, default as 0
              onTap: onTabTapped,
            ))
    );

  }
  void onTabTapped(int index) {
    if (index == 0) {
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Countries()),
      );
    } else if (index == 1) {
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => null),
      );
    } else if (index == 2) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Home()));
    } else if (index == 3) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Favorites()));
    } else if (index == 4) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Settings()));
    }
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 40;

  @override
  double get activeIconMargin => 7;

  @override
  double get iconSize => 16;

  @override
  TextStyle textStyle(Color color) {
    return TextStyle(fontSize: 14,fontFamily: "CustomFont", color: color);
  }
}