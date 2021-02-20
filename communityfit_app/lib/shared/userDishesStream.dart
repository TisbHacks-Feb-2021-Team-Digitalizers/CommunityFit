import 'package:community_fit/models/dish.dart';
import 'package:community_fit/shared/databaseService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDishesStreamProvider =
    StreamProvider.autoDispose<List<Dish>>((ref) async* {
  final databaseService = await ref.watch(databaseServiceProvider.future);
  yield* databaseService.userDishesStream();
});
