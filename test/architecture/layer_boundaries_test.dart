import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('layer boundaries', () {
    test('domain layer does not import data or presentation', () {
      final violations = <String>[];

      for (final entity in Directory('lib/features')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.contains('/domain/'))
          .where((file) => file.path.endsWith('.dart'))) {
        final content = File(entity.path).readAsStringSync();
        if (content.contains('/data/') || content.contains('/presentation/')) {
          violations.add(entity.path);
        }
      }

      expect(violations, isEmpty, reason: violations.join('\n'));
    });

    test('presentation providers call use cases, not repositories directly', () {
      final violations = <String>[];
      final providerFiles = Directory('lib/features')
          .listSync(recursive: true)
          .whereType<File>()
          .where(
            (file) =>
                file.path.contains('/presentation/providers/') &&
                file.path.endsWith('.dart') &&
                !file.path.endsWith('_repository_provider.dart') &&
                !file.path.endsWith('_usecase_providers.dart'),
          );

      for (final file in providerFiles) {
        final content = File(file.path).readAsStringSync();
        if (RegExp(r'ref\.(read|watch)\(\s*\w*RepositoryProvider\s*\)')
            .hasMatch(content)) {
          violations.add(file.path);
        }
      }

      expect(violations, isEmpty, reason: violations.join('\n'));
    });

    test('search data layer does not import movies data layer', () {
      final violations = <String>[];

      for (final entity in Directory('lib/features/search/data')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
        final content = File(entity.path).readAsStringSync();
        if (content.contains('features/movies/data')) {
          violations.add(entity.path);
        }
      }

      expect(violations, isEmpty, reason: violations.join('\n'));
    });

    test('design system does not import feature layers', () {
      final violations = <String>[];

      for (final entity in Directory('lib/shared/design_system')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
        final content = File(entity.path).readAsStringSync();
        if (content.contains('features/')) {
          violations.add(entity.path);
        }
      }

      expect(violations, isEmpty, reason: violations.join('\n'));
    });

    test('search domain does not import movies domain entities', () {
      final violations = <String>[];

      for (final entity in Directory('lib/features/search/domain')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
        final content = File(entity.path).readAsStringSync();
        if (content.contains('features/movies/domain/entities/movie_entity')) {
          violations.add(entity.path);
        }
      }

      expect(violations, isEmpty, reason: violations.join('\n'));
    });

    test('movies and tv_shows domain layers do not cross-import', () {
      final violations = <String>[];

      for (final feature in ['movies', 'tv_shows']) {
        for (final entity in Directory('lib/features/$feature/domain')
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))) {
          final content = File(entity.path).readAsStringSync();
          final other = feature == 'movies' ? 'tv_shows' : 'movies';
          if (content.contains('features/$other/domain')) {
            violations.add(entity.path);
          }
        }
      }

      expect(violations, isEmpty, reason: violations.join('\n'));
    });

    test('movies and tv_shows presentation layers do not cross-import', () {
      final violations = <String>[];

      for (final feature in ['movies', 'tv_shows']) {
        for (final entity in Directory('lib/features/$feature/presentation')
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))) {
          final content = File(entity.path).readAsStringSync();
          final other = feature == 'movies' ? 'tv_shows' : 'movies';
          if (content.contains('features/$other/presentation')) {
            violations.add(entity.path);
          }
        }
      }

      expect(violations, isEmpty, reason: violations.join('\n'));
    });

    test('core domain layer does not import feature modules', () {
      final domainDir = Directory('lib/core/domain');
      if (!domainDir.existsSync()) return;

      final violations = <String>[];

      for (final entity in domainDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
        final content = File(entity.path).readAsStringSync();
        if (content.contains('features/')) {
          violations.add(entity.path);
        }
      }

      expect(violations, isEmpty, reason: violations.join('\n'));
    });
  });
}
