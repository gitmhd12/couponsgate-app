import 'dart:convert';

import 'package:couponsgate/localization/localizationValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;

class Terms extends StatefulWidget {
  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {

  Map<String, dynamic> ar_list;
  Map<String, dynamic> en_list;
  String about;
  bool isLoading = true;

  Future<List> _getdata() async {
    var statisticsResponse;



    statisticsResponse = await http.get('https://yalaphone.com/appdash/rest_api/pages/pages.php');
    var responce = json.decode(statisticsResponse.body);
    setState(() {
      ar_list = responce;

      print(ar_list.length.toString());

    });

    statisticsResponse = await http.get('https://yalaphone.com/appdash/rest_api/pages/en_pages.php');
    responce = json.decode(statisticsResponse.body);
    setState(() {
      en_list = responce;
      isLoading = false;
      print(en_list.length.toString());

    });

  }

  name_lang(context){
    Locale currentLocale = Localizations.localeOf(context);

    if(currentLocale.languageCode == 'ar')
    {
      about = ar_list["pages"][0]["tirm"].toString();
    }
    else
    {
      about = en_list["pages"][0]["tirm"].toString();
    }
  }

  @override
  void initState() {
    super.initState();
    _getdata();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == false){ name_lang(context);}
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color(0xFF2f3640),
        elevation: 0,
        centerTitle: true,
        title: Text(getTranslated(context, 'terms_title')),
      ),
      body: SingleChildScrollView(
        child:Row(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(0),
                onTap: () {},
                child: Card(
                  shape: RoundedRectangleBorder(
                    side:
                    BorderSide(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.only(top:0),
                  //color: Colors.grey,
                  elevation: 0,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isLoading? Container(child: Center(child: GFLoader(
                                      type:GFLoaderType.circle,
                                      loaderColorOne: Color(0xFF2196f3),
                                      loaderColorTwo: Color(0xFF2196f3),
                                      loaderColorThree: Color(0xFF2196f3),
                                    ),),) : Html(

                                      data:
                                      about,
                                      /*style: {
                                        'body': Style(
                                          fontSize: FontSize(16.0),
                                          fontFamily: "CustomIcons",
                                          textAlign: TextAlign.center,
                                        )
                                      },*/
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
