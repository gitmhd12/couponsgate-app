import 'package:couponsgate/localization/localizationValues.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       // backgroundColor: Color(0xFF2f3640),
        elevation: 0,
        centerTitle: true,
        title: Text(getTranslated(context, 'contact_us_title')),
      ),
    );
  }
}
