import 'package:community_fit/models/dish.dart';
import 'package:community_fit/shared/databaseService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDishesProvider =
    FutureProvider.autoDispose.family<List<Dish>, String>((ref, uid) async {
  final databaseService = await ref.watch(databaseServiceProvider.future);
  final dishes = await databaseService.getDishesByUser(uid);
  ref.maintainState = true;
  return dishes;
});
