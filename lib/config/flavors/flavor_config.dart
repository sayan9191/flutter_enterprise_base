enum AppFlavor { dev, qa, stage, prod }

class FlavorConfig {
  const FlavorConfig({required this.flavor, required this.envFile, required this.appName});

  final AppFlavor flavor;
  final String envFile;
  final String appName;

  static FlavorConfig fromFlavor(AppFlavor flavor) {
    return switch (flavor) {
      AppFlavor.dev => const FlavorConfig(flavor: AppFlavor.dev, envFile: 'env/.env.dev', appName: 'BaseStructure Dev'),
      AppFlavor.qa => const FlavorConfig(flavor: AppFlavor.qa, envFile: 'env/.env.qa', appName: 'BaseStructure QA'),
      AppFlavor.stage => const FlavorConfig(flavor: AppFlavor.stage, envFile: 'env/.env.stage', appName: 'BaseStructure Stage'),
      AppFlavor.prod => const FlavorConfig(flavor: AppFlavor.prod, envFile: 'env/.env.prod', appName: 'BaseStructure'),
    };
  }
}
