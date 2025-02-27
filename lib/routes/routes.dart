import 'package:flutter/material.dart';
import 'package:warehouse/Homepage%20Re-design/homepage.dart';
import 'package:warehouse/Login/layout/login.dart';
import 'package:warehouse/Login/layout/env_settings.dart';

class AppRoutes {
  static const String homepage = 'home';
  static const String login = 'login';
  static const String envSettings = 'envSettings';


  static Map<String, WidgetBuilder> routes = {
    homepage: (context) => const HomepageV2(),
    login: (context) => const LoginView(),
    envSettings: (context) => const EnvSettings(),
  };
}
