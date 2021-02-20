import 'package:community_fit/constants/colors.dart';
import 'package:community_fit/shared/authService.dart';
import 'package:community_fit/shared/userDataStream.dart';
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
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Your Food Log',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                    RaisedButton.icon(
                      label: Text(
                        'Add Dish',
                      ),
                      icon: Icon(
                        Icons.add,
                      ),
                      color: appBarColor,
                      onPressed: () async {
                        await Navigator.pushNamed(
                          context,
                          _routes.dishUploadPageRoute,
                        );
                      },
                    ),
                  ],
                );
              } else if (index == 2) {
                return watch(userDataStreamProvider).when<Widget>(
                  data: (userData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Score: ${userData.score}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => LinearProgressIndicator(),
                  error: (error, stackTrace) {
                    print(error);
                    print(stackTrace);
                    return Text(
                      'Something went wrong in retrieving the score...',
                    );
                  },
                );
              }
              final dish = dishes[index - 3];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      dish.photoUrl,
                    ),
                  ),
                  title: Text(
                    dish.name,
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
