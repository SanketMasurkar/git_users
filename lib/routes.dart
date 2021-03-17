
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gitusers/Dashboard.dart';
import 'package:page_transition/page_transition.dart';

abstract class RouteName {
  static const dashboard = "/dashboard";
}

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var name = settings.name;
    switch(name){
      case RouteName.dashboard:
        return PageTransition(child: Dashboard(), settings: settings);
    }
  }
}