import 'package:flutter/material.dart';
import 'package:warehouse/presentation/views/page_homepage/homepage.dart';
import 'package:warehouse/presentation/views/page_login/layout/login.dart';
import 'package:warehouse/presentation/views/page_login/layout/env_settings.dart';

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
