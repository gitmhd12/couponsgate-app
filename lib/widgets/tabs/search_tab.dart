import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/Code.dart';
import 'package:couponsgate/modules/Coupon.dart';
import 'package:couponsgate/modules/Favorite.dart';
import 'package:couponsgate/modules/HomeApiAssistant.dart';
import 'package:couponsgate/modules/Rating.dart';
import 'package:flutter/material.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../my_icons_icons.dart';
import '../NavDrawer.dart';
import '../login.dart';

class search_tab extends StatefulWidget {

  final String text;

  search_tab({this.text});

  @override
  _Search_tabState createState() => _Search_tabState();
}

class _Search_tabState extends State<search_tab> {
  final search_nameController = TextEditingController();

  bool is_loading = true;
  HomeApiAssistant homeApi = new HomeApiAssistant();

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


  Future _getCouponsByText() async
  {

    var ssResponse = await http
        .post('https://yalaphone.com/appdash/rest_api/coupons/coupons_search.php' , body: {
      'text' : search_nameController.text,

    });
    var ssData = json.decode(ssResponse.body);

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


      return _coupons;
    }
    catch(e)
    {

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
                      _launchStoreURL(_rCoupons[i].storeUrl);
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

  _initializeCouponsSection() async
  {
    await _getCouponsByText().then((value){
      setState(() {
        _rCoupons = List.from(value);




        _getCouponsRatings(_rCoupons).then((value){

          _getCouponsCodes(_rCoupons).then((value){
            setState(() {
              is_loading = false;
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
      is_loading = true;
      search_nameController.text = widget.text;
    });


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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFffffff),
    //drawer: NavDrawer(),
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(getTranslated(context, 'search_results')+widget.text,style: TextStyle(fontFamily: 'CustomFont',color: Colors.black),),
      ),
      body:SingleChildScrollView(
        //controller: _controller,
        child:Column(children: [

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
                        //textAlign: TextAlign.right,
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
                        onFieldSubmitted: (String str){
                          setState(() {
                            is_loading = true;
                            _rFavorites.clear();
                            _rRatings.clear();
                            _rCodes.clear();
                             _coupons.clear(); _extraCoupons.clear(); _rCoupons.clear();

                            _posRatings.clear(); _negRatings.clear(); _copyTimes.clear();
                          });


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
                          },


                      )),



                ])),

        is_loading ?
        Container(child: Center(child: GFLoader(
          type:GFLoaderType.circle,
          loaderColorOne: Color(0xFF2196f3),
          loaderColorTwo: Color(0xFF2196f3),
          loaderColorThree: Color(0xFF2196f3),
        ),),)
            :
         Column(
            children: <Widget>[
              for(int i = 0 ; i< _rCoupons.length ; i++) couponWidget(i),

            ],
          ),

      ],)),
    );
  }
}