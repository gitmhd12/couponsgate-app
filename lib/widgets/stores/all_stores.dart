import 'dart:async';
import 'dart:io';
import 'package:couponsgate/localization/localizationValues.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:responsive_grid/responsive_grid.dart';


class AllStores extends StatefulWidget {
  @override
  _AllStores createState() => _AllStores();
}

class _AllStores extends State<AllStores> {

  var is_loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color(0xFF2f3640),
        elevation: 0,
        centerTitle: true,
        title: Text(getTranslated(context, 'home_stores_title')),
      ),
      body: SingleChildScrollView(
          child:  Column(
        children: [
          is_loading ? new Center(
          child: new GFLoader(type: GFLoaderType.circle),
          ): ResponsiveGridRow(
                children: [

                ])
        ],
      ),)
    );
  }

}