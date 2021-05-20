import 'dart:convert';

import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/ApiAssistant.dart';
import 'package:couponsgate/modules/Country.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Select_Country extends StatefulWidget {
  @override
  _Select_Country_State createState() => _Select_Country_State();
}

class _Select_Country_State extends State<Select_Country> {

  ApiAssistant api = new ApiAssistant();

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
      //print(tCountry.id);

      _countries.add(tCountry);
      //print('depart length is : ' + departs.length.toString());
    }

    return _countries;
  }

  Future _updateCountries(String user_id, String country_id) async
  {
    print ('country id $country_id');
    print ('user id $user_id');
    int success = 0;

    String myUrl = "https://yalaphone.com/appdash/rest_api/countries/update_user_country.php";
    http.Response response = await http.post(myUrl, body: {
      'user_id': user_id,
      'country_id': country_id,
    });

    print(response.body.toString());

    if(response.body.toString().trim() == 'success')
      {
        final prefs = await SharedPreferences.getInstance();
        final key6 = 'country_code';
        final value6 = country_id;
        prefs.setString(key6, value6);

        success = 1;
      }else{
      success = 0;
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

   // _countryBtnHint = getTranslated(context, 'login_country_btn');
  }

  /*void _showCountriesDialog(context, List<Country> countries) {



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
  }*/

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
                              trailing: FittedBox(
                                child: Container(
                                  height: MediaQuery.of(context).size.width*0.1 ,
                                  width: MediaQuery.of(context).size.width*0.15,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            'https://yalaphone.com/appdash/' +
                                                countries[index].flag),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                ),
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
                SizedBox(height: 50,),
                InkWell(
                  onTap: () async {
                    //show loading


                          if(_countryID == null)
                            {
                              print('country id is null');
                              Fluttertoast.showToast(
                                  msg: getTranslated(context, 'login_country_btn'),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );

                            }
                          else
                            {
                              setState(() {
                                _sendLoading = true;
                              });

                              Locale currentLocale = Localizations.localeOf(context);
                            //get user id
                            print('get user id ');
                            final prefs = await SharedPreferences.getInstance();
                            final key = 'user_id';
                            final UserId = prefs.get(key);

                            final key2 = 'isFirstSkip';
                            final firstSkip = prefs.get(key2);

                              print('user id $UserId');

                            //check if user id is not null
                            if(UserId == null)
                            {
                              print('user id is null');

                                  prefs.setString('country_code' , _countryID);
                                  prefs.setString(key2 , '1');

                                  api.subscribeAnonymousUser(currentLocale.languageCode).whenComplete((){
                                    Navigator.pushReplacementNamed(context, '/home');
                                    setState(() {
                                      _sendLoading = false;
                                    });
                                  });



                            }
                            else
                              {


                              //send data to update user country
                              _updateCountries(UserId,_countryID).then((value) {
                                print('send data');
                                print('value is $value');
                                if(value == 1){

                                  api.updateFirebaseToken(currentLocale.languageCode).whenComplete((){
                                    if(api.firebaseStatus)
                                    {
                                      Navigator.pushReplacementNamed(context, '/home');
                                    }
                                    setState(() {
                                      _sendLoading = false;
                                    });
                                  }
                                  );
                                }


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
                      color: Color(0xff275879),
                    ),
                    child: _sendLoading?CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue,),
                    ):  Text(
                      getTranslated(context, 'next_btn'),
                    style: TextStyle(color: Colors.white,fontSize: 24),
                    ),
                  ),
                ),
            ],)

          ),




    );
  }
}