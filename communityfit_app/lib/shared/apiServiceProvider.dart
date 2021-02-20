import 'package:community_fit/services/apiService.dart';
import 'package:community_fit/shared/configProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider.autoDispose<ApiService>((ref) {
  final environmentConfig = ref.watch(environmentConfigProvider);
  final apiService = ApiService(
    config: environmentConfig,
  );
  ref.maintainState = true;
  return apiService;
});
