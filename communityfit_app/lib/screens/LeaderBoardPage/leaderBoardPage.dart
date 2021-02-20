import 'package:community_fit/models/userData.dart';
import 'package:community_fit/shared/topUsers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community_fit/constants/routes.dart' as _routes;

class LeaderBoardPage extends ConsumerWidget {
  Future<void> _handleUserTileTap(BuildContext context, UserData user) async {
    await Navigator.pushNamed(
      context,
      _routes.userProfilePageRoute,
      arguments: user,
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return watch(topUsersProvider).when(
      data: (users) {
        return Container(
          child: RefreshIndicator(
            onRefresh: () {
              return context.refresh(topUsersProvider);
            },
            child: Center(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(users[index].photoUrl),
                      ),
                      onTap: () => _handleUserTileTap(
                        context,
                        users[index],
                      ),
                      trailing: IconButton(
                        onPressed: () => _handleUserTileTap(
                          context,
                          users[index],
                        ),
                        icon: Icon(
                          Icons.more_horiz,
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            users[index].displayName,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) {
        return Text(
          error.toString(),
        );
      },
    );
  }
}
