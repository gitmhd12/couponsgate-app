import 'dart:convert';

import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/Country.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Select_Country extends StatefulWidget {
  @override
  _Select_Country_State createState() => _Select_Country_State();
}

class _Select_Country_State extends State<Select_Country> {
  bool _isLoading = false;
  bool _sendLoading = false;
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

  Future _updateCountries(String user_id, String country_id) async
  {
    int success = 0;

    String myUrl = "https://yalaphone.com/appdash/rest_api/countries/update_user_country.php";
    http.Response response = await http.post(myUrl, body: {
      'user_id': user_id,
      'country_id': country_id,
    });

    print(response.body.toString());

    if(response.body.toString().trim() == 'success')
      {
        success = 1;
      }



    return success;
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

  @override
  void initState() {
    super.initState();

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
      body:Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/text_logo.png",width: MediaQuery.of(context).size.width/1.7),
                SizedBox(height: 50,),
                Text(getTranslated(context, 'login_country_btn'),style: TextStyle(fontSize: 20,fontFamily: "CustomFont"),),
                SizedBox(height: 10,),

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
                    _isLoading = false;
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
                  child: _isLoading?CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xffffffff),),
                  ): Text(
                    _countryBtnHint,
                    style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "CustomFont"),
                  ),
                ),
              ),
                SizedBox(height: 10,),
                InkWell(
                  onTap: () async {
                          if(_countryID == null)
                            {
                              print('country id is null');
                              var snackBar = SnackBar(content: Text(getTranslated(context, 'login_country_btn')));
                              Scaffold.of(context).showSnackBar(snackBar);
                            }else{
                            //get user id
                            print('get user id ');
                            final prefs = await SharedPreferences.getInstance();
                            final key = 'user_id';
                            final user_id = prefs.get(key);

                            //check if user id is not null
                            if(user_id == null)
                            {print('user id is null');}else{
                              //show loading
                              setState(() {
                                _sendLoading = true;
                              });

                              //send data to update user country
                              _updateCountries(user_id,_countryID).then((value) {
                                print('send data');
                                print('value is $value');
                                if(value == 1){
                                  Navigator.pushReplacementNamed(context, '/home');
                                }
                              });

                              //hide loading
                              setState(() {
                                _sendLoading = false;
                              });

                            }
                          }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width/2,
                    padding: const EdgeInsets.all(5.0),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      //color: Colors.grey,
                    ),
                    child: _sendLoading?CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue,),
                    ):  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.blue,
                    size: 35,
                    ),
                  ),
                ),
            ],)

          ),




    );
  }
}