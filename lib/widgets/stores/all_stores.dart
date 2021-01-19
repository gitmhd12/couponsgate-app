import 'dart:async';
import 'dart:io';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/HomeApiAssistant.dart';
import 'package:couponsgate/modules/Store.dart';
import 'package:couponsgate/widgets/stores/store_coupons.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../my_icons_icons.dart';
import '../countries.dart';
import '../favorites.dart';
import '../home.dart';
import '../settings.dart';


class AllStores extends StatefulWidget {
  @override
  _AllStores createState() => _AllStores();
}

class _AllStores extends State<AllStores> {

  HomeApiAssistant homeApi = new HomeApiAssistant();

  var is_loading = true;
  List<Store> _rStores = [];

  _initializeStoresSection() async
  {
    final prefs = await SharedPreferences.getInstance();
    final key = 'country_code';
    final value = prefs.get(key);

    if(value == null)
    {
      homeApi.getStores().then((value){
        setState(() {
          _rStores = List.from(value);
          is_loading = false;
        });
      });
    }
    else
    {
      homeApi.getStoresByCountry(value).then((value){
        setState(() {
          _rStores = List.from(value);
          is_loading = false;
        });
      });
    }
  }

  String storeName(context , Store store)
  {
    Locale currentLocale = Localizations.localeOf(context);

    if(currentLocale.languageCode == 'ar')
    {
      return store.arName;
    }
    else
    {
      return store.enName;
    }

  }

  @override
  void initState() {
    super.initState();
    _initializeStoresSection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color(0xFF2f3640),
        elevation: 0,
        centerTitle: true,
        title: Text(getTranslated(context, 'home_stores_title')),
      ),
      body: is_loading ? Container(child: Center(child: GFLoader(
        type:GFLoaderType.circle,
        loaderColorOne: Color(0xFF2196f3),
        loaderColorTwo: Color(0xFF2196f3),
        loaderColorThree: Color(0xFF2196f3),
      ),),):SingleChildScrollView(
          child:
           ResponsiveGridRow(
                children: [

                  for (var i = 0; i < _rStores.length; i++)
                    ResponsiveGridCol(
                      xs: 6,
                      md: 4,
                      child: Container(
                          margin: const EdgeInsets.all(10.0),
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          height: MediaQuery.of(context).size.width/3 + 50,
                          alignment: Alignment(0, 0),
                          //color: Colors.grey,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                      new StoryCoupon(
                                        country: _rStores[i],
                                      )));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FittedBox(
                                  child: Container(
                                      width: 100,
                                      height: 100,
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.all(5),
                                      decoration: new BoxDecoration(
                                          border: Border.all(color: Colors.grey,width: 1),
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage("https://yalaphone.com/appdash/"+_rStores[i].logo),
                                          )
                                      )),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                FittedBox(
                                  child: Text(
                                    storeName(context, _rStores[i]),
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),

                ])
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