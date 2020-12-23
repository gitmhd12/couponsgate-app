import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/widgets/NavDrawer.dart';
import 'package:couponsgate/widgets/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import '../my_icons_icons.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int lsubmit_btn_child_index = 0;
  final search_nameController = TextEditingController();


  submite_button_child() {
    if (lsubmit_btn_child_index == 0) {
      return Text(
        ' ابحث ',
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: "CustomFont",
          color: Colors.white,
          fontSize: 25,
        ),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      drawer: NavDrawer(),
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(getTranslated(context, 'home_title'),style: TextStyle(fontFamily: 'CustomFont',color: Colors.black),),
      ),
      body:Builder(
          builder: (context) => SingleChildScrollView(
              child: Column(children: [
                //search card
                Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(10),
                    //color: Colors.grey,
                    elevation: 0,

                    child:Column(
                      //mainAxisSize: MainAxisSize.min,
                      //scrollDirection: Axis.vertical,
                        children: <Widget>[

                          Padding(
                              padding: const EdgeInsets.all(0),
                              child:TextFormField(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    //fontWeight: FontWeight.w600,
                                    fontFamily: "CustomFont",
                                  ),
                                  controller: search_nameController,
                                  keyboardType: TextInputType.text,
                                  maxLines: null,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.only(top: 20), // add padding to adjust text
                                    isDense: true,
                                    hintText: getTranslated(context, 'home_search_hint'),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(top: 15), // add padding to adjust icon
                                      child: Icon(Icons.search),
                                    ),
                                  )
                              )),

                          /*InkWell(onTap:(){ } , child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),

                    color: Colors.deepOrange),
                child: submite_button_child(),
              ),
              ),*/

                        ])),



                //coupons text
                Row(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    //verticalDirection: VerticalDirection.up,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    //scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top:15,right: 10,left: 10,bottom: 0),
                          child: Text("أحدث الكوبونات",style: TextStyle(fontSize: 25,fontFamily: "CustomFont",fontWeight: FontWeight.bold,color: Colors.black),)),

                      Padding(
                          padding: const EdgeInsets.only(top:15,right: 10,left: 10,bottom: 0),
                          child: Text("عرض الكل",style: TextStyle(fontSize: 15,fontFamily: "CustomFont"),)),


                    ]),
                //coupon card
                Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(10),
                    //color: Colors.grey,
                    elevation: 0,

                    child:Column(children: [

                      Row(

                          crossAxisAlignment: CrossAxisAlignment.center,
                          //verticalDirection: VerticalDirection.up,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          //scrollDirection: Axis.vertical,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset("assets/images/souq.png",width: 100,height: 100,fit: BoxFit.cover,)),


                            Container (
                              padding: const EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width-150,
                              child: new Column (
                                children: <Widget>[
                                  Text('كوبون موقع اناس ounass تخفيض 10% لكل المنتجات ',style: TextStyle(fontSize: 20,fontFamily: "CustomFont",fontWeight: FontWeight.bold),textAlign: TextAlign.center,)

                                ],
                              ),
                            )

                          ]),
                      SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          //color: Colors.white,
                            margin: const EdgeInsets.only(top: 0, bottom: 0.0),
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                  onPressed: () async {
                                    ClipboardManager.copyToClipBoard("your text to copy").then((result) {
                                      _displaySnackBar(context);
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),topRight: Radius.circular(5)),
                                    side: BorderSide(
                                        color: Color(0xFFf9844a),
                                        width: 0,
                                        style: BorderStyle.solid),

                                  ),
                                  color: Colors.deepOrange,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.copy,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        getTranslated(context, 'home_copy_code'),
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontFamily: "CustomFont",
                                          fontWeight: FontWeight.w300,
                                        ),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    ClipboardManager.copyToClipBoard("your text to copy").then((result) {
                                      final snackBar = SnackBar(
                                        content: Text('Copied to Clipboard'),
                                        action: SnackBarAction(
                                          label: 'Undo',
                                          onPressed: () {},
                                        ),
                                      );
                                      Scaffold.of(context).showSnackBar(snackBar);
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.red,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),topLeft: Radius.circular(5)),
                                  ),
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'XHYZM',
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.black,
                                          fontFamily: "CustomFont",
                                          fontWeight: FontWeight.bold,
                                        ),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(height: 15,),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child:Row(

                            crossAxisAlignment: CrossAxisAlignment.center,
                            //verticalDirection: VerticalDirection.up,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [

                              //shop now
                              InkWell(onTap:(){ } , child: Container(
                                width: MediaQuery.of(context).size.width-100,
                                padding: const EdgeInsets.all(3),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFF3a86ff)),
                                    //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xFF3a86ff)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.shopping_bag,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      getTranslated(context, 'shop_now'),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontFamily: "CustomFont",
                                        fontWeight: FontWeight.w300,
                                      ),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),),
                              //favorite
                              InkWell(onTap:(){ } , child: Container(
                                width: 50,
                                padding: const EdgeInsets.all(3),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red),
                                    //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xFFffffff)),
                                child: Icon(Icons.favorite_border,color: Colors.red,),
                              ),),



                            ],))
                    ],)

                ),
                Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(10),
                    //color: Colors.grey,
                    elevation: 0,

                    child:Column(children: [

                      Row(

                          crossAxisAlignment: CrossAxisAlignment.center,
                          //verticalDirection: VerticalDirection.up,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          //scrollDirection: Axis.vertical,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset("assets/images/namshi.jpg",width: 100,height: 100,fit: BoxFit.cover,)),


                            Container (
                              padding: const EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width-150,
                              child: new Column (
                                children: <Widget>[
                                  Text('كوبون موقع نمشي تخفيض 30% لكل المنتجات ',style: TextStyle(fontSize: 20,fontFamily: "CustomFont",fontWeight: FontWeight.bold),textAlign: TextAlign.center,)

                                ],
                              ),
                            )

                          ]),
                      SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          //color: Colors.white,
                            margin: const EdgeInsets.only(top: 0, bottom: 0.0),
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                  onPressed: () async {
                                    ClipboardManager.copyToClipBoard("your text to copy").then((result) {
                                      _displaySnackBar(context);
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),topRight: Radius.circular(5)),
                                    side: BorderSide(
                                        color: Color(0xFFf9844a),
                                        width: 0,
                                        style: BorderStyle.solid),

                                  ),
                                  color: Colors.deepOrange,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.copy,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        getTranslated(context, 'home_copy_code'),
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontFamily: "CustomFont",
                                          fontWeight: FontWeight.w300,
                                        ),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    ClipboardManager.copyToClipBoard("your text to copy").then((result) {
                                      final snackBar = SnackBar(
                                        content: Text('Copied to Clipboard'),
                                        action: SnackBarAction(
                                          label: 'Undo',
                                          onPressed: () {},
                                        ),
                                      );
                                      Scaffold.of(context).showSnackBar(snackBar);
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.red,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),topLeft: Radius.circular(5)),
                                  ),
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'XHYZM',
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.black,
                                          fontFamily: "CustomFont",
                                          fontWeight: FontWeight.bold,
                                        ),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(height: 15,),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child:Row(

                            crossAxisAlignment: CrossAxisAlignment.center,
                            //verticalDirection: VerticalDirection.up,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [

                              //shop now
                              InkWell(onTap:(){ } , child: Container(
                                width: MediaQuery.of(context).size.width-100,
                                padding: const EdgeInsets.all(3),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFF3a86ff)),
                                    //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xFF3a86ff)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.shopping_bag,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      getTranslated(context, 'shop_now'),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontFamily: "CustomFont",
                                        fontWeight: FontWeight.w300,
                                      ),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),),
                              //favorite
                              InkWell(onTap:(){ } , child: Container(
                                width: 50,
                                padding: const EdgeInsets.all(3),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red),
                                    //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xFFffffff)),
                                child: Icon(Icons.favorite_border,color: Colors.red,),
                              ),),



                            ],))
                    ],)

                ),

                //stores text
                Row(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    //verticalDirection: VerticalDirection.up,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    //scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top:15,right: 10,left: 10,bottom: 0),
                          child: Text("أفضل المتاجر",style: TextStyle(fontSize: 25,fontFamily: "CustomFont",fontWeight: FontWeight.bold,color: Colors.black),)),

                      Padding(
                          padding: const EdgeInsets.only(top:15,right: 10,left: 10,bottom: 0),
                          child: Text("عرض الكل",style: TextStyle(fontSize: 15,fontFamily: "CustomFont"),)),


                    ]),
                //stores list
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 150.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              width: 75,
                              height: 75,
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              decoration: new BoxDecoration(
                                  border: Border.all(color: Colors.grey,width: 1),
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new AssetImage("assets/images/namshi.jpg")
                                  )
                              )),
                          new Text("نمشي",style: TextStyle(fontFamily: "CustomFont",fontSize: 16),)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              width: 75,
                              height: 75,
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              decoration: new BoxDecoration(
                                  border: Border.all(color: Colors.grey,width: 1),
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new AssetImage("assets/images/souq.png")
                                  )
                              )),
                          new Text("سوق.كوم",style: TextStyle(fontFamily: "CustomFont",fontSize: 16),)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              width: 75,
                              height: 75,
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              decoration: new BoxDecoration(
                                  border: Border.all(color: Colors.grey,width: 1),
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new AssetImage("assets/images/ounas.jpg")
                                  )
                              )),
                          new Text("أوناس",style: TextStyle(fontFamily: "CustomFont",fontSize: 16),)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              width: 75,
                              height: 75,
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              decoration: new BoxDecoration(
                                  border: Border.all(color: Colors.grey,width: 1),
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new AssetImage("assets/images/marsoul.png")
                                  )
                              )),
                          new Text("مرسول",style: TextStyle(fontFamily: "CustomFont",fontSize: 16),)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                              width: 75,
                              height: 75,
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              decoration: new BoxDecoration(
                                  border: Border.all(color: Colors.grey,width: 1),
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new AssetImage("assets/images/iherb.png")
                                  )
                              )),
                          new Text("IHerb",style: TextStyle(fontFamily: "CustomFont",fontSize: 16),)
                        ],
                      ),

                    ],
                  ),
                ),

              ]))),
        bottomNavigationBar: StyleProvider(
    style: Style(),
    child: ConvexAppBar(
          color: Colors.white,
          //backgroundColor: Colors.white,
          //activeColor: Colors.deepOrange,
          //height: 50,
          //top: -30,
          //curveSize: 100,
          style: TabStyle.titled,
          items: [
            TabItem(icon: MyIcons.globe, title: 'الدول'),
            TabItem(icon: Icons.shopping_bag, title: 'المتاجر'),
            TabItem(icon: Icons.home, title: 'الرئيسية'),
            TabItem(icon: Icons.favorite, title: 'المفضلة'),
            TabItem(icon: Icons.people, title: 'حسابي'),
          ],
          initialActiveIndex: 2,//optional, default as 0
          onTap: (int i) => print('click index=$i'),
        ))
    );
  }



  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Are you talkin\' to me?'));
    Scaffold.of(context).showSnackBar(snackBar);
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
