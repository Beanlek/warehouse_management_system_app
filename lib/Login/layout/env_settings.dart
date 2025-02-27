// ignore_for_file: avoid_print, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/color.dart';

class EnvSettings extends StatefulWidget {
  const EnvSettings({super.key});

  @override
  State<EnvSettings> createState() => _EnvSettingsState();
}

class _EnvSettingsState extends State<EnvSettings> {
  String? _env;
  String? _domainName;
  bool? _isPROD;
  bool _successGetDomainName = false;

  @override
  void initState() {
    super.initState();
    _getDomainName();

    if (_successGetDomainName == true) {
      print('_isPROD : $_isPROD');
      print('_env : $_env');
      print('_domainName : $_domainName');
      return;
    } else {
      _env = 'PROD';
      _domainName = 'https://pnvsales.amastsales.com';
      _isPROD = true;
    }
  }

  Future<void> _getDomainName() async {
    final String? thisDomainName = await TokenUtil.getDomainName();
    print('loading _getDomainName thisDomainName: $thisDomainName');

    if (thisDomainName == null) {
      print('_getDomainName return: false');
      setState(() {
        _successGetDomainName = false;
      });
      // return false;
    }

    if (thisDomainName == 'https://tnvsales.amastsales-sandbox.com') {
      _domainName = thisDomainName;
      _env = 'DEV';
      _isPROD = false;

      print(
          '_getDomainName _domainName: $_domainName (_env: $_env, _isPROD: $_isPROD)');
    } else if (thisDomainName == 'https://pnvsales.amastsales.com') {
      _domainName = thisDomainName;
      _env = 'PROD';
      _isPROD = true;

      print(
          '_getDomainName _domainName: $_domainName (_env: $_env, _isPROD: $_isPROD)');
    } else {
      print('_getDomainName return: false');
      setState(() {
        _successGetDomainName = false;
      });
      // return false;
    }

    print('_getDomainName return: true');
    setState(() {
      _successGetDomainName = true;
    });
    print('_successGetDomainName: $_successGetDomainName');
    // return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          // height: 250,
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text('Set your environment here.',
                    style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(_env ?? 'PROD',
                                style: TextStyle(fontSize: 32)),
                          ),
                          Switch(
                            value: _isPROD!,
                            onChanged: (value) {
                              setState(() {
                                print('switch value: $value ($_isPROD)');
                                print(
                                    'switch _domainName before: $_domainName ($_isPROD)');
                                _isPROD = value;
                                _env = _isPROD! ? 'PROD' : 'DEV';
                                _domainName = _isPROD!
                                    ? 'https://pnvsales.amastsales.com'
                                    : 'https://tnvsales.amastsales-sandbox.com';
                                print(
                                    'switch _domainName after: $_domainName ($_isPROD)');
                              });
                            },
                          ),
                          // SizedBox(
                          //   width: 10,
                          // )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(_domainName ?? 'https://pnvsales.amastsales.com',
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 24.0,
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('domainName', _domainName!);
                          print(
                              'env_settings.dart domainName changed: $_domainName');
                          // setState(() async {
                          //   await prefs.setString('domainName', _domainName!);
                          // });
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hijauImran3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 24.0,
                          ),
                        ),
                        child: Text(
                          'Apply',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
