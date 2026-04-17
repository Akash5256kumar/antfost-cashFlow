import 'package:flutter/material.dart';

import 'app/navigation/app_router.dart';
import 'app/navigation/app_routes.dart';
import 'app/config/app_strings.dart';
import 'app/theme/app_theme.dart';

void main() {
  runApp(const AntfostApp());
}

class AntfostApp extends StatelessWidget {
  const AntfostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
