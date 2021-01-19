import 'dart:convert';
import 'package:couponsgate/widgets/coupon_main.dart';
import 'package:couponsgate/widgets/settings.dart';
import 'package:couponsgate/widgets/stores/all_stores.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:http/http.dart' as http;
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/ApiAssistant.dart';
import 'package:couponsgate/modules/Coupon.dart';
import 'package:couponsgate/modules/Favorite.dart';
import 'package:couponsgate/widgets/home.dart';
import 'package:couponsgate/widgets/login.dart';
import 'package:couponsgate/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'countries.dart';
import 'my_icons_icons.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

  List<Favorite> _favorites, _rFavorites = [];
  String _token;
  bool _isGuest = false;
  bool _noResults = true;
  bool _isFavLoading;


  Future _getUserFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    //print('$value');
    if (value == '1')
    {
      final key2 = 'token';
      final value2 = prefs.get(key2);

      setState(() {
        _isGuest = false;
        _token = value2;
      });

      var data = {
        'user_token': _token,
      };

      Favorite tFav;
      _favorites = [];

      var res = await http.post('https://yalaphone.com/appdash/rest_api/favorites/get_favs_by_user.php',
          body: data);
      var body = json.decode(res.body);
      //print(body);

      if (body['favorites'] != null) {
        for (var fav in body['favorites']) {
          tFav = Favorite.fromJson(fav);
          _favorites.add(tFav);
        }

        setState(() {
          _noResults = false;
        });

        return _favorites;
      }
      else
      {
        setState(() {
          _noResults = true;
        });
      }
    }
    else
    {
      setState(() {
        _isGuest = true;
      });
    }
  }

  _deleteFavorite(String fid) async {
    var data = {
      'id': fid,
      'user_token': _token,
    };

    var res = await http.post('https://yalaphone.com/appdash/rest_api/favorites/remove_fav.php',
      body: data);
    var body = json.decode(res.body);
    //print(body);

    if (body['success'] == 1) {
      _getUserFavorites().then((value) {
        setState(() {
          try{
            _rFavorites = List.from(value);
          }catch(e){
            _rFavorites = [];
          }
        });
      });
    }
  }

  String cPropertyByLocale(context , Favorite favorite)
  {
    Locale currentLocale = Localizations.localeOf(context);

    if(currentLocale.languageCode == 'ar')
    {
        return favorite.couponArName;
    }
    else
    {
        return favorite.couponEnName;
    }

  }


  @override
  void initState() {

    super.initState();

    setState(() {
      _isFavLoading = true;
    });
    _getUserFavorites().then((value) {
      setState(() {
        try{
          _rFavorites = List.from(value);
        }catch(e){
          _rFavorites = [];
        }
        _isFavLoading = false;
      });
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color(0xFF2f3640),
        elevation: 0,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(getTranslated(context, 'favorites_title'),
          style: TextStyle(fontFamily: 'CustomFont',color: Colors.black),),
      ),
      body: _isGuest ?
      InkWell(

        borderRadius: BorderRadius.circular(5),
        onTap: () {},
        child: Card(


          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.only(top:10.0),
          //color: Colors.grey,
          elevation: 0,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  getTranslated(context, 'favorites_sign_in_note'),
                                  style: TextStyle(
                                    fontFamily: 'CustomFont', fontSize: 20
                                  ),textAlign: TextAlign.center,
                                ),
                              ),


        SizedBox(height: 30,),
        InkWell(onTap: () {
        Navigator.pushReplacementNamed(
        context, '/login');
        } , child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(7),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
              borderRadius: BorderRadius.circular(5),
              color: Color(0xFF2196f3)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Text(
                getTranslated(context, 'favorites_sign_in_btn'),
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontFamily: "CustomFont",
                ),
              ),
            ],
          ),
        ),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          :
          Container(
            child: _isFavLoading ?
            Container(
              child: Center(child: GFLoader(
                type:GFLoaderType.circle,
                loaderColorOne: Color(0xFF2196f3),
                loaderColorTwo: Color(0xFF2196f3),
                loaderColorThree: Color(0xFF2196f3),
              ),),
            )
            :
            Container(child: _noResults ?
            InkWell(

              borderRadius: BorderRadius.circular(5),
              onTap: () {},
              child: Card(

                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.only(top:10.0),
                elevation: 0,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    getTranslated(context, 'favorites_no_result_note'),
                                    style: TextStyle(
                                      fontFamily: 'CustomFont',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
                :
                Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _rFavorites.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: (){
                            Navigator.of(context).push(
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                    new CouponMain(
                                      id: _rFavorites[index].couponId,
                                    )));
                          },
                          title: Text(
                            cPropertyByLocale(context, _rFavorites[index]),
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'CustomFont'
                              //fontWeight: FontWeight.bold,
                            ),
                          ),

                          trailing: IconButton(icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: (){
                              showDialog(
                                  context: context,
                                  builder: (_) => AssetGiffyDialog(
                                    onlyOkButton: false,
                                    buttonCancelText: Text(getTranslated(context, 'login_alert_d_cancel'),
                                        style: TextStyle(fontFamily: "CustomFont", fontSize: 16)),
                                    buttonOkText: Text(getTranslated(context, 'favorites_alert_del_btn'),
                                        style: TextStyle(
                                            fontFamily: "CustomFont",
                                            fontSize: 16,
                                            color: Colors.white)),
                                    buttonOkColor: Colors.redAccent,
                                    image: Image.asset('assets/images/alert.png', fit: BoxFit.cover),
                                    title: Text(
                                      getTranslated(context, 'favorites_alert_del_title'),
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: "CustomFont",
                                          color: Colors.redAccent),
                                    ),
                                    description: Text(
                                      getTranslated(context, 'favorites_alert_del_content'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: "CustomFont", fontSize: 16),
                                    ),
                                    onOkButtonPressed: () {
                                      setState(() {
                                        _deleteFavorite(_rFavorites[index].id);

                                        _getUserFavorites().then((value) {
                                          setState(() {
                                            try{
                                              _rFavorites = List.from(value);
                                            }catch(e){
                                              _rFavorites = [];
                                            }
                                            _isFavLoading = false;
                                          });
                                        });

                                      });

                                      Navigator.pop(context);
                                    },
                                    onCancelButtonPressed: (){
                                      Navigator.pop(context);
                                    },
                                  ));
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
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
            initialActiveIndex: 3,//optional, default as 0
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
      /*Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Favorites()));*/
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
