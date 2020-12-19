import 'package:couponsgate/localization/localizationValues.dart';
import 'package:flutter/material.dart';

class Terms extends StatefulWidget {
  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2f3640),
        centerTitle: true,
        title: Text(getTranslated(context, 'terms_title')),
      ),
    );
  }
}
