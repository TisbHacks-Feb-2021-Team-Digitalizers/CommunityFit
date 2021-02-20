import 'package:community_fit/services/database.dart';
import 'package:community_fit/shared/userState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseServiceProvider =
    FutureProvider.autoDispose<DatabaseService>((ref) async {
  final user = await ref.watch(userStateStreamProvider.last);
  ref.maintainState = true;
  return DatabaseService(
    user: user,
  );
});
