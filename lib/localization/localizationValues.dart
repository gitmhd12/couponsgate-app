import 'package:couponsgate/localization/center_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getTranslated(BuildContext buildContext, String key) {
  return CenterLocalization.of(buildContext).getTranslatedValue(key);
}

const String ARABIC = 'ar';
const String ENGLISH = 'en';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  await _sharedPreferences.setString('languageCode', languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  String lCode = _sharedPreferences.getString('languageCode') ?? ENGLISH;
  return _locale(lCode);
}

Locale _locale(String langCode) {
  Locale _locale;

  switch (langCode) {
    case ARABIC:
      _locale = Locale(langCode, 'SA');
      break;
    case ENGLISH:
      _locale = Locale(langCode, 'US');
      break;
    default:
      _locale = Locale(ARABIC, 'SA');
  }

  return _locale;
}
