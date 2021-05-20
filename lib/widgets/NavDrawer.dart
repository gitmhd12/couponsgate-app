import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/ApiAssistant.dart';
import 'package:couponsgate/modules/Language.dart';
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
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';


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
    if(guest == false){
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }


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

    Locale currentLocale = Localizations.localeOf(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 220,
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
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),

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
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),

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
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),

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
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),

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
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),

            ),
            onTap: () => {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Terms()))
            },
          ),


          Divider(
            color: Color(0xFF2196f3),
          ),

          currentLocale.languageCode == 'ar'?
          ListTile(
            leading: Icon(
              Icons.language,
              color: Color(0xFF2196f3),
            ),
            title: Text(
              'English',
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),

            ),
            onTap: () => {
              _changeLanguage(Language(1, 'English', 'en'))
            },
          ):ListTile(
            leading: Icon(
              Icons.language,
              color: Color(0xFF2196f3),
            ),
            title: Text(
              'العربية',
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),

            ),
            onTap: () => {
              _changeLanguage(Language(2, 'العربية', 'ar'))
            },
          ),

          Divider(
            color: Color(0xFF2196f3),
          ),

          ListTile(
            leading: Icon(
              Icons.share,
              color: Color(0xFF2196f3),
            ),
            title: Text(
              getTranslated(context, 'drawer_app_share'),
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),

            ),
            onTap: () => {
            Share.share(getTranslated(context, 'share_app_text') +
            '''
            
            https://play.google.com/store/apps/details?id=net.couponsgate
            ''' )
            },
          ),

          ListTile(
            leading: Icon(
              Icons.star_rate,
              color: Color(0xFF2196f3),
            ),
            title: Text(
              getTranslated(context, 'drawer_app_rate'),
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),

            ),
            onTap: () => {

              _launchURL()
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
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),

            )
                : Text(
                    getTranslated(context, 'drawer_logout'),
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),

            ),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  ApiAssistant api = new ApiAssistant();

  void _changeLanguage(Language lang) async {
    Locale currentLocale = Localizations.localeOf(context);

    print(lang.code);
    print(currentLocale.languageCode);

    Locale _locale = await setLocale(lang.code);
    MyApp.setLocale(context, _locale);

    api.getUserNotificationByLocal(currentLocale.languageCode, lang.code);
  }

  _launchURL() async {
    const url = 'https://play.google.com/store/apps/details?id=net.couponsgate';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
