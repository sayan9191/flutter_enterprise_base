import 'package:base_structure/app/app.dart';
import 'package:base_structure/app/app_initializer.dart';
import 'package:base_structure/config/flavors/flavor_config.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await initializeApp(flavor: AppFlavor.stage);
  runApp(const App());
}
