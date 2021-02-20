import 'package:community_fit/screens/DishUploadPage/dishUploadPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:community_fit/constants/routes.dart' as _routes;

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case _routes.dishUploadPageRoute:
      return MaterialPageRoute(
        builder: (context) => DishUploadPage(),
      );
    default:
      return null;
  }
}
