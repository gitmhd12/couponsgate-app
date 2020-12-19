import 'package:couponsgate/localization/localizationValues.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2f3640),
        centerTitle: true,
        title: Text(getTranslated(context, 'profile_title')),
      ),
    );
  }
}
