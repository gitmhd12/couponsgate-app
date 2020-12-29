import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ApiAssistant {
  final String serverUrl = 'https://www.yalaphone.com/appdash/rest_api';
  bool registerStatus = false;
  bool loginStatus = false;
  bool emailValidStatus = false;
  bool resetPassStatus = false;
  bool isEmailUsed = false;
  String pinCode;
  int fb_login_status;
  int g_login_status;

  _saveUserParams(
      String userId, String pass, String name, String email, String token , String countryCode ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'is_login';
    final value = "1";
    prefs.setString(key, value);

    final key1 = 'user_id';
    final value1 = userId;
    prefs.setString(key1, value1);

    final key2 = 'name';
    final value2 = name;
    prefs.setString(key2, value2);

    final key3 = 'pass';
    final value3 = pass;
    prefs.setString(key3, value3);

    final key4 = 'email';
    final value4 = email;
    prefs.setString(key4, value4);

    final key5 = 'token';
    final value5 = token;
    prefs.setString(key5, value5);

    final key6 = 'country_code';
    final value6 = countryCode;
    prefs.setString(key6, value6);
  }

  registerData(String pass , String name , String email , String country) async {
    //print('ok2');
    String myUrl = "$serverUrl/register.php";
    http.Response response = await http.post(myUrl, body: {
      'email': email,
      'password': pass,
      'name': name,
      'country': country,
    });

    print("result: ${response.body}");

    if (response.body.toString().contains("registered")) {

      var data = json.decode(response.body);
      //print(data['user']['name']);
      _saveUserParams(data['user']['id'], data['user']['password'], data['user']['name'], data['user']['email'], data['user']['token'], data['user']['country']);
      registerStatus = true;
    } else if(response.body.toString().contains("email used"))
    {
      isEmailUsed = true;
    }
      else {
      registerStatus = false;
    }
  }

  loginData(String pass , String email) async {
    //print('ok3');
    String myUrl = "$serverUrl/login.php";
    http.Response response = await http.post(myUrl, body: {
      'email': email,
      'password': pass,
    });

    //print("result: ${response.body}");

    if (response.body.toString().contains("logged_in")) {

      var data = json.decode(response.body);
      print(data.toString());
      _saveUserParams(data['user']['id'], data['user']['password'], data['user']['name'], data['user']['email'], data['user']['token'], data['user']['country']);
      loginStatus = true;
    } else {
      loginStatus = false;
    }
  }

  validateEmail(String email) async {
    String myUrl = "$serverUrl/pre_reset_password.php";
    http.Response response = await http.post(myUrl, body: {
      'email': email,
    });

    print("result: ${response.body}");

    if (response.body.toString().contains("pincode")) {

      var data = json.decode(response.body);
      print(data['pincode']);

      pinCode = data['pincode'].toString();
      emailValidStatus = true;
    } else {
      emailValidStatus = false;
    }
  }

  resetPassword(String email , String newPassword) async {
    if(pinCode != null)
      {
        String myUrl = "$serverUrl/reset_password.php";
        http.Response response = await http.post(myUrl, body: {
          'email': email,
          'pincode': pinCode,
          'newpass': newPassword,
        });

        print("result: ${response.body}");

        if (response.body.toString().contains("password reset complete")) {

          resetPassStatus = true;
        } else {
          resetPassStatus = false;
        }
      }
  }

  registerData_fb( String name , String email , String fb_id) async {
    fb_login_status = 0;
    //print('ok2');
    String myUrl = "$serverUrl/fb_register.php";
    http.Response response = await http.post(myUrl, body: {
      'email': email,
      'name': name,
      'fb_id': fb_id,
    });

    print("result: ${response.body}");
    var data = json.decode(response.body);

    if (data['Succes'] == 1) {

      final prefs = await SharedPreferences.getInstance();
      final key = 'is_login';
      final value = "1";
      prefs.setString(key, value);

      final key2 = 'name';
      final value2 = data['user']['name'];
      prefs.setString(key2, value2);

      final key4 = 'email';
      final value4 = data['user']['email'];
      prefs.setString(key4, value4);

      final key5 = 'token';
      final value5 = data['user']['token'];
      prefs.setString(key5, value5);

      fb_login_status = 1;

    } else if (data['Succes'] == 2) {

      final prefs = await SharedPreferences.getInstance();
      final key = 'is_login';
      final value = "1";
      prefs.setString(key, value);

      final key1 = 'user_id';
      final value1 = data['user']['id'];
      prefs.setString(key1, value1);

      final key3 = 'pass';
      final value3 = data['user']['password'];
      prefs.setString(key3, value3);

      final key6 = 'country_code';
      final value6 = data['user']['country'];
      prefs.setString(key6, value6);

      final key2 = 'name';
      final value2 = data['user']['name'];
      prefs.setString(key2, value2);

      final key4 = 'email';
      final value4 = data['user']['email'];
      prefs.setString(key4, value4);

      final key5 = 'token';
      final value5 = data['user']['token'];
      prefs.setString(key5, value5);

      fb_login_status = 2;
    }else{
      fb_login_status = 0;
    }

  }

  registerData_g( String name , String email , String g_id) async {
    g_login_status = 0;
    //print('ok2');
    String myUrl = "$serverUrl/g_register.php";
    http.Response response = await http.post(myUrl, body: {
      'email': email,
      'name': name,
      'g_id': g_id,
    });

    print("result: ${response.body}");
    var data = json.decode(response.body);

    if (data['Succes'] == 1) {

      final prefs = await SharedPreferences.getInstance();
      final key = 'is_login';
      final value = "1";
      prefs.setString(key, value);

      final key2 = 'name';
      final value2 = data['user']['name'];
      prefs.setString(key2, value2);

      final key4 = 'email';
      final value4 = data['user']['email'];
      prefs.setString(key4, value4);

      final key5 = 'token';
      final value5 = data['user']['token'];
      prefs.setString(key5, value5);

      g_login_status = 1;

    } else if (data['Succes'] == 2) {

      final prefs = await SharedPreferences.getInstance();
      final key = 'is_login';
      final value = "1";
      prefs.setString(key, value);

      final key1 = 'user_id';
      final value1 = data['user']['id'];
      prefs.setString(key1, value1);

      final key3 = 'pass';
      final value3 = data['user']['password'];
      prefs.setString(key3, value3);

      final key6 = 'country_code';
      final value6 = data['user']['country'];
      prefs.setString(key6, value6);

      final key2 = 'name';
      final value2 = data['user']['name'];
      prefs.setString(key2, value2);

      final key4 = 'email';
      final value4 = data['user']['email'];
      prefs.setString(key4, value4);

      final key5 = 'token';
      final value5 = data['user']['token'];
      prefs.setString(key5, value5);

      g_login_status = 2;
    }else{
      g_login_status = 0;
    }

  }

}
