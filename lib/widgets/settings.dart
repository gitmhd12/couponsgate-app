import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/Language.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void _changeLanguage(Language lang) async {
    Locale _locale = await setLocale(lang.code);

    MyApp.setLocale(context, _locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color(0xFF2f3640),
        elevation: 0,
        centerTitle: true,
        title: Text(getTranslated(context, 'settings_title')),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    getTranslated(context, 'settings_lang_label'),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Color(0xFF2f3640),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      getTranslated(context, 'settings_lang_picker_label'),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: DropdownButton(
                      icon: Icon(Icons.language),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Color(0xFF2f3640),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
