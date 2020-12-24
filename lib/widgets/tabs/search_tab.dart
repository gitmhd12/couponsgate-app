import 'package:flutter/material.dart';
import 'package:clipboard_manager/clipboard_manager.dart';

import '../NavDrawer.dart';

class Search_tab extends StatefulWidget {
  @override
  _Search_tabState createState() => _Search_tabState();
}

class _Search_tabState extends State<Search_tab> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFffffff),
    //drawer: NavDrawer(),
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('نتائج البحث',style: TextStyle(fontFamily: 'CustomFont',color: Colors.black),),
      ),
    );
  }
}