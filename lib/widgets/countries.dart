import 'dart:convert';
import 'package:couponsgate/modules/Country.dart';
import 'package:couponsgate/widgets/country_coupons.dart';
import 'package:couponsgate/widgets/favorites.dart';
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
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_icons_icons.dart';

class Countries extends StatefulWidget {
  @override
  _CountriesState createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {

  List<Country> _countries , _rCountries = [];
  bool _isCountriesLoading;

  Future _getCountries() async
  {
    var csResponse = await http
        .get('https://yalaphone.com/appdash/rest_api/countries/getAllCountries.php');
    var csData = json.decode(csResponse.body);
    Country tCountry;
    _countries = [];

    for (var ques in csData['countries']) {
      tCountry = Country.fromJson(ques);
      print(tCountry.id);

      _countries.add(tCountry);
      //print('depart length is : ' + departs.length.toString());
    }

    return _countries;
  }


  String countryName(context , Country country)
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


  @override
  void initState() {

    super.initState();


    setState(() {
      _isCountriesLoading = true;
    });
    _getCountries().then((value) {
      setState(() {
        try{
          _rCountries = List.from(value);
        }catch(e){
          _rCountries = [];
        }
        _isCountriesLoading = false;
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
        elevation: 0,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(getTranslated(context, 'countries_title'),
          style: TextStyle(fontFamily: 'CustomFont',color: Colors.black),),
      ),
      body: _isCountriesLoading ?
          Container(child: Center(child: GFLoader(
            type:GFLoaderType.circle,
            loaderColorOne: Color(0xFF2196f3),
            loaderColorTwo: Color(0xFF2196f3),
            loaderColorThree: Color(0xFF2196f3),
          ),),)
          :
      SingleChildScrollView(
        child: ResponsiveGridRow(
          children: [
            for (var i = 0; i < _rCountries.length; i++)
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
                                new CountryCoupons(
                                  country: _rCountries[i],
                                )));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Container(
                              height: MediaQuery.of(context).size.width/3 ,
                              width: MediaQuery.of(context).size.width/2 - 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://yalaphone.com/appdash/' +
                                            _rCountries[i].flag),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FittedBox(
                            child: Text(
                              countryName(context, _rCountries[i]),
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
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
            initialActiveIndex: 0,//optional, default as 0
            onTap: onTabTapped,
          )),
    );
  }

  void onTabTapped(int index) {
    if (index == 0) {
      /*Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Countries()),*/
      //);
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
