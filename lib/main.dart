import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Modules/Auth/controller/admin_login_controller.dart';
import 'package:racha_ruchi_admin_panel/Routes/app_pages.dart';
import 'package:racha_ruchi_admin_panel/Routes/app_routes.dart';
import 'package:racha_ruchi_admin_panel/firebase_options.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('❌ Firebase init error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Racha Ruchi Admin Panel",

      initialRoute: AppRoutes.LOGIN,

      getPages: AppPages.routes,

      // ONLY auth controller globally
      initialBinding: BindingsBuilder(() {
        Get.put<AdminLoginController>(AdminLoginController(), permanent: true);
      }),

      defaultTransition: Transition.fade,
    );
  }
}
