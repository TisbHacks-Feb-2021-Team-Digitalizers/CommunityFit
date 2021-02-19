import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:community_fit/shared/userState.dart';

final databaseServiceProvider = FutureProvider.autoDispose<DatabaseService>(
  (ref) async {
    final user = await ref.watch(userStateStreamProvider.last);
    return DatabaseService(
      uid: user.uid,
    );
  },
);

class DatabaseService {
  final String uid;
  const DatabaseService({
    @required this.uid,
  });
}
