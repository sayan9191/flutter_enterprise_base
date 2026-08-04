import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'environment.dart';

/// Manages environment lifecycle — load once at app startup per flavor.
class EnvironmentManager {
  EnvironmentManager._();
  static final EnvironmentManager instance = EnvironmentManager._();

  Environment? _environment;
  FeatureFlags? _featureFlags;

  Environment get environment {
    assert(_environment != null, 'Environment not loaded. Call load() first.');
    return _environment!;
  }

  FeatureFlags get featureFlags {
    assert(_featureFlags != null, 'Environment not loaded. Call load() first.');
    return _featureFlags!;
  }

  bool get isLoaded => _environment != null;

  Future<void> load({required String envFile}) async {
    await dotenv.load(fileName: envFile);
    _environment = EnvironmentLoader.fromDotEnv(dotenv.env);
    _featureFlags = FeatureFlags(environment: _environment!);
  }
}
