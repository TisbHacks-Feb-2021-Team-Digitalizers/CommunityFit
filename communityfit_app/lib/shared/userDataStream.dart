import 'package:community_fit/models/userData.dart';
import 'package:community_fit/shared/databaseService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataStreamProvider =
    StreamProvider.autoDispose<UserData>((ref) async* {
  final databaseService = await ref.watch(databaseServiceProvider.future);
  final userDataStream = databaseService.userDataStream;
  ref.maintainState = true;
  yield* userDataStream;
});
