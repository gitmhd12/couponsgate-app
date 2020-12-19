import 'package:couponsgate/localization/localizationValues.dart';
import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2f3640),
        centerTitle: true,
        title: Text(getTranslated(context, 'favorites_title')),
      ),
    );
  }
}
