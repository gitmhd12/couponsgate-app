import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/Language.dart';
import 'package:couponsgate/routes/routes_names.dart';
import 'package:couponsgate/widgets/NavDrawer.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Container _drawerList() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.6,
      child: ListView(children: <Widget>[
        DrawerHeader(
          child: Container(height: 100, child: CircleAvatar()),
        ),
        ListTile(
          title: Text(getTranslated(context, 'drawer_settings')),
          onTap: () {
            Navigator.pushNamed(context, settingsRoute);
          },
        )
      ]),
    );
  }

  void _changeLanguage(Language lang) async {
    Locale _locale = await setLocale(lang.code);

    MyApp.setLocale(context, _locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xFF2f3640),
        centerTitle: true,
        title: Text(getTranslated(context, 'home_title')),
      ),
      body: Center(
        child: Text(getTranslated(context, 'home_subtitle')),
      ),
    );
  }
}
