import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/ApiAssistant.dart';
import 'package:couponsgate/modules/Code.dart';
import 'package:couponsgate/modules/Country.dart';
import 'package:couponsgate/modules/Coupon.dart';
import 'package:couponsgate/modules/Favorite.dart';
import 'package:couponsgate/modules/HomeApiAssistant.dart';
import 'package:couponsgate/modules/Language.dart';
import 'package:couponsgate/modules/Rating.dart';
import 'package:couponsgate/modules/Store.dart';
import 'package:couponsgate/widgets/NavDrawer.dart';
import 'package:couponsgate/widgets/countries.dart';
import 'package:couponsgate/widgets/coupon_main.dart';
import 'package:couponsgate/widgets/favorites.dart';
import 'package:couponsgate/widgets/login.dart';
import 'package:couponsgate/widgets/settings.dart';
import 'package:couponsgate/widgets/stores/all_stores.dart';
import 'package:couponsgate/widgets/stores/store_coupons.dart';
import 'package:couponsgate/widgets/tabs/search_tab.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../my_icons_icons.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  HomeApiAssistant homeApi = new HomeApiAssistant();
  ApiAssistant api = new ApiAssistant();

  final search_nameController = TextEditingController();
  var _controller = ScrollController();

  List<Store> _rStores = [];
  List<Coupon> _coupons , _extraCoupons = [] , _rCoupons = [];
  List<Favorite> _rFavorites = [];
  List<Icon> _favouritesLikeIcons = [] , _favouritesDislikeIcons = [];
  List<Rating> _rRatings = [];
  List<Code> _rCodes = [];
  List<String> _posRatings = [], _negRatings = [] , _copyTimes = [];
  List<bool> _visibleShopBtn = [];


  bool _isStoresLoading;
  bool _isCouponsLoading;
  var _isLoadMore = false;
  var _isCouponsEnd = false;
  var _isCountryLoading = true;
  var _isLoading = true;
  var _isShopeNowVisible = false;
  String _currentCoupon = '0';
  int lsubmit_btn_child_index = 0;
  int loadModeChildIndicator = 0;
  String notificationRouteType = '0';
  String couponNotificationId = '0';
  String storeNotificationId = '0';
  String notificationUrl = '0';
  String notificationID = '0';

  List<Country> _countries , _rCountries = [];
  String _countryBtnHint = '+';
  String _countryID;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();


  Future onSelectNotification(String payload) async {
    // showDialog(
    //   context: context,
    //   builder: (_) {
    //     return new AlertDialog(
    //       title: Text("PayLoad"),
    //       content: Text("Payload : $payload"),
    //     );
    //   },
    // );
    api.sendNotificationSeenAck(notificationID).then((value) {
      _foregroundNotificationRouter();
    });

  }
  void showNotification(String title, String body) async {
    await _demoNotification(title, body);
  }

  Future<void> _demoNotification(String title, String body) async {

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'test');
  }

  Future<void> showBigPictureNotification(String imgUrl , String title , String body) async {

    final String largeIconPath = await _downloadAndSaveFile(
        imgUrl, 'largeIcon');

    var bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(largeIconPath),
      largeIcon:  FilePathAndroidBitmap(largeIconPath),
      contentTitle: title,
      summaryText: body,
    );

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: Priority.high,
        styleInformation: bigPictureStyleInformation);

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: "big image notifications");
  }


  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(url);
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<NotificationDetails> _getImage(BuildContext context , String imgUrl) async{

    final String largeIconPath = await _downloadAndSaveFile(
        imgUrl, 'largeIcon');

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
              'big text channel id',
              'big text channel name',
              'big text channel description',
              importance: Importance.max,
              playSound: true,
              showProgress: true,
              priority: Priority.high,
              largeIcon: FilePathAndroidBitmap(largeIconPath),
    );

    return NotificationDetails(android: androidPlatformChannelSpecifics, iOS: null);

  }

  Future showImgNotification(
      BuildContext context,
      FlutterLocalNotificationsPlugin notifications,
      String title,
      String body,
      String imgUrl,
      ) async
  {
    notifications.show(0, title, body, await _getImage(context , imgUrl));
  }

  handleNotificationByLocal(context , Map<String, dynamic> message)
  {
    Locale currentLocale = Localizations.localeOf(context);

    if(currentLocale.languageCode == 'ar')
    {
      showNotification(
          message['data']['ar_title'], message['data']['ar_content']);
    }
    else
    {
      showNotification(
          message['data']['en_title'], message['data']['en_content']);
    }

  }

  _foregroundNotificationRouter()
  {

    switch(notificationRouteType)
    {
      case 'local_coupon': if(couponNotificationId != '0')
      {

          Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => new CouponMain(id: couponNotificationId,)),
          ).whenComplete(() {
            setState(() {
              couponNotificationId = '0';
            });
          });

      }
      break;

      case 'local_store': if(storeNotificationId != null)
      {

          homeApi.getStoreById(storeNotificationId).then((store) {

            Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) => new StoryCoupon(country: store,)),
            ).whenComplete(() {
              setState(() {
                storeNotificationId = '0';
              });
            });

          });
      }
      break;

      case 'url': if(notificationUrl != null)
      {
        _launchStoreURL(notificationUrl).whenComplete(() {
          setState(() {
            notificationUrl = '0';
          });
        });
      }
      break;
    }

  }

  _backgroundNotificationRouter(Map<String , dynamic> message)
  {

    switch(message['data']['route_type'])
    {
      case 'local_coupon': if(message['data']['payload'] != null)
      {
        setState(() {
          couponNotificationId = message['data']['payload'];

          api.sendNotificationSeenAck(notificationID).then((value) {

            Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) => new CouponMain(id: couponNotificationId,)),
            ).whenComplete(() {
              setState(() {
                couponNotificationId = '0';
              });
            });

          });

        });
      }
      break;

      case 'local_store': if(message['data']['payload'] != null)
      {
        setState(() {
          storeNotificationId = message['data']['payload'];

          homeApi.getStoreById(storeNotificationId).then((store) {

            api.sendNotificationSeenAck(notificationID).then((value) {

              Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new StoryCoupon(country: store,)),
              ).whenComplete(() {
                setState(() {
                  storeNotificationId = '0';
                });
              });

            });

          });
        });
      }
      break;

      case 'url': if(message['data']['payload'] != null)
      {
        api.sendNotificationSeenAck(notificationID).then((value) {
          _launchStoreURL(message['data']['payload']);
        });
      }
      break;
    }

  }

  Future checkIfDuplicatedNotification (String receivedId) async
  {
    final prefs = await SharedPreferences.getInstance();
    final key = 'last_notification_id';
    final value = prefs.get(key);

    if(receivedId == value.toString())
      return true;
    else
      return false;
  }

  Future setLastNotificationId (String receivedId) async
  {
    final prefs = await SharedPreferences.getInstance();
    final key = 'last_notification_id';
    prefs.setString(key, receivedId);
  }

  void initializeNotificationsConfigs() {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String , dynamic> message) async {

        api.sendNotificationDeliveryAck(message['data']['notification_id']).then((value) {

          if(message['data']['image'] == null)
          {
            print('non-image notification test >>>>>');
            showNotification(
                message['notification']['title'], message['notification']['body']);
          }
          else if(message['data']['image'] != null)
          {
            print('image notification test >>>>>');
            print(message['data']['image']);
            // showImgNotification(context ,
            //     flutterLocalNotificationsPlugin ,
            //     message['notification']['title'],
            //     message['notification']['body'],
            //     message['data']['image'],
            // );
            showBigPictureNotification(message['data']['image'],
                message['notification']['title'],
                message['notification']['body']);
          }

          print("onMessage: $message");

          setState(() {
            notificationRouteType = message['data']['route_type'];
            notificationID = message['data']['notification_id'];

            switch(message['data']['route_type'])
            {
              case 'local_coupon': if(message['data']['payload'] != null)
              {
                setState(() {
                  couponNotificationId = message['data']['payload'];
                });
              }
              break;

              case 'local_store': if(message['data']['payload'] != null)
              {
                setState(() {
                  storeNotificationId = message['data']['payload'];
                });
              }
              break;

              case 'url': if(message['data']['payload'] != null)
              {
                setState(() {
                  notificationUrl = message['data']['payload'];
                });
              }
              break;
            }
          });

        });

      },
      onLaunch: (Map<String, dynamic> message) async {

        if(!await checkIfDuplicatedNotification(message['data']['notification_id']))
          {
            setLastNotificationId(message['data']['notification_id']).whenComplete(() {

              print("onLaunch: $message");
              setState(() {
                notificationID = message['data']['notification_id'];
                api.sendNotificationDeliveryAck(notificationID).then((value) {
                  _backgroundNotificationRouter(message);
                });
              });

            });
          }
      },
      onResume: (Map<String, dynamic> message) async {

        if(!await checkIfDuplicatedNotification(message['data']['notification_id']))
        {
          setLastNotificationId(message['data']['notification_id']).whenComplete(() {

            print("onResume: $message");
            setState(() {
              notificationID = message['data']['notification_id'];
              api.sendNotificationDeliveryAck(notificationID).then((value) {
                _backgroundNotificationRouter(message);
              });
            });

          });
        }

      },
    );

  }

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

  _initializeStoresSection() async
  {
    final prefs = await SharedPreferences.getInstance();
    final key = 'country_code';
    final value = prefs.get(key);

    //print('value = $value');
    if(value == null || value.toString() == '0')
      {
        homeApi.getStores().then((value){
          setState(() {
            _rStores = List.from(value);
            _isStoresLoading = false;
          });
        });
      }
    else
      {
        homeApi.getStoresByCountry(value).then((value){
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

  Future _getCoupons(String current) async
  {
    var ssResponse = await http
        .post('https://yalaphone.com/appdash/rest_api/coupons/coupons_lazy_load_all.php' ,
        body: {'current_id' : current});

    var ssData = json.decode(ssResponse.body);

    //print(ssData.toString());

    Coupon tCoupon;
    _coupons = [];

    try
    {
      for (var ques in ssData['coupons']) {
        tCoupon = Coupon.fromJson(ques);
        //print('coupons: $tCoupon.id');

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

    }
    catch(e)
    {
      setState(() {
        //('end of results');
        _isLoadMore = false;
        _isCouponsEnd = true;
      });
    }

    return _coupons;
  }

  Future _getCouponsByCountry(String countryCode , String current) async
  {
    print(countryCode);

    var ssResponse = await http
        .post('https://yalaphone.com/appdash/rest_api/coupons/coupons_lazy_load_by_country.php' , body: {
      'country' : countryCode,
      'current_id' : current,
    });
    var ssData = json.decode(ssResponse.body);
    //print(ssData.toString());
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

  _initializeCouponsSection(String currentCoupon) async
  {
    final prefs = await SharedPreferences.getInstance();
    final key = 'country_code';
    final value = prefs.get(key);

    print('guest: $value');
    if(value == null || value.toString() == '0')
    {
     await _getCoupons(currentCoupon).then((value){
        setState(() {
          _rCoupons = List.from(value);

          try{
            setState(() {
              _currentCoupon = _rCoupons.last.id;
            });

          }catch(e){
            setState(() {
              _currentCoupon = '0';
            });
          }
          //print('last coupon>>$_currentCoupon');

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
    else
    {
      print('coupons by country anonymous');

      await _getCouponsByCountry(value , currentCoupon).then((value){
        setState(() {
          _rCoupons = List.from(value);

          for(var fav in _rCoupons)
          {
            setState(() {
              _favouritesLikeIcons.add(Icon(Icons.favorite,color: Colors.red,));
              _favouritesDislikeIcons.add(Icon(Icons.favorite_border,color: Color(0xFF2196f3),));
              _visibleShopBtn.add(false);
            });

          }

          try{
            setState(() {
              _currentCoupon = _rCoupons.last.id;
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

  _loadMoreCoupons(String currentCoupon) async
  {
    final prefs = await SharedPreferences.getInstance();
    final key = 'country_code';
    final value = prefs.get(key);

    setState(() {
      loadModeChildIndicator = 1;
    });

    if(value == null)
    {
      _getCoupons(currentCoupon).then((value){
        setState(() {
          _extraCoupons = List.from(value);

          if(_extraCoupons.length > 0)
          {
            for(var coupon in _extraCoupons)
            {
              _rCoupons.add(coupon);
            }
            _currentCoupon = _rCoupons.last.id;
            print('ex length :' + _extraCoupons.length.toString());
            print('>>$_currentCoupon');

            _getCouponsRatings(_rCoupons).then((value){

              _getCouponsCodes(_rCoupons).then((value){
                setState(() {
                  _isCouponsLoading = false;
                });
              });

            });

          }

          loadModeChildIndicator = 0;
        });
      });
    }
    else
    {
      _getCouponsByCountry(value , currentCoupon).then((value){
        setState(() {
          _extraCoupons = List.from(value);
          print('ex length :' + _extraCoupons.length.toString());

          if(_extraCoupons.length > 0)
          {
            for(var coupon in _extraCoupons)
            {
              _rCoupons.add(coupon);
            }

            for(var fav in _rCoupons)
            {
              setState(() {
                _favouritesLikeIcons.add(Icon(Icons.favorite,color: Colors.red,));
                _favouritesDislikeIcons.add(Icon(Icons.favorite_border,color: Color(0xFF2196f3),));
                _visibleShopBtn.add(false);
              });

            }

            _currentCoupon = _rCoupons.last.id;
            print('>>$_currentCoupon');

            _getCouponsRatings(_rCoupons).then((value){

              _getCouponsCodes(_rCoupons).then((value){
                setState(() {
                  _isCouponsLoading = false;
                });
              });

            });

          }

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
        if(_rCoupons.length > 10 && _extraCoupons.length == 0)
          setState(() {
          _isLoadMore = false;
          _isCouponsEnd = true;
        });
        else
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

  /*couponWidget(int i,BuildContext context)
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
                            fit: BoxFit.fill,
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
                }, child: Container(
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
                padding: const EdgeInsets.only(top:5,left: 10,right: 10,bottom: 0),
                child:Row(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  //verticalDirection: VerticalDirection.up,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [

                    //copy code
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

                    //pos rating
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

                    //neg rating
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
                          border: Border.all(color: Color(0xFF2196f3)),
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
  }*/

  couponWidget(int i,BuildContext context)
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Container(width: MediaQuery.of(context).size.width-75,child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(onTap:(){
                          ClipboardManager.copyToClipBoard(
                              _rCoupons[i].code)
                              .then((result) {
                            final snackBar = SnackBar(
                              content: Text(getTranslated(context, 'Copied') + _rCoupons[i].code),
                            );
                            setState(() {
                              _visibleShopBtn[i] = true;
                              Scaffold.of(context).showSnackBar(snackBar);
                            });

                          });

                          if(homeApi.checkIfInCodes(_rCoupons[i].id, _rCodes) == null)
                            _copyCode(_rCoupons[i].id , _rCoupons[i].code);
                        } , child: Container(
                            width: 100,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.copy,
                                      color: Colors.blue,
                                      size: 14,
                                    ),
                                    SizedBox(width: 10,),
                                    Text(
                                      getTranslated(context, 'home_coupon_code_used_prefix') +
                                          _copyTimes[i].toString() + getTranslated(context, 'home_coupon_code_used_suffix'),
                                      style: TextStyle(
                                        fontSize: 16,
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
                                      size: 14,
                                    ),
                                    SizedBox(width: 10,),
                                    Text(
                                      getTranslated(context, 'home_coupon_code_add_date') + _rCoupons[i].createdAt.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontFamily: "CustomFont",

                                      ),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            //Expanded(flex: 30, child: Container(),)
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Padding(
                        padding: const EdgeInsets.only(top:5,left: 10,right: 10,bottom: 10),
                        child:Row(

                          crossAxisAlignment: CrossAxisAlignment.center,
                          //verticalDirection: VerticalDirection.up,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [

                            //copy code
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(onTap:(){
                                  ClipboardManager.copyToClipBoard(
                                      _rCoupons[i].code)
                                      .then((result) {
                                    final snackBar = SnackBar(
                                      content: Text(getTranslated(context, 'Copied') + _rCoupons[i].code),
                                    );
                                    setState(() {
                                      _visibleShopBtn[i] = true;
                                      Scaffold.of(context).showSnackBar(snackBar);
                                    });

                                  });

                                  if(homeApi.checkIfInCodes(_rCoupons[i].id, _rCodes) == null)
                                    _copyCode(_rCoupons[i].id , _rCoupons[i].code);
                                } , child: Container(
                                  width: MediaQuery.of(context).size.width-225,
                                  padding: const EdgeInsets.all(5),
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
                                      SizedBox(width: 10,),
                                      Text(
                                        getTranslated(context, 'home_copy_code'),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontFamily: "CustomFont",
                                          fontWeight: FontWeight.w300,
                                        ),
                                        softWrap: true,
                                      ),


                                    ],
                                  ),
                                ),),

                              ],
                            ),





                          ],)),
                    Visibility(
                      visible: _visibleShopBtn[i],
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                          child:Row(

                            crossAxisAlignment: CrossAxisAlignment.center,
                            //verticalDirection: VerticalDirection.up,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [

                              //shop now
                              InkWell(onTap:(){
                                _launchStoreURL(_rCoupons[i].storeUrl);
                              } , child: Container(
                                width: MediaQuery.of(context).size.width-225,
                                padding: const EdgeInsets.all(5),
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
                                    SizedBox(width: 10,),
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



                            ],)),
                    )
                  ],
                ),),

                Container(width: 35, margin:const EdgeInsets.only(left: 10,right: 10),child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    //Positive
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

                    //negative
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

                    //favorite
                    _checkIfInFavs(_rCoupons[i].id, _rFavorites) == null ?
                    InkWell(
                      onTap:(){
                        print('its dislike button');
                        setState(() {
                          _favouritesDislikeIcons[i] = Icon(Icons.favorite,color: Colors.red,);

                          print('dislike button changed to like');
                          if(_favouritesLikeIcons[i] != Icon(Icons.favorite,color: Colors.red,))
                            {
                              setState(() {
                                _favouritesLikeIcons[i] = Icon(Icons.favorite,color: Colors.red,);
                              });
                            }
                        });
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
                      child: _favouritesDislikeIcons[i],
                    ),)
                        :
                    InkWell(
                      onTap:(){
                        print('its like button');
                        setState(() {
                          _favouritesLikeIcons[i] = Icon(Icons.favorite_border,color: Color(0xFF2196f3));
                          print('like button changed to dislike');
                          if(_favouritesDislikeIcons[i] != Icon(Icons.favorite_border,color: Color(0xFF2196f3)))
                          {
                            setState(() {
                              _favouritesDislikeIcons[i] = Icon(Icons.favorite_border,color: Color(0xFF2196f3));
                            });
                          }
                        });

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
                      child: _favouritesLikeIcons[i],
                    ),),

                    SizedBox(height: 15,),
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
                    SizedBox(height: 10,),
                  ],
                )),
              ],
            ),


          ],)

    );
  }

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
    _addRating(cid, 'pos');

    // if(homeApi.checkIfInRatings(cid, ratings , 'pos') == null
    // && homeApi.checkIfInRatings(cid, ratings , 'neg') == null)
    // _addRating(cid, 'pos');
    // else if(homeApi.checkIfInRatings(cid, ratings , 'pos') != null
    //     && homeApi.checkIfInRatings(cid, ratings , 'neg') == null)
    // _deleteRating(homeApi.checkIfInRatings(cid, ratings , 'pos'));
    // else if(homeApi.checkIfInRatings(cid, ratings , 'pos') == null
    //     && homeApi.checkIfInRatings(cid, ratings , 'neg') != null)
    //   {
    //     // Do nothing
    //      }
  }

  _handleNegativeButton(String cid , List<Rating> ratings)
  {
    _addRating(cid, 'neg');

    // if(homeApi.checkIfInRatings(cid, ratings , 'pos') == null
    //     && homeApi.checkIfInRatings(cid, ratings , 'neg') == null)
    //   _addRating(cid, 'neg');
    // else if(homeApi.checkIfInRatings(cid, ratings , 'neg') != null
    //     && homeApi.checkIfInRatings(cid, ratings , 'pos') == null)
    //   _deleteRating(homeApi.checkIfInRatings(cid, ratings , 'neg'));
    // else if(homeApi.checkIfInRatings(cid, ratings , 'neg') == null
    //     && homeApi.checkIfInRatings(cid, ratings , 'pos') != null)
    // {
    //   // Do nothing
    // }
  }

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

        ClipboardManager.copyToClipBoard(
            code)
            .then((result) {
          final snackBar = SnackBar(
            content: Text(getTranslated(context, 'Copied') + code),
          );
          setState(() {
            Scaffold.of(context).showSnackBar(snackBar);
          });

        });

      }
    });

  }

  Future _launchStoreURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _changeLanguage(Language lang) async {
    Locale currentLocale = Localizations.localeOf(context);

    print(lang.code);
    print(currentLocale.languageCode);

    Locale _locale = await setLocale(lang.code);
    MyApp.setLocale(context, _locale);

    api.getUserNotificationByLocal(currentLocale.languageCode, lang.code);

  }

  @override
  void initState() {
    super.initState();

    initializeNotificationsConfigs();

    _rCodes = new List<Code>();

    setState(() {
      _isStoresLoading = true;
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

    _initializeStoresSection();
    homeApi.getLastCouponId().then((lastOne) {
      setState(() {
        _initializeCouponsSection(lastOne);
      });
    });

    _getCountries();
  }

  @override
  void dispose() {
    flutterLocalNotificationsPlugin.cancelAll();

    super.dispose();
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
        title: Text(getTranslated(context, 'home_title'),style: TextStyle(fontFamily: 'CustomFont',color: Colors.black,fontWeight: FontWeight.bold),),
        actions: [
          Padding(
              padding: const EdgeInsets.only(top:10,right: 10,left: 10,bottom: 0),
              child: DropdownButton(
            dropdownColor: Colors.grey,
            icon: Icon(
              Icons.language,
              color: Colors.blue,
            ),
            underline: SizedBox(),
            items: Language.languageList()
                .map<DropdownMenuItem<Language>>(
                    (lang) => DropdownMenuItem(
                  value: lang,
                  child: Text(
                    lang.name,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                ))
                .toList(),
            onChanged: (Language lang) {
              _changeLanguage(lang);
            },
          )),
        ],
      ),
      body:Builder(
          builder: (context) => SingleChildScrollView(
              controller: _controller,
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
                                onFieldSubmitted: (String str){Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new search_tab(text: search_nameController.text.toString())));},


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


                /*Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Text(getTranslated(context, 'login_country_btn'),style: TextStyle(fontSize: 20,fontFamily: "CustomFont"),),
                    SizedBox(height: 10,),

                    InkWell(
                      onTap: () {
                        setState(() {
                          _isLoading = true;
                        });

                        _showCountriesDialog(context, _rCountries);



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
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue,),
                        ): Text(
                          _countryBtnHint,
                          style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "CustomFont"),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                  ],),*/
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
                          child: Text(getTranslated(context, 'home_stores_title'),style: TextStyle(fontSize: 16,fontFamily: "CustomFont",color: Colors.black),)),

                      Padding(
                          padding: const EdgeInsets.only(top:15,right: 10,left: 10,bottom: 0),
                          child: InkWell(
                              onTap: (){Navigator.of(context).push(
                                new MaterialPageRoute(
                                    builder: (BuildContext context) => new AllStores()),
                              );},
                              child:  Text(getTranslated(context, 'home_stores_all_btn'),style: TextStyle(fontSize: 15,fontFamily: "CustomFont"),)),),


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
                            return InkWell(
                              onTap: (){
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                        new StoryCoupon(
                                          country: _rStores[index],
                                        )));
                              },
                              child:
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
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage("https://yalaphone.com/appdash/"+_rStores[index].logo),
                                        )
                                    )),
                                new Text(sPropertyByLocale(context, _rStores[index], 'name'),style: TextStyle(fontFamily: "CustomFont",fontSize: 16),)
                              ],
                            ),);
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

                      /*Padding(
                          padding: const EdgeInsets.only(top:15,right: 10,left: 10,bottom: 0),
                          child: Text(getTranslated(context, 'home_coupons_all_btn'),style: TextStyle(fontSize: 15,fontFamily: "CustomFont"),)),
*/

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
                  child: Column(
                      children: <Widget>[for(int i = 0 ; i< _rCoupons.length ; i++) couponWidget(i,context)],
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
                            _loadMoreCoupons(_currentCoupon);
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
          style: TabStyle.fixed,
          items: [
            TabItem(icon: MyIcons.globe, title: getTranslated(context, 'home_b_bar_countries')),
            TabItem(icon: Icons.shopping_bag, title: getTranslated(context, 'home_b_bar_stores')),
            TabItem(icon: Icons.home, title: getTranslated(context, 'home_b_bar_home')),
            TabItem(icon: Icons.favorite, title: getTranslated(context, 'home_b_bar_fav')),
            TabItem(icon: Icons.people, title: getTranslated(context, 'home_b_bar_profile')),
          ],
          initialActiveIndex: 2,//optional, default as 0
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
      /*Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Home()));*/
    } else if (index == 3) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Favorites()));
    } else if (index == 4) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Settings()));
    }
  }



  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Are you talkin\' to me?'));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future _getCountries() async
  {
    var csResponse = await http
        .get('https://yalaphone.com/appdash/rest_api/countries/getAllCountries.php');
    var csData = json.decode(csResponse.body);
    Country tCountry;
    _countries = [];

    Map<String,dynamic> q = json.decode('{"id":"0","ar-name":"كل الدول","en-name":"All countries","flag":""}');
    _countries.add(Country.fromJson(q));

    for (var ques in csData['countries']) {
      tCountry = Country.fromJson(ques);
      print(tCountry.id);

      _countries.add(tCountry);
      //print('depart length is : ' + departs.length.toString());
    }

    setState(() {
      _rCountries = List.from(_countries);
      _isLoading = false;
      _isCountryLoading = false;
      //_showCountriesDialog(context, _rCountries);
    });


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

  Future<void> changeCountry(context , Country country) async {
    setState(() {
      _countryBtnHint = countryName(context , country);
      _countryID = country.id;
    });

    final prefs = await SharedPreferences.getInstance();
    final key6 = 'country_code';
    final value6 = _countryID;
    prefs.setString(key6, value6);

    setState(() {
      _isStoresLoading = true;
      _isCouponsLoading = true;
      _currentCoupon = '0';
      _rFavorites.clear();
      _rRatings.clear();
      _rCodes.clear();

       _rStores.clear();
       _coupons.clear();
       _extraCoupons.clear();
       _rCoupons.clear();
       _posRatings.clear();
       _negRatings.clear();
       _copyTimes.clear();
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

    _initializeStoresSection();
    homeApi.getLastCouponId().then((lastOne) {
      setState(() {
        _initializeCouponsSection(lastOne);
      });
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
