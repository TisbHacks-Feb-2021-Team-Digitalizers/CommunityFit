import 'package:community_fit/constants/colors.dart';
import 'package:community_fit/models/userData.dart';
import 'package:community_fit/shared/userDishes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfilePage extends ConsumerWidget {
  final UserData user;
  const UserProfilePage({@required this.user});

  Future<void> _handleDishTileTap() async {}

  Container _userProfilePicture(UserData user) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
      ),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(
              user.photoUrl,
            ),
          ),
          Text(
            user.displayName.toString(),
            textScaleFactor: 1.5,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return RefreshIndicator(
      onRefresh: () {
        return context.refresh(
          userDishesProvider(user.uid),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text('View User Profile'),
          centerTitle: true,
        ),
        body: watch(userDishesProvider(user.uid)).when<Widget>(
          data: (dishes) {
            return ListView.builder(
              itemCount: dishes.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _userProfilePicture(user);
                }
                if (index == 1) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Score: ${user.score}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  );
                }
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: appBarColor,
                      backgroundImage: NetworkImage(
                        dishes[index - 2].photoUrl,
                      ),
                    ),
                    title: Text(
                      dishes[index - 2].name,
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.more_horiz,
                      ),
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
      ),
    );
  }
}
