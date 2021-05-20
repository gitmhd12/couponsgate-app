import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/ApiAssistant.dart';
import 'package:couponsgate/widgets/settings.dart';
import 'package:couponsgate/widgets/stores/all_stores.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../my_icons_icons.dart';
import 'countries.dart';
import 'favorites.dart';
import 'home.dart';


class add_coupon extends StatefulWidget {
  @override
  _add_coupon createState() => _add_coupon();
}


class _add_coupon extends State<add_coupon> {

  ApiAssistant api = new ApiAssistant();

  int _sendBtnChildIndex = 0;

  var addBtnChildIndex = false;

  final TextEditingController store_name_Controller = new TextEditingController();
  final TextEditingController des_Controller = new TextEditingController();
  final TextEditingController code_Controller = new TextEditingController();
  final TextEditingController store_url_Controller = new TextEditingController();
  final TextEditingController email_Controller = new TextEditingController();

  Widget _addButton() {
    return InkWell(onTap: () {
      sendCoupon();
    } , child: Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(7),
      margin: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
          borderRadius: BorderRadius.circular(5),
          color: Color(0xFF2196f3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          addBtnChildIndex ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ):

          Text(
            getTranslated(context, 'add_coupon_button'),
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: "CustomFont",
              fontWeight: FontWeight.w300,
            ),
            softWrap: true,
          ),
        ],
      ),
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color(0xFF2f3640),
        elevation: 0,
        centerTitle: true,
        title: Text(getTranslated(context, 'add_coupon_title')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey, width: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(10),

              //color: Colors.grey,
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(

                  children: [
                    SizedBox(height: 20,),
                    TextField(
                        keyboardType: TextInputType.text,
                        controller: store_name_Controller,
                        style: TextStyle(color: Color(0xff000000), fontSize: 18,fontFamily: "CustomFont"),


                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 0.5),
                            ),

                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 0.5),
                            ),


                          hintText: getTranslated(context, 'add_coupon_store_name'),
                            hintStyle: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "CustomFont",
                              color: Color(0xff999999),
                            ),
                            /*prefixIcon: Icon(
                            MyIcons.icons,
                            color: Color(0xff34495e),
                          ),*/
                            fillColor: Colors.white,
                            filled: true)),
                    SizedBox(height: 10,),
                    TextField(
                        keyboardType: TextInputType.text,
                        controller: des_Controller,
                        style: TextStyle(color: Color(0xff000000), fontSize: 18,fontFamily: "CustomFont"),

                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 0.5),
                            ),

                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 0.5),
                            ),
                          hintText: getTranslated(context, 'add_coupon_des'),
                            hintStyle: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "CustomFont",
                              color: Color(0xff999999),
                            ),
                            /*prefixIcon: Icon(
                            MyIcons.icons,
                            color: Color(0xff34495e),
                          ),*/
                            fillColor: Colors.white,
                            filled: true)),
                    SizedBox(height: 10,),
                    TextField(
                        keyboardType: TextInputType.text,
                        controller: code_Controller,
                        style: TextStyle(color: Color(0xff000000), fontSize: 18,fontFamily: "CustomFont"),

                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 0.5),
                            ),

                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 0.5),
                            ),
                            hintText: getTranslated(context, 'add_coupon_code'),
                            hintStyle: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "CustomFont",
                              color: Color(0xff999999),
                            ),
                            /*prefixIcon: Icon(
                            MyIcons.icons,
                            color: Color(0xff34495e),
                          ),*/
                            fillColor: Colors.white,
                            filled: true)),
                    SizedBox(height: 10,),
                    TextField(
                        keyboardType: TextInputType.text,
                        controller: store_url_Controller,
                        style: TextStyle(color: Color(0xff000000), fontSize: 18,fontFamily: "CustomFont"),

                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 0.5),
                            ),

                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 0.5),
                            ),
                            hintText: getTranslated(context, 'add_coupon_store_url'),
                            hintStyle: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "CustomFont",
                              color: Color(0xff999999),
                            ),
                            /*prefixIcon: Icon(
                            MyIcons.icons,
                            color: Color(0xff34495e),
                          ),*/
                            fillColor: Colors.white,
                            filled: true)),
                    SizedBox(height: 10,),
                    TextField(
                        keyboardType: TextInputType.text,
                        controller: email_Controller,
                        style: TextStyle(color: Color(0xff000000), fontSize: 18,fontFamily: "CustomFont"),

                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 0.5),
                            ),

                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 0.5),
                            ),
                            hintText: getTranslated(context, 'add_coupon_email'),
                            hintStyle: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "CustomFont",
                              color: Color(0xff999999),
                            ),
                            /*prefixIcon: Icon(
                            MyIcons.icons,
                            color: Color(0xff34495e),
                          ),*/
                            fillColor: Colors.white,
                            filled: true)),
                    SizedBox(height: 20,),

                    Text(getTranslated(context, 'add_coupon_terms'),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    Text(getTranslated(context, 'add_coupon_terms1'),style: TextStyle(fontSize: 14),),
                    Text(getTranslated(context, 'add_coupon_terms2'),style: TextStyle(fontSize: 14),),
                    Text(getTranslated(context, 'add_coupon_terms3'),style: TextStyle(fontSize: 14),),
                    SizedBox(height: 20,),
                  ],
                )
              )

            ),

            _addButton(),
          ],
        ),
      ),
      bottomNavigationBar: StyleProvider(
          style: Style(),
          child: ConvexAppBar(
            color: Colors.white,
            //backgroundColor: Colors.white,
            //activeColor: Colors.deepOrange,
            height: 50,
            //top: -30,
            //curveSize: 100,
            style: TabStyle.react,
            items: [
              TabItem(icon: MyIcons.globe, title: getTranslated(context, 'home_b_bar_countries')),
              TabItem(icon: Icons.shopping_bag, title: getTranslated(context, 'home_b_bar_stores')),
              TabItem(icon: Icons.add_box, title: getTranslated(context, 'add_coupon_title')),
              TabItem(icon: Icons.favorite, title: getTranslated(context, 'home_b_bar_fav')),
              TabItem(icon: Icons.home, title: getTranslated(context, 'home_b_bar_home')),
            ],
            initialActiveIndex: 2,//optional, default as 0
            onTap: onTabTapped,
          )),
    );

  }
  void onTabTapped(int index) {
    if (index == 0) {
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Countries()),
      );
    } else if (index == 1) {
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new AllStores()),
      );
    } else if (index == 2) {
      /*Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Home()));*/
    } else if (index == 3) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Favorites()));
    } else if (index == 4) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Home()));
    }
  }

  sendCoupon () async {
    if (_sendBtnChildIndex == 0) {

      setState(() {
        _sendBtnChildIndex = 1;
      });
      if (store_name_Controller.text.trim().isEmpty)
      {
        alertDialog(getTranslated(context, 'missing_data_msg'), getTranslated(context, 'login_alert_md_title'),);
        setState(() {
          _sendBtnChildIndex = 0;
        });
        return;
      }

      if (des_Controller.text.trim().isEmpty)
      {
        alertDialog(getTranslated(context, 'missing_data_msg'), getTranslated(context, 'login_alert_md_title'),);
        setState(() {
          _sendBtnChildIndex = 0;
        });
        return;
      }

      if (code_Controller.text.trim().isEmpty)
      {
        alertDialog(getTranslated(context, 'missing_data_msg'), getTranslated(context, 'login_alert_md_title'),);
        setState(() {
          _sendBtnChildIndex = 0;
        });
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final key = 'is_login';
      final is_login_value = prefs.get(key) ?? 0;

      String user_id = "";

      if (is_login_value == "1") {
        final key5 = 'user_id';
        user_id = prefs.getString(key5);
      }else{
        user_id = "0";
      }

      print(store_name_Controller.text);
      print(des_Controller.text);
      print(code_Controller.text);
      print(store_url_Controller.text);
      print(email_Controller.text);
      print(user_id);

      api.sendCoupon(store_name_Controller.text,
          des_Controller.text, code_Controller.text, store_url_Controller.text, email_Controller.text, user_id).whenComplete((){
        if(api.addCouponStatus == true)
        {
          successDialog(getTranslated(context, 'contact_us_alert_success_content'), getTranslated(context, 'settings_alert_success_title'),);

          setState(() {
            _sendBtnChildIndex = 0;
          });
        }
        else
        {
          alertDialog(getTranslated(context, 'error_form_msg'), getTranslated(context, 'login_alert_Ind_title'),);
          setState(() {
            _sendBtnChildIndex = 0;
          });
        }
      });

    }
  }

  alertDialog(String text, String title) {
    showDialog(
        context: context,
        builder: (_) => AssetGiffyDialog(
          onlyOkButton: true,
          buttonCancelText: Text(getTranslated(context, 'login_alert_d_cancel'),
              style: TextStyle(fontFamily: "CustomIcons", fontSize: 16)),
          buttonOkText: Text(getTranslated(context, 'login_alert_d_ok'),
              style: TextStyle(
                  fontFamily: "CustomIcons",
                  fontSize: 16,
                  color: Colors.white)),
          buttonOkColor: Colors.redAccent,
          image: Image.asset('assets/images/alert.png', fit: BoxFit.cover),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 18.0,
                fontFamily: "CustomIcons",
                color: Colors.redAccent),
          ),
          description: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "CustomIcons", fontSize: 16),
          ),
          onOkButtonPressed: () {
            Navigator.pop(context);
          },
        ));
  }

  successDialog(String text, String title) {
    showDialog(
        context: context,
        builder: (_) => AssetGiffyDialog(
          onlyOkButton: true,
          buttonCancelText: Text(getTranslated(context, 'login_alert_d_cancel'),
              style: TextStyle(fontFamily: "CustomIcons", fontSize: 16)),
          buttonOkText: Text(getTranslated(context, 'login_alert_d_ok'),
              style: TextStyle(
                  fontFamily: "CustomIcons",
                  fontSize: 16,
                  color: Colors.white)),
          buttonOkColor: Colors.green,
          image: Image.asset('assets/images/success.png', fit: BoxFit.cover),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 18.0,
                fontFamily: "CustomIcons",
                color: Colors.green),
          ),
          description: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "CustomIcons", fontSize: 16),
          ),
          onOkButtonPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ));
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 40;

  @override
  double get activeIconMargin => 7;

  @override
  double get iconSize => 16;

  @override
  TextStyle textStyle(Color color) {
    return TextStyle(fontSize: 14,fontFamily: "CustomFont", color: color);
  }
}