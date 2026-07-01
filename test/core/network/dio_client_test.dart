import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/network/dio_client.dart';

void main() {
  group('DioClient', () {
    test('creates Dio instance with correct base URL', () {
      final dio = DioClient.create();

      expect(dio.options.baseUrl, equals('https://api.themoviedb.org/3'));
    });

    test('creates Dio instance with timeouts configured', () {
      final dio = DioClient.create();

      expect(dio.options.connectTimeout, isNotNull);
      expect(dio.options.receiveTimeout, isNotNull);
    });

    test('creates Dio instance with interceptors', () {
      final dio = DioClient.create();

      expect(dio.interceptors.length, greaterThanOrEqualTo(3));
    });
  });
}
