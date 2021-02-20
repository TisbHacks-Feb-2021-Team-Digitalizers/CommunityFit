import 'package:community_fit/constants/colors.dart';
import 'package:community_fit/shared/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:community_fit/shared/authService.dart';

class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        centerTitle: true,
        title: Text(
          'CommunityFit Login',
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                ),
              ),
              Text(
                'CommunityFit!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                ),
              ),
              Container(
                height: 200,
                width: 200,
                child: Image.asset(
                  'assets/images/healthy-food.png',
                ),
              ),
              SignInButton(
                Buttons.GoogleDark,
                onPressed: () async {
                  final authService = context.read(authServiceProvider);
                  await authService.signInWithGoogle();
                  final databaseService =
                      await context.read(databaseServiceProvider.future);
                  await databaseService.addUser();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
