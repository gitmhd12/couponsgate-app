import 'dart:convert';

import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/Coupon.dart';
import 'package:couponsgate/modules/Store.dart';
import 'package:couponsgate/widgets/NavDrawer.dart';
import 'package:couponsgate/widgets/settings.dart';
import 'package:couponsgate/widgets/tabs/search_tab.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';


import '../my_icons_icons.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final search_nameController = TextEditingController();
  var _controller = ScrollController();

  List<Store> _stores , _rStores = [];
  List<Coupon> _coupons , _extraCoupons = [] , _rCoupons = [];

  bool _isStoresLoading;
  bool _isCouponsLoading;
  bool _isLoadMore = false;
  bool _isCouponsEnd = false;
  bool _isGuest = true;
  String _currentCoupon = '0';
  String _userCountryCode;
  int lsubmit_btn_child_index = 0;
  int loadModeChildIndicator = 0;




  submite_button_child() {
    if (lsubmit_btn_child_index == 0) {
      return Text(
        getTranslated(context, 'home_search_btn'),
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

  _loadMoreButtonChild() {
    if (loadModeChildIndicator == 0) {
      return Text(getTranslated(context, 'home_coupons_load_more_btn'),
        style: TextStyle(fontFamily: 'CustomFont', color: Colors.black54),);
    } else {
      return GFLoader(
        type:GFLoaderType.circle,
        loaderColorOne: Color(0xFF2196f3),
        loaderColorTwo: Color(0xFF2196f3),
        loaderColorThree: Color(0xFF2196f3),
      );
    }
  }

  void _checkIfGuest() async
  {
    final prefs = await SharedPreferences.getInstance();
    final key = 'country_code';
    final value = prefs.get(key);

    if(value != null)
      {
        setState(() {
          _isGuest = false;
          _userCountryCode = value;
        });
      }
  }

  Future _getStores() async
  {
    var ssResponse = await http
        .get('https://couponsgate.net/app-dash/rest_api/stores/get_stores_sample.php');
    var ssData = json.decode(ssResponse.body);
    Store tStore;
    _stores = [];

    for (var ques in ssData['stores']) {
      tStore = Store.fromJson(ques);
      print(tStore.id);

      _stores.add(tStore);
      //print('depart length is : ' + departs.length.toString());
    }

    return _stores;
  }

  Future _getStoresByCountry(String countryCode) async
  {
    var ssResponse = await http
        .post('https://couponsgate.net/app-dash/rest_api/stores/get_stores_sample_by_country.php' , body: {
          'country' : countryCode
    });
    var ssData = json.decode(ssResponse.body);
    Store tStore;
    _stores = [];

    for (var ques in ssData['stores']) {
      tStore = Store.fromJson(ques);
      print(tStore.id);

      _stores.add(tStore);
      //print('depart length is : ' + departs.length.toString());
    }

    return _stores;
  }

  _initializeStoresSection() async
  {
    if(_isGuest)
      {
        _getStores().then((value){
          setState(() {
            _rStores = List.from(value);
            _isStoresLoading = false;
          });
        });
      }
    else
      {
        _getStoresByCountry(_userCountryCode).then((value){
          setState(() {
            _rStores = List.from(value);
            _isStoresLoading = false;
          });
        });
      }
  }

  String sPropertyByLocale(context , Store store , String type)
  {
    Locale currentLocale = Localizations.localeOf(context);

    if(currentLocale.languageCode == 'ar')
    {
      switch(type)
      {
        case 'name': return store.arName; break;
        case 'des': return store.arDescription; break;
      }
    }
    else
    {
      switch(type)
      {
        case 'name': return store.enName; break;
        case 'des': return store.enDescription; break;
      }
    }

  }

  Future _getCoupons() async
  {
    var ssResponse = await http
        .post('https://couponsgate.net/app-dash/rest_api/coupons/coupons_lazy_load_all.php' ,
        body: {'current_id' : _currentCoupon});

    var ssData = json.decode(ssResponse.body);
    Coupon tCoupon;
    _coupons = [];

    try
    {
      for (var ques in ssData['coupons']) {
        tCoupon = Coupon.fromJson(ques);
        print('coupons: $tCoupon.id');

        setState(() {
          _coupons.add(tCoupon);
        });
        //print('depart length is : ' + departs.length.toString());
      }
    }
    catch(e)
    {
      setState(() {
        _isLoadMore = false;
        _isCouponsEnd = true;
      });
    }

    return _coupons;
  }

  Future _getCouponsByCountry(String countryCode) async
  {
    var ssResponse = await http
        .post('https://couponsgate.net/app-dash/rest_api/coupons/coupons_lazy_load_by_country.php' , body: {
      'country' : countryCode,
      'current_id' : _currentCoupon,
    });
    var ssData = json.decode(ssResponse.body);
    Coupon tCoupon;
    _coupons = [];

    try
    {
      for (var ques in ssData['coupons']) {
        tCoupon = Coupon.fromJson(ques);
        print(tCoupon.id);

        setState(() {
          _coupons.add(tCoupon);
        });
        //print('depart length is : ' + departs.length.toString());
      }
    }
    catch(e)
    {
      setState(() {
        _isLoadMore = false;
        _isCouponsEnd = true;
      });
    }

    return _coupons;
  }

  _initializeCouponsSection() async
  {
    print('guest: $_isGuest');
    if(_isGuest)
    {
     await _getCoupons().then((value){
        setState(() {
          _extraCoupons = List.from(value);
          if(_extraCoupons.length > 0)
            {
              for(var coupon in _extraCoupons)
              {
                _rCoupons.add(coupon);
              }
                _currentCoupon = _rCoupons.last.id;
                print('>>$_currentCoupon');
            }

          _isCouponsLoading = false;
        });
      });
    }
    else
    {
      await _getCouponsByCountry(_userCountryCode).then((value){
        setState(() {
          _extraCoupons = List.from(value);
          for(var coupon in _extraCoupons)
          {
            _rCoupons.add(coupon);
          }

          if(_rCoupons.length > 0)
          {
            _currentCoupon = _rCoupons.last.id;
          }

          _isCouponsLoading = false;
        });
      });
    }
  }

  String cPropertyByLocale(context , Coupon coupon , String type)
  {
    Locale currentLocale = Localizations.localeOf(context);

    if(currentLocale.languageCode == 'ar')
    {
      switch(type)
      {
        case 'name': return coupon.arName; break;
        case 'des': return coupon.arDescription; break;
      }
    }
    else
    {
      switch(type)
      {
        case 'name': return coupon.enName; break;
        case 'des': return coupon.enDescription; break;
      }
    }

  }

  _loadMoreCoupons() async
  {
    setState(() {
      loadModeChildIndicator = 1;
    });

    if(_isGuest)
    {
      _getCoupons().then((value){
        setState(() {
          _extraCoupons = List.from(value);

          if(_extraCoupons.length > 0)
          {
            for(var coupon in _extraCoupons)
            {
              _rCoupons.add(coupon);
            }
            _currentCoupon = _rCoupons.last.id;
            print('>>$_currentCoupon');
          }

          loadModeChildIndicator = 0;
        });
      });
    }
    else
    {
      _getCouponsByCountry(_userCountryCode).then((value){
        setState(() {
          _extraCoupons = List.from(value);
          for(var coupon in _extraCoupons)
          {
            _rCoupons.add(coupon);
          }
          _currentCoupon = _rCoupons.last.id;
          loadModeChildIndicator = 0;
        });
      });
    }
  }

  void _listener() {
    if (_controller.position.atEdge) {
      if (_controller.position.pixels == 0)
        setState(() {
          _isLoadMore = false;
          _isCouponsEnd = false;
        });
      else {
        setState(() {
          _isLoadMore = true;
        });

      }
    } else
      setState(() {
        _isLoadMore = false;
        _isCouponsEnd = false;
      });
  }


  @override
  void initState() {
    super.initState();

    _controller.addListener(_listener);

    setState(() {
      _isStoresLoading = true;
      _isCouponsLoading = true;
      _currentCoupon = '0';
    });

    _checkIfGuest();

    _initializeStoresSection();
    _initializeCouponsSection();
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
                                    fontSize: 16,
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
                                    contentPadding: EdgeInsets.only(top: 12), // add padding to adjust text
                                    isDense: true,
                                    hintText: getTranslated(context, 'home_search_hint'),
                                    hintStyle:TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      //fontWeight: FontWeight.w600,
                                      fontFamily: "CustomFont",
                                    ) ,
                                    prefixIcon: Icon(
                                      Icons.search, size: 26,
                                      color: Color(0xff34495e),
                                    ),

                                  ),
                                onFieldSubmitted: (String str){Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new Search_tab()));},


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
                          child: Text(getTranslated(context, 'home_stores_title'),style: TextStyle(fontSize: 16,fontFamily: "CustomFont",fontWeight: FontWeight.bold,color: Colors.black),)),

                      Padding(
                          padding: const EdgeInsets.only(top:15,right: 10,left: 10,bottom: 0),
                          child: Text(getTranslated(context, 'home_stores_all_btn'),style: TextStyle(fontSize: 15,fontFamily: "CustomFont"),)),


                    ]),
                //stores list
                _isStoresLoading ?
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
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
                              )),
                          new Text(" ",style: TextStyle(fontFamily: "CustomFont",fontSize: 16),)
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
                              )),
                          new Text(" ",style: TextStyle(fontFamily: "CustomFont",fontSize: 16),)
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
                              )),
                          new Text(" ",style: TextStyle(fontFamily: "CustomFont",fontSize: 16),)
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
                              )),
                          new Text(" ",style: TextStyle(fontFamily: "CustomFont",fontSize: 16),)
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
                              )),
                          new Text(" ",style: TextStyle(fontFamily: "CustomFont",fontSize: 16),)
                        ],
                      ),

                    ],
                  ),
                )
                    : Container(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        height: 150.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _rStores.length,
                          itemBuilder: (context, index) {
                            return Column(
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
                                            image: new NetworkImage("https://couponsgate.net/app-dash/"+_rStores[index].logo),
                                        )
                                    )),
                                new Text(sPropertyByLocale(context, _rStores[index], 'name'),style: TextStyle(fontFamily: "CustomFont",fontSize: 16),)
                              ],
                            );
                          },
                        ),
                      ),

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
                          child: Text(getTranslated(context, 'home_coupons_title'),style: TextStyle(fontSize: 20,fontFamily: "CustomFont",color: Colors.black),)),

                      Padding(
                          padding: const EdgeInsets.only(top:15,right: 10,left: 10,bottom: 0),
                          child: Text(getTranslated(context, 'home_coupons_all_btn'),style: TextStyle(fontSize: 15,fontFamily: "CustomFont"),)),


                    ]),
                //coupon card

                _isCouponsLoading ? Container(
                  child: Center(child: GFLoader(
                      type:GFLoaderType.circle,
                    loaderColorOne: Color(0xFF2196f3),
                    loaderColorTwo: Color(0xFF2196f3),
                    loaderColorThree: Color(0xFF2196f3),
                  ),),
                ) : Container(
                  height: _rCoupons.length * 300.0,
                  child: ListView.builder(
                    controller: _controller,
                    itemCount: _rCoupons.length,
                    itemExtent: 300,
                    itemBuilder: (context , index){
                      return Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.all(10),

                          color: Color(0xFFe7e7e7),
                          //elevation: 0,

                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [

                              Row(

                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //verticalDirection: VerticalDirection.up,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,

                                  //scrollDirection: Axis.vertical,
                                  children: <Widget>[

                                    Container(
                                        width: 75,
                                        height: 75,
                                        padding: const EdgeInsets.all(0),
                                        margin: const EdgeInsets.all(0),
                                        decoration: new BoxDecoration(
                                          //border: Border.all(color: Colors.grey,width: 1),
                                          //shape: BoxShape.circle,
                                            borderRadius: BorderRadius.circular(5),
                                            image: new DecorationImage(
                                                fit: BoxFit.cover,
                                                image: new AssetImage("https://couponsgate.net/app-dash/"+_rCoupons[index].logo),
                                            )
                                        )),

                                    Container (
                                      //padding: const EdgeInsets.all(10.0),
                                      width: MediaQuery.of(context).size.width-95,
                                      child: new Column (
                                        children: <Widget>[
                                          Padding(padding: const EdgeInsets.all(5.0),
                                            child:Text(cPropertyByLocale(context, _rCoupons[index], 'name'),style: TextStyle(fontSize: 20,fontFamily: "CustomFont",fontWeight: FontWeight.bold),textAlign: TextAlign.center,),)

                                        ],
                                      ),
                                    )

                                  ]),
                              SizedBox(height: 15,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(onTap:(){ } , child: Container(
                                      width: 200,
                                      padding: const EdgeInsets.all(3),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        //border: Border.all(color: Colors.white),
                                        //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                        //borderRadius: BorderRadius.circular(5),
                                        //color: Colors.white
                                      ),
                                      child: DottedBorder(
                                        dashPattern: [8, 4],
                                        strokeWidth: 2,
                                        child: Container(
                                          //height: 50,
                                          //width: 300,
                                          //color: Colors.red,
                                          child: Text(
                                            _rCoupons[index].code,
                                            style: TextStyle(
                                              fontSize: 40,
                                              color: Color(0xFF2196f3),
                                              fontFamily: "CustomFont",
                                              fontWeight: FontWeight.bold,
                                            ),
                                            softWrap: true,
                                          ),
                                        ),
                                      )
                                  ),),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.copy,
                                        color: Colors.blue,
                                        size: 13,
                                      ),
                                      Text(
                                        getTranslated(context, 'home_coupon_code_used_prefix') +
                                            _rCoupons[index].copyCount + getTranslated(context, 'home_coupon_code_used_suffix'),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontFamily: "CustomFont",

                                        ),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        MyIcons.clock,
                                        color: Colors.blue,
                                        size: 13,
                                      ),
                                      Text(
                                        getTranslated(context, 'home_coupon_code_add_date') + _rCoupons[index].createdAt,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontFamily: "CustomFont",

                                        ),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 15,),
                              Padding(
                                  padding: const EdgeInsets.only(top:5,left: 10,right: 10,bottom: 5),
                                  child:Row(

                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    //verticalDirection: VerticalDirection.up,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [

                                      //shop now
                                      InkWell(onTap:(){ } , child: Container(
                                        width: MediaQuery.of(context).size.width-150,
                                        padding: const EdgeInsets.all(3),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.deepOrange),
                                            //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.deepOrange),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              MyIcons.copy,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                            Text(
                                              getTranslated(context, 'home_copy_code'),
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
                                            border: Border.all(color: Colors.white),
                                            //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.white),
                                        child: Icon(MyIcons.up_circled,color: Colors.green,),
                                      ),),
                                      InkWell(onTap:(){ } , child: Container(
                                        width: 50,
                                        padding: const EdgeInsets.all(3),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white),
                                            //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.white),
                                        child: Icon(MyIcons.down_circled,color: Colors.red,),
                                      ),),



                                    ],)),
                              Padding(
                                  padding: const EdgeInsets.only(top:5,left: 10,right: 10,bottom: 5),
                                  child:Row(

                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    //verticalDirection: VerticalDirection.up,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [

                                      //shop now
                                      InkWell(onTap:(){ } , child: Container(
                                        width: MediaQuery.of(context).size.width-150,
                                        padding: const EdgeInsets.all(3),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white),
                                            //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                            borderRadius: BorderRadius.circular(5),
                                            color: Color(0xFF2196f3)),
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
                                            border: Border.all(color: Colors.white),
                                            //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                            borderRadius: BorderRadius.circular(5),
                                            color: Color(0xFFffffff)),
                                        child: Icon(Icons.favorite_border,color: Color(0xFF2196f3),),
                                      ),),
                                      InkWell(onTap:(){ } , child: Container(
                                        width: 50,
                                        padding: const EdgeInsets.all(3),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white),
                                            //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                            borderRadius: BorderRadius.circular(5),
                                            color: Color(0xFFffffff)),
                                        child: Icon(Icons.share,color: Color(0xFF2196f3),),
                                      ),),


                                    ],))
                            ],)

                      );
                    },

                  ),
                ),
                Visibility(
                  visible: _isLoadMore,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      height: 50,
                      child: Center(
                        child: MaterialButton(
                          textColor: Colors.black54,
                          child: _loadMoreButtonChild(),
                          onPressed: () {
                            _loadMoreCoupons();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isCouponsEnd,
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Text(getTranslated(context, 'home_coupons_end_results'),style: TextStyle(fontFamily: 'CustomFont',color: Colors.black54,),),
                    ),
                  ),
                ),

              ]))),
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
