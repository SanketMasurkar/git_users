import 'package:flutter/material.dart';
import 'package:gitusers/Splash.dart';
import 'package:gitusers/routes.dart';

void main() {
  runApp(MaterialApp(
    onGenerateRoute: Routes.generateRoute,
    home: Splash(),
  ));
}
