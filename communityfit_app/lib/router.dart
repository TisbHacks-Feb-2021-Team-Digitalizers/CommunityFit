import 'package:community_fit/models/userData.dart';
import 'package:community_fit/screens/DishUploadPage/dishUploadPage.dart';
import 'package:community_fit/screens/UserProfilePage/userProfilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:community_fit/constants/routes.dart' as _routes;

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case _routes.dishUploadPageRoute:
      return MaterialPageRoute(
        builder: (context) => DishUploadPage(),
      );
    case _routes.userProfilePageRoute:
      final UserData user = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => UserProfilePage(
          user: user,
        ),
      );
    default:
      return null;
  }
}
