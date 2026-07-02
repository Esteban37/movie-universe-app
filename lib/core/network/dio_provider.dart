import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../config/environment_config_provider.dart';
import 'dio_client.dart';

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(environmentConfigProvider);
  return DioClient.create(config);
});
