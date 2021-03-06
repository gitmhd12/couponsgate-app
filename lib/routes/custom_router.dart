import 'package:couponsgate/routes/routes_names.dart';
import 'package:couponsgate/widgets/home.dart';
import 'package:couponsgate/widgets/login.dart';
import 'package:couponsgate/widgets/not_found.dart';
import 'package:couponsgate/widgets/select_contry.dart';
import 'package:couponsgate/widgets/settings.dart';
import 'package:couponsgate/widgets/splash.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => Splash());

      case homeRoute:
        return MaterialPageRoute(builder: (_) => Home());

      case loginRoute:
        return MaterialPageRoute(builder: (_) => Login());

      case settingsRoute:
        return MaterialPageRoute(builder: (_) => Settings());

      case SelectCountry:
        return MaterialPageRoute(builder: (_) => Select_Country());
    }
    return MaterialPageRoute(builder: (_) => NotFound());
  }
}
