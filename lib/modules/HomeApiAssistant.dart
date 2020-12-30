import 'package:couponsgate/modules/Code.dart';
import 'package:couponsgate/modules/Favorite.dart';
import 'package:couponsgate/modules/Rating.dart';
import 'package:couponsgate/modules/Store.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HomeApiAssistant {

  List<Rating> _ratings;
  List<Favorite> _favorites;
  List<Store> _stores;
  List<Code> _codes;

  Future getUserRatings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    //print('$value');

    if (value == '1') {
      final key2 = 'token';
      final value2 = prefs.get(key2);

      var data = {
        'user_token': value2,
      };

      Rating tRating;
      _ratings = [];

      var res = await http.post(
          'https://yalaphone.com/appdash/rest_api/ratings/get_ratings_by_user.php',
          body: data);
      //print(res.body.toString());
      var body = json.decode(res.body);
      //print(body);

      if (body['ratings'] != null) {
        for (var fav in body['ratings']) {
          tRating = Rating.fromJson(fav);
          _ratings.add(tRating);
        }

        return _ratings;
      }
    }
    return _ratings;
  }

  String checkIfInRatings(String cid, List<Rating> ratedCoupons , String type) {
    try {
      for (Rating rat in ratedCoupons)
        if (cid == rat.couponId && rat.type == type) return rat.id;
    } catch (e) {
      return null;
    }
  }

  Future addRating(String cid, String type) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    //print('$value');
    if (value == '1') {
      final key2 = 'token';
      final value2 = prefs.get(key2);

      final key3 = 'user_id';
      final value3 = prefs.get(key3);

      var data = {
        'user_token': value2,
        'user_id': value3,
        'coupon_id': cid,
        'type': type,
      };

      var res = await http.post(
          'https://yalaphone.com/appdash/rest_api/ratings/add_rating.php',
          body: data);
      //print(res.body);
      //print('sending...');
      var body = json.decode(res.body);
      //print(body);

      return true;
    } else {
      return false;
    }
  }

  Future deleteRating(String fid) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    //print('$value');
    if (value == '1') {
      final key2 = 'token';
      final value2 = prefs.get(key2);

      var data = {
        'id': fid,
        'user_token': value2,
      };

      var res = await http.post(
          'https://yalaphone.com/appdash/rest_api/ratings/remove_rating.php',
          body: data);
      //print(res.body);
      //print('sending...');
      var body = json.decode(res.body);
      //print(body);

      return true;
    } else {
      return false;
    }
  }

  Future getCouponNegRatings(String cid) async
  {
    var data = {
      'coupon_id': cid,
    };

    var res = await http.post(
        'https://yalaphone.com/appdash/rest_api/ratings/get_coupon_neg_rating.php',
        body: data);
    //print(res.body);
    //print('sending...');
    var body = json.decode(res.body);
    print(body);

    if (body.toString().contains('negative')) {
      return body['negative'];
    }
    else
      return ' ';
  }

  Future getCouponPosRatings(String cid) async
  {
    var data = {
      'coupon_id': cid,
    };

    var res = await http.post(
        'https://yalaphone.com/appdash/rest_api/ratings/get_coupon_pos_rating.php',
        body: data);
    //print(res.body);
    //print('sending...');
    var body = json.decode(res.body);
    print(body);

    if (body.toString().contains('positive')) {
      return body['positive'];
    }
    else
      return ' ';
  }

  Future getUserFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    //print('$value');
    if (value == '1')
    {
      final key2 = 'token';
      final value2 = prefs.get(key2);
      var data = {
        'user_token': value2,
      };

      Favorite tFav;
      _favorites = [];

      var res = await http.post(
          'https://yalaphone.com/appdash/rest_api/favorites/get_favs_by_user.php',
          body: data);
      //print(res.body.toString());
      var body = json.decode(res.body);
      //print(body);

      if (body['favorites'] != null) {
        for (var fav in body['favorites']) {
          tFav = Favorite.fromJson(fav);
          _favorites.add(tFav);
        }

        return _favorites;
      }
    }
  }

  Future addFavorite(String cid) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    //print('$value');
    if (value == '1') {
      final key2 = 'token';
      final value2 = prefs.get(key2);

      final key3 = 'user_id';
      final value3 = prefs.get(key3);

      var data = {
        'user_token': value2,
        'user_id': value3,
        'coupon_id': cid,
      };

      var res = await http.post(
          'https://yalaphone.com/appdash/rest_api/favorites/add_fav.php',
          body: data);
      //print(res.body);
      //print('sending...');
      var body = json.decode(res.body);

      return true;
    }
    else
      {
        return false;
      }
  }

  Future deleteFavorite(String fid) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    //print('$value');
    if (value == '1') {
      final key2 = 'token';
      final value2 = prefs.get(key2);


      var data = {
        'id': fid,
        'user_token': value2,
      };

      var res = await http.post(
          'https://yalaphone.com/appdash/rest_api/favorites/remove_fav.php',
          body: data);
      var body = json.decode(res.body);
      //print(body);

      return true;
    }
    else
      {
        return false;
      }
  }

  Future getStores() async
  {
    var ssResponse = await http
        .get('https://yalaphone.com/appdash/rest_api/stores/get_stores_sample.php');
    var ssData = json.decode(ssResponse.body);
    Store tStore;
    _stores = [];

    for (var ques in ssData['stores']) {
      tStore = Store.fromJson(ques);
      //print(tStore.id);

      _stores.add(tStore);
      //print('depart length is : ' + departs.length.toString());
    }

    return _stores;
  }

  Future getStoresByCountry(String countryCode) async
  {
    var ssResponse = await http
        .post('https://yalaphone.com/appdash/rest_api/stores/get_stores_sample_by_country.php' , body: {
      'country' : countryCode
    });
    var ssData = json.decode(ssResponse.body);
    Store tStore;
    _stores = [];

    for (var ques in ssData['stores']) {
      tStore = Store.fromJson(ques);
      // print(tStore.id);

      _stores.add(tStore);
      //print('depart length is : ' + departs.length.toString());
    }

    return _stores;
  }

  Future getUserCodes() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    //print('$value');

    if (value == '1') {
      final key2 = 'token';
      final value2 = prefs.get(key2);

      var data = {
        'user_token': value2,
      };

      Code tCode;
      _codes = [];

      var res = await http.post(
          'https://yalaphone.com/appdash/rest_api/codes/get_codes_by_user.php',
          body: data);
      //print(res.body.toString());
      var body = json.decode(res.body);
      //print(body);

      if (body['codes'] != null) {
        for (var fav in body['codes']) {
          tCode = Code.fromJson(fav);
          _codes.add(tCode);
        }

        return _codes;
      }
    }
    return _codes;
  }

  String checkIfInCodes(String cid, List<Code> copiedCoupons) {
    try {
      for (Code code in copiedCoupons)
        if (cid == code.couponId) return code.id;
    } catch (e) {
      return null;
    }
  }

  Future copyCode(String cid) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = prefs.get(key);
    //print('$value');
    if (value == '1') {
      final key2 = 'token';
      final value2 = prefs.get(key2);

      final key3 = 'user_id';
      final value3 = prefs.get(key3);

      var data = {
        'user_token': value2,
        'user_id': value3,
        'coupon_id': cid,
      };

      var res = await http.post(
          'https://yalaphone.com/appdash/rest_api/codes/copy_code.php',
          body: data);
      //print(res.body);
      //print('sending...');
      var body = json.decode(res.body);
      //print(body);

      return true;
    } else {
      return false;
    }
  }

  Future getCouponCopyTimes(String cid) async
  {
    var data = {
      'coupon_id': cid,
    };

    var res = await http.post(
        'https://yalaphone.com/appdash/rest_api/codes/get_coupon_copy_times.php',
        body: data);
    //print(res.body);
    //print('sending...');
    var body = json.decode(res.body);
    print(body);

    if (body.toString().contains('copy_times')) {
      return body['copy_times'];
    }
    else
      return ' ';
  }

}
