import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/widgets/adbout_us.dart';
import 'package:couponsgate/widgets/contact_us.dart';
import 'package:couponsgate/widgets/favorites.dart';
import 'package:couponsgate/widgets/login.dart';
import 'package:couponsgate/widgets/my_icons_icons.dart';
import 'package:couponsgate/widgets/privacy.dart';
import 'package:couponsgate/widgets/profile.dart';
import 'package:couponsgate/widgets/settings.dart';
import 'package:couponsgate/widgets/terms.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotted_border/dotted_border.dart';


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

  _logout() async
  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));

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
                FittedBox(
                  child: Image.asset(
                    'assets/images/text_logo.png',
                    width: 170.0,
                    height: 100.0,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                FittedBox(
                  child: Text(
                    username,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xFF2196f3),
            ),
          ),
          //profile
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Color(0xFF2196f3),
            ),
            title: Text(
              getTranslated(context, 'drawer_settings'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Settings()))
            },
          ),

          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Color(0xFF2196f3),
            ),
            title: Text(
              getTranslated(context, 'drawer_favorites'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Favorites()))
            },
          ),

          Divider(
            color: Color(0xFF2196f3),
          ),
          //about
          ListTile(
            leading: Icon(
              Icons.info,
              color: Color(0xFF2196f3),
            ),
            title: Text(
              getTranslated(context, 'drawer_about_us'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new AboutUs()))
            },
          ),
          //contact us
          ListTile(
            leading: Icon(
              Icons.mail,
              color: Color(0xFF2196f3),
            ),
            title: Text(
              getTranslated(context, 'drawer_contact_us'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new ContactUs()))
            },
          ),
          //terms
          ListTile(
            leading: Icon(
              Icons.book,
              color: Color(0xFF2196f3),
            ),
            title: Text(
              getTranslated(context, 'drawer_terms'),
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
              color: Color(0xFF2196f3),
            ),
            title: Text(
              getTranslated(context, 'drawer_privacy_policy'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Privacy()))
            },
          ),

          ListTile(
            leading: Icon(
              Icons.book,
              color: Color(0xFF2196f3),
            ),
            title: Text(
              getTranslated(context, 'drawer_faq'),
            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Terms()))
            },
          ),
          Divider(
            color: Color(0xFF2196f3),
          ),

          //log out
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Color(0xFF2196f3),
            ),
            title: guest
                ? Text(
                    getTranslated(context, 'drawer_login'),
                  )
                : Text(
                    getTranslated(context, 'drawer_logout'),
                  ),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
