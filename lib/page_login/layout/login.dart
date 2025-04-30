// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, avoid_print, use_build_context_synchronously, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final TextEditingController _usernameController = TextEditingController(text: 'SADMFirdaus');
  final TextEditingController _passwordController = TextEditingController(text: 'Fardaus2172001!');
  // final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String _appVersion = 'N.N.N';
  String _domainName = 'null';

  @override
  void initState() {
    debugPrint('login initstate');

    _getAppVersion();
    _getDomainName();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    _controller.forward();

    super.initState();
  }

  Future<void> _getAppVersion() async {
    final String? _thisAppVersion = await TokenUtil.getAppVersion();
    
    setState(() {
      _appVersion = _thisAppVersion!;
    });
  }

  Future<void> _getDomainName() async {
    final String? _thisDomainName = await TokenUtil.getDomainName();

    setState(() {
      _domainName = _thisDomainName!;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();
    final String? deviceID = await TokenUtil.getDeviceID();
    debugPrint('deviceID : ${deviceID}');

    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text;
    final password = _passwordController.text;

    String url = '$_domainName/api/auth/wms/login';

    final response = await http.post(
      Uri.parse(url),
      body: {
        "username": username,
        "password": password,
        "device_id": deviceID
      },
    );

    await prefs.remove('username'); // Remove previous username
    await prefs.setString('username', username); // Save new username

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final token = json.decode(response.body)['token'];
      String tokenExpiryTime = json.decode(response.body)['token_expiry_time'];
        
      debugPrint('login.dart tokenExpiryTime initialized: ${tokenExpiryTime}');

      await prefs.remove('token'); // Remove previous token
      await prefs.setString('token', token); // Save new token

      await prefs.remove('tokenExpiryTime');
      await prefs.setString('tokenExpiryTime', tokenExpiryTime);

      Navigator.pushNamed(context, AppRoutes.homepage);
      FloatingSnackBar(
          message: 'Login success, token and username saved.',
          context: context);
    } else {
      debugPrint("Token Expired: ${response.statusCode}");
      String _error = 'Please check your credentials';

      if (response.statusCode == 502) {
        _error = 'Error: 502 Bad Gateway';
      }

      FloatingSnackBar(message: 'Login Failed. $_error.', context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
        body: FadeTransition(
          opacity: _animation,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icon/icon_login.png',
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                    const SizedBox(height: 8.0),
                    AutoSizeText(
                      'V $_appVersion',
                      maxLines: 1,
                      style: TextStyle(color: greyColor, fontSize: 24),
                    ),
                    const SizedBox(height: 40.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            focusNode: _usernameFocusNode,
                            controller: _usernameController,
                            onSubmitted: (value) {
                              if (_usernameController.text.isNotEmpty) {
                                _passwordFocusNode.requestFocus();
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide(color: colorFirst),
                              ),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            focusNode: _passwordFocusNode,
                            controller: _passwordController,
                            onSubmitted: (value) {
                              if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                                debugPrint('run onsubmitted password');
                                _isLoading ? null : _login();
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide(color: colorFirst),
                              ),
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_isPasswordVisible,
                          ),
                          const SizedBox(height: 16.0),
                          _isLoading
                              ? const Column(
                                  children: [
                                    LinearProgressIndicator(
                                      color: colorFirst,
                                    ),
                                    SizedBox(height: 16.0),
                                  ],
                                )
                              : Container(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    // primary: colorFirst,
                                    // onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
                                      horizontal: 24.0,
                                    ),
                                    elevation: 5,
                                  ),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    //debug
                                    // final String? domainName =
                                    //     await TokenUtil.getDomainName();
                                    // debugPrint(
                                    //     'login.dart domainName before env: $domainName');
                                    //debug

                                    Navigator.pushNamed(
                                        context, AppRoutes.envSettings);
                                  },
                                  icon: Icon(Icons.settings))
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    AutoSizeText(
                      'Running on:\n$_domainName',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: black, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }
}
