
import 'dart:async';
import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gitusers/UserDetailsApi.dart';
import 'package:gitusers/routes.dart';

class Splash extends StatefulWidget{
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {

    _gotoDashboard();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: FadeAnimatedTextKit(
            text: ['SOLUTE LABS'],
            repeatForever: true,
            textStyle: TextStyle(color: Colors.white, fontSize: 30, fontStyle: FontStyle.normal),
          ),
        ),
      ),
    );
  }

  Future<void> _gotoDashboard() async {
    try{
      /*SharedPreferences preference = await getPreference();
      var bml = preference.get('bookmarkedList');
      if(bml != null){
        bookmarkedList = jsonDecode(bml.toString());
      }*/
    }catch(e){}
    await Future.delayed(Duration(seconds: 5));
    Navigator.pushNamedAndRemoveUntil(context, RouteName.dashboard, (Route<dynamic> route) => false);
  }

}