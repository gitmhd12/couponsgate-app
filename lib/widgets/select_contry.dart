import 'dart:convert';

import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/Country.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Select_Country extends StatefulWidget {
  @override
  _Select_Country_State createState() => _Select_Country_State();
}

class _Select_Country_State extends State<Select_Country> {
  bool _isLoading = false;
  List<Country> _countries , _rCountries = [];
  String _countryBtnHint = '+';
  String _countryID;

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

  void changeCountry(context , Country country) {
    setState(() {
      _countryBtnHint = countryName(context , country);
      _countryID = country.id;
    });
  }

  void _showCountriesDialog(context, List<Country> countries) {



    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            elevation: 16,
            child: StatefulBuilder(builder: (context, setState) {
              return _isLoading ? Container(child: Center(child: CircularProgressIndicator(),),) : Container(
                height: countries.length <= 4
                    ? MediaQuery.of(context).size.height * 0.1 * countries.length
                    : MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          getTranslated(context, 'login_country_btn'),
                          style: TextStyle(
                            fontFamily: 'CustomFont',
                            fontSize: 20.0,
                            color: Color(0xff275879),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        thickness: 1.0,
                        color: Colors.black54,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: countries.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                countryName(context, countries[index]),
                              ),
                              onTap: () {
                                changeCountry(context, countries[index]);
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Center(
            child:Column(children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _isLoading = true;
                  });

                  _getCountries().then((value) {
                    setState(() {
                      _rCountries = List.from(value);
                      _isLoading = false;
                      _showCountriesDialog(context, _rCountries);
                    });
                  });

                  setState(() {
                  });
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width/2,
                  padding: const EdgeInsets.all(5.0),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.grey,
                  ),
                  child: Text(
                    _countryBtnHint = getTranslated(context, 'login_country_btn'),
                    style: TextStyle(fontSize: 18, color: Colors.white,fontFamily: "CustomFont"),
                  ),
                ),
              ),
            ],)

          )



    );
  }
}