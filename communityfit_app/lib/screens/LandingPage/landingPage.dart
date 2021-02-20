import 'package:community_fit/constants/colors.dart';
import 'package:community_fit/shared/authService.dart';
import 'package:community_fit/shared/userDishesStream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community_fit/constants/routes.dart' as _routes;

class LandingPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Container(
      decoration: BoxDecoration(),
      child: watch(userDishesStreamProvider).when(
        data: (dishes) {
          return ListView.builder(
            itemCount: dishes.length + 3,
            itemBuilder: (context, index) {
              if (index == 0) {
                return RaisedButton(
                  child: Text('Sign Out'),
                  color: appBarColor,
                  onPressed: () async {
                    context.read(authServiceProvider).signOut();
                  },
                );
              } else if (index == 1) {
                return RaisedButton(
                  child: Text('Add Dish'),
                  color: appBarColor,
                  onPressed: () async {
                    await Navigator.pushNamed(
                      context,
                      _routes.dishUploadPageRoute,
                    );
                  },
                );
              } else if (index == 2) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Your Food Log',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                );
              }
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=700%2C636',
                    ),
                  ),
                  title: Text(
                    dishes[index].name,
                  ),
                ),
              );
            },
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Text('$error'),
      ),
    );
  }
}
