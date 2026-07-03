import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/config/app_flavor.dart';

void main() {
  group('AppFlavor', () {
    test('defaults to development', () {
      expect(AppFlavor.current, AppFlavor.development);
    });

    test('displayName matches environment branding', () {
      expect(
        AppFlavor.development.displayName,
        'Movie Universe Dev',
      );
      expect(
        AppFlavor.production.displayName,
        'Movie Universe',
      );
    });

    test('envFileName points to flavor-specific dotenv source', () {
      expect(
        AppFlavor.development.envFileName,
        '.env.development',
      );
      expect(
        AppFlavor.production.envFileName,
        '.env.production',
      );
    });
  });
}
