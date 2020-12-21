import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/widgets/NavDrawer.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        elevation: 0,

        centerTitle: true,
        title: Text(getTranslated(context, 'home_title')),
      ),
      body: Center(
        child: Text(getTranslated(context, 'home_subtitle')),
      ),
    );
  }
}
