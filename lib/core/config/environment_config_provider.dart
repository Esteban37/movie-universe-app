import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_environment.dart';

final environmentConfigProvider = Provider<EnvironmentConfig>((ref) {
  if (!dotenv.isInitialized) {
    return EnvironmentConfig.development();
  }
  return EnvironmentConfig.fromEnv(dotenv.env);
});
