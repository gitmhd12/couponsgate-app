import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/Language.dart';
import 'package:couponsgate/routes/routes_names.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Container _drawerList() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: ListView(children: <Widget>[
        DrawerHeader(
          child: Container(height: 100, child: CircleAvatar()),
        ),
        ListTile(
          title: Text('الإعدادات'),
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
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          DropdownButton(
            icon: Icon(Icons.language),
            underline: SizedBox(),
            items: Language.languageList()
                .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
                      value: lang,
                      child: Text(lang.name),
                    ))
                .toList(),
            onChanged: (Language lang) {
              _changeLanguage(lang);
            },
          )
        ],
        title: Text(getTranslated(context, 'home_title')),
      ),
      drawer: _drawerList(),
      body: Center(
        child: Text(getTranslated(context, 'home_subtitle')),
      ),
    );
  }
}
