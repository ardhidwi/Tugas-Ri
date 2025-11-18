import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

void main() {
  runApp(const Sleeplify());
}

class Sleeplify extends StatelessWidget {
  const Sleeplify({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sleeplify",
      theme: AppTheme.defaultTheme,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
