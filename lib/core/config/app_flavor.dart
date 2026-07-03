/// Native build flavor (set via `--dart-define=APP_FLAVOR=...`).
enum AppFlavor {
  development,
  production;

  static AppFlavor get current {
    const flavorName = String.fromEnvironment(
      'APP_FLAVOR',
      defaultValue: 'development',
    );
    return AppFlavor.values.byName(flavorName);
  }

  String get displayName => switch (this) {
        AppFlavor.development => 'Movie Universe Dev',
        AppFlavor.production => 'Movie Universe',
      };

  String get envFileName => switch (this) {
        AppFlavor.development => '.env.development',
        AppFlavor.production => '.env.production',
      };
}
