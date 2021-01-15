import 'dart:convert';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:couponsgate/modules/Code.dart';
import 'package:couponsgate/modules/Country.dart';
import 'package:couponsgate/modules/HomeApiAssistant.dart';
import 'package:couponsgate/modules/Rating.dart';
import 'package:couponsgate/modules/Store.dart';
import 'package:couponsgate/widgets/countries.dart';
import 'package:couponsgate/widgets/favorites.dart';
import 'package:couponsgate/widgets/login.dart';
import 'package:couponsgate/widgets/settings.dart';
import 'package:couponsgate/widgets/stores/all_stores.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:http/http.dart' as http;
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/Coupon.dart';
import 'package:couponsgate/modules/Favorite.dart';
import 'package:couponsgate/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../my_icons_icons.dart';

class StoryCoupon extends StatefulWidget {
  final Store country;

  StoryCoupon({this.country});

  @override
  _StoryCouponsState createState() => _StoryCouponsState();
}

class _StoryCouponsState extends State<StoryCoupon> {

  HomeApiAssistant homeApi = new HomeApiAssistant();

  bool _isCouponsLoading;
  var _isLoadMore = false;
  var _isCouponsEnd = false;
  String _currentCoupon = '0';
  int loadModeChildIndicator = 0;
  var _controller = ScrollController();

  List<Coupon> _coupons , _extraCoupons = [] , _rCoupons = [];
  List<Favorite> _rFavorites = [];
  List<Rating> _rRatings = [];
  List<Code> _rCodes = [];
  List<String> _posRatings = [], _negRatings = [] , _copyTimes = [];

  /// Favorites System
  ///-----------------------------------------------------------------
  String _checkIfInFavs(String cid, List<Favorite> favsCoupons) {
    try {
      for (Favorite fav in favsCoupons) if (cid == fav.couponId) return fav.id;
    } catch (e) {
      return null;
    }
  }

