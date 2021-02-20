import 'package:community_fit/environmentConfig.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final environmentConfigProvider =
    Provider.autoDispose<EnvironmentConfig>((ref) {
  return EnvironmentConfig();
});
