import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/config/app_environment.dart';

void main() {
  group('EnvironmentConfig', () {
    test('fromEnv uses development defaults when vars are missing', () {
      final config = EnvironmentConfig.fromEnv(const {});

      expect(config.environment, AppEnvironment.development);
      expect(config.apiBaseUrl, EnvironmentConfig.defaultApiBaseUrl);
      expect(config.imageBaseUrl, EnvironmentConfig.defaultImageBaseUrl);
      expect(config.enableNetworkLogging, isTrue);
    });

    test('fromEnv parses production and disables logging by default', () {
      final config = EnvironmentConfig.fromEnv(const {'APP_ENV': 'production'});

      expect(config.environment, AppEnvironment.production);
      expect(config.enableNetworkLogging, isFalse);
    });

    test('fromEnv reads custom base URLs', () {
      final config = EnvironmentConfig.fromEnv(const {
        'TMDB_BASE_URL': 'https://staging.example/api/v3',
        'TMDB_IMAGE_BASE_URL': 'https://staging.example/images/',
      });

      expect(config.apiBaseUrl, 'https://staging.example/api/v3');
      expect(config.imageBaseUrl, 'https://staging.example/images/');
    });

    test('test factory uses localhost defaults', () {
      final config = EnvironmentConfig.test();

      expect(config.environment, AppEnvironment.test);
      expect(config.apiBaseUrl, 'http://localhost:8080');
      expect(config.imageBaseUrl, 'http://localhost:8080/images/');
      expect(config.enableNetworkLogging, isFalse);
    });
  });
}
