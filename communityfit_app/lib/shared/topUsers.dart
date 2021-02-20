import 'package:community_fit/models/userData.dart';
import 'package:community_fit/shared/databaseService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final topUsersProvider =
    FutureProvider.autoDispose<List<UserData>>((ref) async {
  final databaseService = await ref.watch(databaseServiceProvider.future);
  final firestoreUsers = await databaseService.getTopUsers();
  ref.maintainState = true;
  return firestoreUsers;
});
