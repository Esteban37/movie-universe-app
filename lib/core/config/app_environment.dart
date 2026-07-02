/// Application deployment environment.
enum AppEnvironment { development, staging, production, test }

/// Environment-specific configuration for networking and media URLs.
class EnvironmentConfig {
  const EnvironmentConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.imageBaseUrl,
    required this.enableNetworkLogging,
  });

  static const defaultApiBaseUrl = 'https://api.themoviedb.org/3';
  static const defaultImageBaseUrl = 'https://image.tmdb.org/t/p/';

  final AppEnvironment environment;
  final String apiBaseUrl;
  final String imageBaseUrl;
  final bool enableNetworkLogging;

  /// Builds config from environment variables (e.g. loaded via flutter_dotenv).
  factory EnvironmentConfig.fromEnv(Map<String, String> env) {
    final environment = _parseEnvironment(env['APP_ENV']);
    final apiBaseUrl = _readUrl(
      env['TMDB_BASE_URL'],
      _defaultApiBaseUrl(environment),
    );
    final imageBaseUrl = _readUrl(
      env['TMDB_IMAGE_BASE_URL'],
      defaultImageBaseUrl,
    );
    final enableNetworkLogging = _parseBool(
      env['ENABLE_NETWORK_LOGGING'],
      defaultValue: environment != AppEnvironment.production,
    );

    return EnvironmentConfig(
      environment: environment,
      apiBaseUrl: apiBaseUrl,
      imageBaseUrl: imageBaseUrl,
      enableNetworkLogging: enableNetworkLogging,
    );
  }

  /// Local development defaults.
  factory EnvironmentConfig.development() {
    return const EnvironmentConfig(
      environment: AppEnvironment.development,
      apiBaseUrl: defaultApiBaseUrl,
      imageBaseUrl: defaultImageBaseUrl,
      enableNetworkLogging: true,
    );
  }

  /// Automated test defaults (mock-friendly base URLs).
  factory EnvironmentConfig.test({
    String apiBaseUrl = 'http://localhost:8080',
    String imageBaseUrl = 'http://localhost:8080/images/',
  }) {
    return EnvironmentConfig(
      environment: AppEnvironment.test,
      apiBaseUrl: apiBaseUrl,
      imageBaseUrl: imageBaseUrl,
      enableNetworkLogging: false,
    );
  }

  static AppEnvironment _parseEnvironment(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'production' || 'prod' => AppEnvironment.production,
      'staging' || 'stage' => AppEnvironment.staging,
      'test' => AppEnvironment.test,
      _ => AppEnvironment.development,
    };
  }

  static String _defaultApiBaseUrl(AppEnvironment environment) {
    return switch (environment) {
      AppEnvironment.production ||
      AppEnvironment.staging ||
      AppEnvironment.development => defaultApiBaseUrl,
      AppEnvironment.test => 'http://localhost:8080',
    };
  }

  static String _readUrl(String? value, String fallback) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return fallback;
    }
    return trimmed;
  }

  static bool _parseBool(String? value, {required bool defaultValue}) {
    final trimmed = value?.trim().toLowerCase();
    if (trimmed == null || trimmed.isEmpty) {
      return defaultValue;
    }
    return trimmed == 'true' || trimmed == '1' || trimmed == 'yes';
  }
}
