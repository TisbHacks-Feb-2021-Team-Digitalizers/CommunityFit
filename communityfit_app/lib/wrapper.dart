import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community_fit/screens/HomePage/homepage.dart';
import 'package:community_fit/screens/LoginPage/loginPage.dart';
import 'package:community_fit/shared/userState.dart';

final _wrapperProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final userFuture = ref.watch(userStateStreamProvider.last);

  ref.maintainState = true;
  return Future.wait(
    [userFuture],
  );
});

class Wrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return watch(_wrapperProvider).when(
      data: (data) {
        User user = data[0];
        if (user == null) {
          return LoginPage();
        } else {
          return HomePage();
        }
      },
      loading: () => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) {
        return Scaffold(
          body: Center(
            child: Text('Something went wrong...'),
          ),
        );
      },
    );
  }
}