  _addFavorite(String cid) async {

    homeApi.addFavorite(cid).then((value){

      if (value) {
        homeApi.getUserFavorites().then((value) {
          setState(() {
            _rFavorites = List.from(value);
          });
        });
      } else {

        showDialog(
            context: context,
            builder: (_) => AssetGiffyDialog(
              onlyOkButton: false,
              buttonCancelText: Text(getTranslated(context, 'login_alert_d_cancel'),
                  style: TextStyle(fontFamily: "CustomFont", fontSize: 16)),
              buttonOkText: Text(getTranslated(context, 'home_alert_login_ok_btn'),
                  style: TextStyle(
                      fontFamily: "CustomFont",
                      fontSize: 16,
                      color: Colors.white)),
              buttonOkColor: Colors.redAccent,
              image: Image.asset('assets/images/alert.png', fit: BoxFit.cover),
              title: Text(
                getTranslated(context, 'home_alert_login_title'),
                style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "CustomFont",
                    color: Colors.redAccent),
              ),
              description: Text(
                getTranslated(context, 'home_alert_f_login_content'),
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "CustomFont", fontSize: 16),
              ),
              onOkButtonPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Login()),
                      (Route<dynamic> route) => false,
                );
              },
              onCancelButtonPressed: (){
                Navigator.pop(context);
              },
            ));

      }
    });

  }

  _deleteFavorite(String fid) async {

    homeApi.deleteFavorite(fid).then((value){
      if(value)
      {
        homeApi.getUserFavorites().then((value) {
          setState(() {
            try{
              _rFavorites = List.from(value);
            }catch(e){
              _rFavorites = [];
            }

          });
        });
      }
    });


  }



  /// Ratings System
  ///-----------------------------------------------------------------

  Future _getCouponsRatings(List<Coupon> coupons) async
  {
    _posRatings.length = coupons.length;
    _negRatings.length = coupons.length;

    for(int i =0 ; i < coupons.length ; i++)
    {
      homeApi.getCouponPosRatings(coupons[i].id).then((value){
        setState(() {
          _posRatings[i] = value;
        });
      });

      homeApi.getCouponNegRatings(coupons[i].id).then((value){
        setState(() {
          _negRatings[i] = value;
        });
      });
    }
  }

  _addRating(String cid , String type) async {

    homeApi.addRating(cid , type).then((value){

      if (value) {
        setState(() {
          _getCouponsRatings(_rCoupons);
        });

        homeApi.getUserRatings().then((value) {
          setState(() {
            try{
              _rRatings = List.from(value);
            }catch(e){
              _rRatings = [];
            }
          });
        });

      } else {

        showDialog(
            context: context,
            builder: (_) => AssetGiffyDialog(
              onlyOkButton: false,
              buttonCancelText: Text(getTranslated(context, 'login_alert_d_cancel'),
                  style: TextStyle(fontFamily: "CustomFont", fontSize: 16)),
              buttonOkText: Text(getTranslated(context, 'home_alert_login_ok_btn'),
                  style: TextStyle(
                      fontFamily: "CustomFont",
                      fontSize: 16,
                      color: Colors.white)),
              buttonOkColor: Colors.redAccent,
              image: Image.asset('assets/images/alert.png', fit: BoxFit.cover),
              title: Text(
                getTranslated(context, 'home_alert_login_title'),
                style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "CustomFont",
                    color: Colors.redAccent),
              ),
              description: Text(
                getTranslated(context, 'home_alert_r_login_content'),
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "CustomFont", fontSize: 16),
              ),
              onOkButtonPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Login()),
                      (Route<dynamic> route) => false,
                );
              },
              onCancelButtonPressed: (){
                Navigator.pop(context);
              },
            ));

      }
    });

  }

  _deleteRating(String fid) async {

    homeApi.deleteRating(fid).then((value){
      if(value)
      {
        homeApi.getUserFavorites().then((value) {
          setState(() {
            _getCouponsRatings(_rCoupons);
          });
        });

        homeApi.getUserRatings().then((value) {
          setState(() {
            try{
              _rRatings = List.from(value);
            }catch(e){
              _rRatings = [];
            }
          });
        });
      }
    });


  }

  _handlePositiveButton(String cid , List<Rating> ratings)
  {
    if(homeApi.checkIfInRatings(cid, ratings , 'pos') == null
        && homeApi.checkIfInRatings(cid, ratings , 'neg') == null)
      _addRating(cid, 'pos');
    else if(homeApi.checkIfInRatings(cid, ratings , 'pos') != null
        && homeApi.checkIfInRatings(cid, ratings , 'neg') == null)
      _deleteRating(homeApi.checkIfInRatings(cid, ratings , 'pos'));
    else if(homeApi.checkIfInRatings(cid, ratings , 'pos') == null
        && homeApi.checkIfInRatings(cid, ratings , 'neg') != null)
    {
      // Do nothing
    }
  }

  _handleNegativeButton(String cid , List<Rating> ratings)
  {
    if(homeApi.checkIfInRatings(cid, ratings , 'pos') == null
        && homeApi.checkIfInRatings(cid, ratings , 'neg') == null)
      _addRating(cid, 'neg');
    else if(homeApi.checkIfInRatings(cid, ratings , 'neg') != null
        && homeApi.checkIfInRatings(cid, ratings , 'pos') == null)
      _deleteRating(homeApi.checkIfInRatings(cid, ratings , 'neg'));
    else if(homeApi.checkIfInRatings(cid, ratings , 'neg') == null
        && homeApi.checkIfInRatings(cid, ratings , 'pos') != null)
    {
      // Do nothing
    }
  }

  /// Coupons Code System
  ///-----------------------------------------------------------------

  Future _getCouponsCodes(List<Coupon> coupons) async
  {
    _copyTimes.length = coupons.length;

    for(int i =0 ; i < coupons.length ; i++)
    {
      homeApi.getCouponCopyTimes(coupons[i].id).then((value){
        setState(() {
          _copyTimes[i] = value;
        });
      });
    }
  }

  _copyCode(String cid , String code) async {

    homeApi.copyCode(cid).then((value){

      if (value) {

        ClipboardManager.copyToClipBoard(
            code)
            .then((result) {
          final snackBar = SnackBar(
            content: Text('Copied ' + code),
          );
          setState(() {
            Scaffold.of(context).showSnackBar(snackBar);
          });

        });

        setState(() {
          _getCouponsCodes(_rCoupons);
        });

        homeApi.getUserCodes().then((value) {
          setState(() {
            try{
              _rCodes = List.from(value);
            }catch(e){
              _rCodes = [];
            }
          });
        });

      } else {

        showDialog(
            context: context,
            builder: (_) => AssetGiffyDialog(
              onlyOkButton: false,
              buttonCancelText: Text(getTranslated(context, 'login_alert_d_cancel'),
                  style: TextStyle(fontFamily: "CustomFont", fontSize: 16)),
              buttonOkText: Text(getTranslated(context, 'home_alert_login_ok_btn'),
                  style: TextStyle(
                      fontFamily: "CustomFont",
                      fontSize: 16,
                      color: Colors.white)),
              buttonOkColor: Colors.redAccent,
              image: Image.asset('assets/images/alert.png', fit: BoxFit.cover),
              title: Text(
                getTranslated(context, 'home_alert_login_title'),
                style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "CustomFont",
                    color: Colors.redAccent),
              ),
              description: Text(
                getTranslated(context, 'home_alert_c_login_content'),
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "CustomFont", fontSize: 16),
              ),
              onOkButtonPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Login()),
                      (Route<dynamic> route) => false,
                );
              },
              onCancelButtonPressed: (){
                Navigator.pop(context);
              },
            ));

      }
    });

  }

  /// Coupons System
  ///-----------------------------------------------------------------

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
  _loadMoreCoupons() async
  {
    _getCouponsByCountry().then((value){
      setState(() {
        _extraCoupons = List.from(value);

        if(_extraCoupons.length > 0)
        {
          for(var coupon in _extraCoupons)
          {
            _rCoupons.add(coupon);
          }
          _currentCoupon = _rCoupons.first.id;
          //print('>>$_currentCoupon');

          _getCouponsRatings(_rCoupons).then((value){
            setState(() {
              _isCouponsLoading = false;
              _isLoadMore = true;
            });
          });

        }

        loadModeChildIndicator = 0;
      });
    });
  }

  Future _getCouponsByCountry() async
  {

    var ssResponse = await http
        .post('https://yalaphone.com/appdash/rest_api/coupons/coupons_lazy_load_by_store.php' , body: {
      'country' : widget.country.id,
      'current_id' : _currentCoupon,
    });
    var ssData = json.decode(ssResponse.body);
    print(widget.country.id.toString());
    print(ssData.toString());
    Coupon tCoupon;
    _coupons = [];

    try
    {
      for (var ques in ssData['coupons']) {
        tCoupon = Coupon.fromJson(ques);
        //(tCoupon.id);

        setState(() {
          _coupons.add(tCoupon);
        });
        //print('depart length is : ' + departs.length.toString());
      }
      if(_coupons.length > 0)
        setState(() {
          _isLoadMore = true;
        });
      else
        setState(() {
          _isLoadMore = false;
        });

      return _coupons;
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

  String countryName(context , Store country)
  {
    Locale currentLocale = Localizations.localeOf(context);

    if(currentLocale.languageCode == 'ar')
    {
      return country.arName;
    }
    else
    {
      return country.enName;
    }

  }

  _launchStoreURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  couponWidget(int i)
  {
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
                            image: NetworkImage("https://yalaphone.com/appdash/"+_rCoupons[i].logo),
                          )
                      )),

                  Container (
                    //padding: const EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width-95,
                    child: new Column (
                      children: <Widget>[
                        Padding(padding: const EdgeInsets.all(5.0),
                          child:Text(cPropertyByLocale(context, _rCoupons[i], 'name'),style: TextStyle(fontSize: 20,fontFamily: "CustomFont",fontWeight: FontWeight.bold),textAlign: TextAlign.center,),)

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
                        child: FittedBox(
                          child: Text(
                            ' '+_rCoupons[i].code+' ',
                            style: TextStyle(
                              fontSize: 40,
                              color: Color(0xFF2196f3),
                              fontFamily: "CustomFont",
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ),
                    )
                ),),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(flex: 30, child: Container(),),
                    Expanded(
                      flex: 70,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.copy,
                                color: Colors.blue,
                                size: 13,
                              ),
                              Text(
                                getTranslated(context, 'home_coupon_code_used_prefix') +
                                    _copyTimes[i].toString() + getTranslated(context, 'home_coupon_code_used_suffix'),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                MyIcons.clock,
                                color: Colors.blue,
                                size: 13,
                              ),
                              Text(
                                getTranslated(context, 'home_coupon_code_add_date') + _rCoupons[i].createdAt.toString(),
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
                    ),
                    //Expanded(flex: 30, child: Container(),)
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
                    Column(
                      children: [
                        InkWell(onTap:(){
                          ClipboardManager.copyToClipBoard(
                              _rCoupons[i].code)
                              .then((result) {
                            final snackBar = SnackBar(
                              content: Text(getTranslated(context, 'Copied') + _rCoupons[i].code),
                            );
                            setState(() {
                              Scaffold.of(context).showSnackBar(snackBar);
                            });

                          });

                          if(homeApi.checkIfInCodes(_rCoupons[i].id, _rCodes) == null)
                            _copyCode(_rCoupons[i].id , _rCoupons[i].code);
                        } , child: Container(
                          width: MediaQuery.of(context).size.width-150,
                          padding: const EdgeInsets.all(3),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
                              //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.green),
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
                        Text(' ',style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: "CustomFont",

                        ),),
                      ],
                    ),

                    //favorite
                    Column(
                      children: [
                        InkWell(
                          onTap:(){
                            _handlePositiveButton(_rCoupons[i].id, _rRatings);
                          } , child: Container(
                          width: 50,
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            //border: Border.all(color: Colors.white),
                            //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                              borderRadius: BorderRadius.circular(5),
                              color: homeApi.checkIfInRatings(_rCoupons[i].id, _rRatings , 'pos') == null ? Colors.white : Color(0xffdff9fb)),
                          child: Icon(MyIcons.up_circled,color: Colors.green,),
                        ),),
                        Text(_posRatings[i] ?? '0',style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: "CustomFont",

                        ),),
                      ],
                    ),

                    Column(
                      children: [
                        InkWell(onTap:(){
                          _handleNegativeButton(_rCoupons[i].id, _rRatings);
                        } , child: Container(
                          width: 50,
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            //border: Border.all(color: Colors.white),
                            //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                              borderRadius: BorderRadius.circular(5),
                              color: homeApi.checkIfInRatings(_rCoupons[i].id, _rRatings , 'neg') == null ? Colors.white : Color(0xffdff9fb)),
                          child: Icon(MyIcons.down_circled,color: Colors.red,),
                        ),),
                        Text(_negRatings[i] ?? '0',style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: "CustomFont",

                        ),),
                      ],
                    ),



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
                    InkWell(onTap:(){
                      _launchStoreURL(_rCoupons[i].storeUrl).whenComplete(() {
                        homeApi.visitStore(_rCoupons[i].store);
                      });
                    } , child: Container(
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
                    _checkIfInFavs(_rCoupons[i].id, _rFavorites) == null ?
                    InkWell(
                      onTap:(){
                        _addFavorite(_rCoupons[i].id);
                      } , child: Container(
                      width: 50,
                      padding: const EdgeInsets.all(3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xFFffffff)),
                      child: Icon(Icons.favorite_border,color: Color(0xFF2196f3),),
                    ),)
                        :
                    InkWell(
                      onTap:(){
                        _deleteFavorite(_checkIfInFavs(_rCoupons[i].id, _rFavorites));
                      } , child: Container(
                      width: 50,
                      padding: const EdgeInsets.all(3),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xFFffffff)),
                      child: Icon(Icons.favorite,color: Colors.red,),
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
        //_isLoadMore = false;
        //_isCouponsEnd = false;
      });
  }

  _initializeCouponsSection() async
  {
    await _getCouponsByCountry().then((value){
      setState(() {
        _rCoupons = List.from(value);

        try{
          setState(() {
            _currentCoupon = _rCoupons.first.id;
          });

        }catch(e){
          setState(() {
            _currentCoupon = '0';
          });
        }
        print('last coupon>>$_currentCoupon');

        _getCouponsRatings(_rCoupons).then((value){

          _getCouponsCodes(_rCoupons).then((value){
            setState(() {
              _isCouponsLoading = false;
            });
          });

        });

      });
    });
  }

  @override
  void initState() {

    super.initState();

    setState(() {
      _isCouponsLoading = true;
      _currentCoupon = '0';
    });

    _controller.addListener(_listener);

    homeApi.getUserFavorites().then((value) {
      setState(() {
        try{
          _rFavorites = List.from(value);
        }catch(e){
          _rFavorites = [];
        }
      });
    });

    homeApi.getUserRatings().then((value) {
      setState(() {
        try{
          _rRatings = List.from(value);
        }catch(e){
          _rRatings = [];
        }
      });
    });

    homeApi.getUserCodes().then((value) {
      setState(() {
        try{
          _rCodes = List.from(value);
        }catch(e){
          _rCodes = [];
        }
      });
    });

    _initializeCouponsSection();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(getTranslated(context, 'countries_coupons_title') + countryName(context, widget.country),
          style: TextStyle(fontFamily: 'CustomFont',color: Colors.black),),
      ),
      body: _isCouponsLoading ?
      Container(child: Center(child: GFLoader(
        type:GFLoaderType.circle,
        loaderColorOne: Color(0xFF2196f3),
        loaderColorTwo: Color(0xFF2196f3),
        loaderColorThree: Color(0xFF2196f3),
      ),),)
          :
      SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: <Widget>[
            for(int i = 0 ; i< _rCoupons.length ; i++) couponWidget(i),
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
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  height: 50,
                  child: Center(
                    child: Text(getTranslated(context, 'home_coupons_end_results'),style: TextStyle(fontFamily: 'CustomFont',color: Colors.black54,),),
                  ),
                ),
              ),
            ),
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
              TabItem(icon: Icons.home, title: getTranslated(context, 'home_b_bar_home')),
              TabItem(icon: Icons.favorite, title: getTranslated(context, 'home_b_bar_fav')),
              TabItem(icon: Icons.people, title: getTranslated(context, 'home_b_bar_profile')),
            ],
            initialActiveIndex: 1,//optional, default as 0
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
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Home()));
    } else if (index == 3) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Favorites()));
    } else if (index == 4) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Settings()));
    }
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
