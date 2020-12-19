import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/widgets/adbout_us.dart';
import 'package:couponsgate/widgets/contact_us.dart';
import 'package:couponsgate/widgets/favorites.dart';
import 'package:couponsgate/widgets/login.dart';
import 'package:couponsgate/widgets/privacy.dart';
import 'package:couponsgate/widgets/profile.dart';
import 'package:couponsgate/widgets/settings.dart';
import 'package:couponsgate/widgets/terms.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:couponsgate/widgets/my_icons_icons.dart';

class NavDrawer extends StatefulWidget {
  @override
  NavDrawerState createState() => NavDrawerState();
}

class NavDrawerState extends State<NavDrawer> {
  String username;
  var guest = false;
  checkIfGuest() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    print('$value');
    if (value != '1') {
      setState(() {
        guest = true;
      });
    } else {
      final key = 'name';
      final value = prefs.get(key);
      setState(() {
        username = value;
      });
    }
  }

  void initState() {
    super.initState();

    username = ' ';
    checkIfGuest();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/demo_logo.PNG',
                  width: 125.0,
                  height: 50.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  username,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xFF222222),
            ),
          ),
          //profile
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Color(0xFF2f3640),
            ),
            title: Text(
              getTranslated(context, 'drawer_profile'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Profile()))
            },
          ),

          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Color(0xFF2f3640),
            ),
            title: Text(
              getTranslated(context, 'drawer_favorites'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Favorites()))
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Color(0xFF2f3640),
            ),
            title: Text(
              getTranslated(context, 'drawer_settings'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Settings()))
            },
          ),
          Divider(
            color: Color(0xFF2f3640),
          ),
          //about
          ListTile(
            leading: Icon(
              Icons.info,
              color: Color(0xFF2f3640),
            ),
            title: Text(
              getTranslated(context, 'drawer_about_us'),
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new AboutUs()))
            },
          ),
          //terms
          ListTile(
            leading: Icon(
              Icons.book,
              color: Color(0xFF2f3640),
            ),
            title: Text(
              getTranslated(context, 'drawer_terms'),
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Terms()))
            },
          ),
          //privacy
          ListTile(
            leading: Icon(
              Icons.book,
              color: Color(0xFF2f3640),
            ),
            title: Text(
              getTranslated(context, 'drawer_privacy_policy'),
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Privacy()))
            },
          ),
          Divider(
            color: Color(0xFF2f3640),
          ),
          //contact us
          ListTile(
            leading: Icon(
              Icons.mail,
              color: Color(0xFF2f3640),
            ),
            title: Text(
              getTranslated(context, 'drawer_contact_us'),
              style: TextStyle(fontFamily: 'CustomIcons'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new ContactUs()))
            },
          ),
          //log out
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Color(0xFF2f3640),
            ),
            title: guest
                ? Text(
                    getTranslated(context, 'drawer_login'),
                    style: TextStyle(fontFamily: 'CustomIcons'),
                  )
                : Text(
                    getTranslated(context, 'drawer_logout'),
                    style: TextStyle(fontFamily: 'CustomIcons'),
                  ),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final key = 'is_login';
              final value = "0";
              prefs.setString(key, value);
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Login()));
            },
          ),
        ],
      ),
    );
  }

  Widget login_text() {
    return Text(
      "تسجيل الدخول",
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: "CustomIcons",
          fontSize: 20),
      textAlign: TextAlign.center,
    );
  }
}
