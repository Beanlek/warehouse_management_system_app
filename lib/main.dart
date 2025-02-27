// ignore_for_file: must_be_immutable, avoid_print, unnecessary_brace_in_string_interps, no_leading_underscores_for_local_identifiers

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
// import 'package:warehouse/shared_preference/token.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String _initRoute;

  await checkToken().then((routeValue) async{
    _initRoute = routeValue;
    await _getAppVersion();
    await _getDeviceID();

    runApp(MyApp(initRoute: _initRoute,));
  });
}

Future<String> checkToken() async {
  final prefs = await SharedPreferences.getInstance();

  final String? token = await TokenUtil.getToken();
  final String? tokenExpiryTime = await TokenUtil.getTokenExpiryTime();
  final String? domainName = await TokenUtil.getDomainName();

  DateTime tokenExpiryTimeParsed;
  String initRoute = 'login';

  if (domainName == null) {
    await prefs.setString('domainName', 'https://pnvsales.amastsales.com');
  }

  if (token != null && tokenExpiryTime != null) {
    tokenExpiryTimeParsed = DateTime.parse(tokenExpiryTime).add(Duration(hours: int.parse('-4')));

    if (DateTime.now().isBefore(tokenExpiryTimeParsed)) {
      initRoute = 'home';
    }
  }
  return initRoute;
}

Future<void> _getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('appVersion', packageInfo.version);
}

Future<void> _getDeviceID() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  print('androidInfo.id.toString() : ${androidInfo.id.toString()}');

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('deviceID', androidInfo.id.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initRoute});

  final String initRoute;

  @override
  Widget build(BuildContext context) {
    print('main.dart initRoute : ${initRoute}');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    
    print('main.dart editedRoute : ${initRoute}');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
      initialRoute: initRoute,
      theme: ThemeData(
        fontFamily: 'Poppins'
      ),
    );
  }
}
