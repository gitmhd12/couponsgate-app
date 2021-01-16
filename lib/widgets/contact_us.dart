import 'package:couponsgate/localization/localizationValues.dart';
import 'package:couponsgate/modules/ApiAssistant.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  ApiAssistant api = new ApiAssistant();

  TextEditingController _usernameController;
  TextEditingController _emailController;
  TextEditingController _messageController;

  int _sendBtnChildIndex = 0;

  Widget _inputField({controller, hint, icon, inputType}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(40),
              ),
            ),
            child: TextField(
                keyboardType: inputType,
                controller: controller,
                style: TextStyle(color: Color(0xff34495e), fontSize: 16),
                decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: Color(0xff34495e),
                    ),
                    prefixIcon: Icon(
                      icon,
                      color: Color(0xff34495e),
                    ),
                    fillColor: Colors.white,
                    filled: true)),
          )
        ],
      ),
    );
  }

  alertDialog(String text, String title) {
    showDialog(
        context: context,
        builder: (_) => AssetGiffyDialog(
          onlyOkButton: true,
          buttonCancelText: Text(getTranslated(context, 'login_alert_d_cancel'),
              style: TextStyle(fontFamily: "CustomIcons", fontSize: 16)),
          buttonOkText: Text(getTranslated(context, 'login_alert_d_ok'),
              style: TextStyle(
                  fontFamily: "CustomIcons",
                  fontSize: 16,
                  color: Colors.white)),
          buttonOkColor: Colors.redAccent,
          image: Image.asset('assets/images/alert.png', fit: BoxFit.cover),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 18.0,
                fontFamily: "CustomIcons",
                color: Colors.redAccent),
          ),
          description: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "CustomIcons", fontSize: 16),
          ),
          onOkButtonPressed: () {
            Navigator.pop(context);
          },
        ));
  }

  successDialog(String text, String title) {
    showDialog(
        context: context,
        builder: (_) => AssetGiffyDialog(
          onlyOkButton: true,
          buttonCancelText: Text(getTranslated(context, 'login_alert_d_cancel'),
              style: TextStyle(fontFamily: "CustomIcons", fontSize: 16)),
          buttonOkText: Text(getTranslated(context, 'login_alert_d_ok'),
              style: TextStyle(
                  fontFamily: "CustomIcons",
                  fontSize: 16,
                  color: Colors.white)),
          buttonOkColor: Colors.green,
          image: Image.asset('assets/images/success.png', fit: BoxFit.cover),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 18.0,
                fontFamily: "CustomIcons",
                color: Colors.green),
          ),
          description: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "CustomIcons", fontSize: 16),
          ),
          onOkButtonPressed: () {
            Navigator.pop(context);
          },
        ));
  }

  _processSendMessage() async
  {
    if (_sendBtnChildIndex == 0) {
      setState(() {
        _sendBtnChildIndex = 1;
      });

      if (_emailController.text.trim().isEmpty)
      {
        alertDialog(getTranslated(context, 'login_alert_md_email'), getTranslated(context, 'login_alert_md_title'),);
        setState(() {
          _sendBtnChildIndex = 0;
        });
      } else if (_usernameController.text.isEmpty)
      {
        alertDialog(getTranslated(context, 'login_alert_md_name'), getTranslated(context, 'login_alert_md_title'),);
        setState(() {
          _sendBtnChildIndex = 0;
        });
      }else if (_messageController.text.isEmpty)
      {
        alertDialog(getTranslated(context, 'contact_us_alert_md_message'), getTranslated(context, 'login_alert_md_title'),);
        setState(() {
          _sendBtnChildIndex = 0;
        });
      }else
        {
          api.sendMessage(_usernameController.text.trim(),
              _emailController.text.trim(), _messageController.text.trim()).whenComplete((){
                if(api.contactUsStatus == true)
                  {
                    successDialog(getTranslated(context, 'contact_us_alert_success_content'), getTranslated(context, 'settings_alert_success_title'),);

                    setState(() {
                      _sendBtnChildIndex = 0;
                    });
                  }
                else
                  {
                    alertDialog(getTranslated(context, 'login_alert_Ind_content'), getTranslated(context, 'login_alert_Ind_title'),);
                    setState(() {
                      _sendBtnChildIndex = 0;
                    });
                  }
          });
        }
    }
  }

  buttonChild(int bcIndex  , String label) {
    if (bcIndex == 0) {
      return Text(
        label,
        style: TextStyle(fontSize: 20, color:Colors.white,fontFamily: "CustomFont",),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xff34495e),),
      );
    }
  }

  Widget _sendButton() {
    return InkWell(
      onTap: () {
        _processSendMessage();
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(7),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            //borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),
            borderRadius: BorderRadius.circular(5),
            color: Color(0xFF2196f3)
        ),
        child: buttonChild( _sendBtnChildIndex , getTranslated(context, 'contact_us_send_btn'),),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text(
          getTranslated(context, 'contact_us_title'),
          style: TextStyle(fontFamily: 'CustomFont', color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 30, left: 30, right: 30),
          child: Column(
            children: <Widget>[
              Text(
                getTranslated(context, 'contact_us_username_label'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "CustomFont",
                ),
              ),
              _inputField(
                  controller: _usernameController,
                  hint: getTranslated(context, 'login_name_hint'),
                  icon: Icons.person_outline,
                  inputType: TextInputType.text),
              Text(
                getTranslated(context, 'contact_us_email_label'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "CustomFont",
                ),
              ),
              _inputField(
                  controller: _emailController,
                  hint: getTranslated(context, 'login_email_hint'),
                  icon: Icons.email,
                  inputType: TextInputType.emailAddress),
              Text(
                getTranslated(context, 'contact_us_message_label'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "CustomFont",
                ),
              ),
              _inputField(
                  controller: _messageController,
                  hint: getTranslated(context, 'contact_us_message_hint'),
                  icon: Icons.message,
                  inputType: TextInputType.text),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              _sendButton(),
            ],
          ),
        ),
      ),
    );
  }
}
