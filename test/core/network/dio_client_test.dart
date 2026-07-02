import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/config/app_environment.dart';
import 'package:movie_universe_app/core/network/dio_client.dart';
import 'package:movie_universe_app/core/network/interceptors/logging_interceptor.dart';

void main() {
  group('DioClient', () {
    test('creates Dio instance with configured base URL', () {
      const config = EnvironmentConfig(
        environment: AppEnvironment.development,
        apiBaseUrl: 'https://api.example.test/v3',
        imageBaseUrl: EnvironmentConfig.defaultImageBaseUrl,
        enableNetworkLogging: true,
      );
      final dio = DioClient.create(config);

      expect(dio.options.baseUrl, 'https://api.example.test/v3');
    });

    test('creates Dio instance with timeouts configured', () {
      final dio = DioClient.create(EnvironmentConfig.development());

      expect(dio.options.connectTimeout, isNotNull);
      expect(dio.options.receiveTimeout, isNotNull);
    });

    test('adds logging interceptor only when enabled', () {
      final devDio = DioClient.create(EnvironmentConfig.development());
      expect(devDio.interceptors.whereType<LoggingInterceptor>(), isNotEmpty);

      const prodConfig = EnvironmentConfig(
        environment: AppEnvironment.production,
        apiBaseUrl: EnvironmentConfig.defaultApiBaseUrl,
        imageBaseUrl: EnvironmentConfig.defaultImageBaseUrl,
        enableNetworkLogging: false,
      );
      final prodDio = DioClient.create(prodConfig);
      expect(prodDio.interceptors.whereType<LoggingInterceptor>(), isEmpty);
    });
  });
}
