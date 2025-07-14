// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, unnecessary_brace_in_string_interps, curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/presentation/blocs/warehouse_inventory/warehouse_bloc.dart';
import 'package:warehouse/presentation/views/page_homepage/component/local_components.dart';

import 'package:warehouse/presentation/views/page_homepage/widget/appbar_homepage.dart';
import 'package:warehouse/presentation/views/page_homepage/widget/dialog_Widget.dart';
import 'package:warehouse/presentation/views/page_login/layout/login.dart';
import 'package:warehouse/presentation/views/adhoc_process/adhoc_request_listing.dart';
import 'package:warehouse/presentation/views/adhoc_process/adhoc_return_listing.dart';
import 'package:warehouse/presentation/views/page_market_return/layout/market_return_list.dart';
import 'package:warehouse/presentation/views/page_mr_return_order/layout/mr_return_order_list.dart';
import 'package:warehouse/presentation/views/page_picking_list/layout/main_pick_list.dart';
import 'package:warehouse/presentation/views/page_returned_order/layout/main_returned_order.dart';
import 'package:warehouse/presentation/views/page_sales_order/layout/main_sales_order.dart';
import 'package:warehouse/presentation/views/page_stock_take/layout/main_stock_take.dart';
import 'package:warehouse/presentation/views/page_transfer_in/layout/transfer_in_list.dart';
import 'package:warehouse/presentation/views/page_transfer_inout/layout/transfer_inout_list.dart';
import 'package:warehouse/presentation/views/page_transfer_out/layout/transfer_out_list.dart';
import 'package:warehouse/presentation/views/warehouse_inventory/warehouse_inventory_screen.dart';
import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/presentation/views/stock_recon/list_recon.dart';
import 'package:warehouse/utils/utils.dart';
import 'package:warehouse/presentation/views/van_allotment/layout/allotment_listslookup.dart';

class HomepageV2 extends StatefulWidget {
  const HomepageV2({super.key});

  @override
  State<HomepageV2> createState() => _HomepageV2State();
}

class _HomepageV2State extends State<HomepageV2> with HomepageComponents {
  @override
  void initState() {
    debugPrint('homepage initstate');
    Completer<bool> _completer = Completer<bool>();
    bool _tokenStatus = false;

    tokenFuture = _completer.future;

    _getAppVersion();

    if (_completer.isCompleted == false) {
      _getTokenAndFetchCount(_completer).whenComplete(() {
        tokenFuture.then((value) {
          setState(() {
            _tokenStatus = value;
          });
          debugPrint('initstate _tokenStatus : ${_tokenStatus}');

          if (_tokenStatus == false) {
            debugPrint('initstate: Failed to fetch API.');
            Navigator.pushNamed(context, AppRoutes.login);

            FloatingSnackBar(
              message: 'Token Expired. Please login back to the system.',
              context: context,
            );
          } else {
            setState(() {
              launchLoading = false;
            });
          }
        });
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getTokenAndFetchCount(Completer _completer) async {
    if (_completer.isCompleted) {
      return;
    }
    debugPrint('_getTokenAndFetchCount initiated');
    final String? _token = await TokenUtil.getToken();
    final String? _username = await TokenUtil.getUsername();

    if (_token == null) {
      if (_completer.isCompleted == false) _completer.complete(false);
      return;
    }

    setState(() {
      token = _token;
      username = _username!;
    });

    await fetchData(_token, _completer);
  }

  Future<void> _refresh() async {
    Completer<bool> _completer = Completer<bool>();
    tokenFuture = _completer.future;
    bool _tokenStatus = false;

    DateTime tokenExpiryTimeParsed;

    debugPrint('refresh initiated : ${_tokenStatus}');

    final String? tokenExpiryTime = await TokenUtil.getTokenExpiryTime();
    tokenExpiryTimeParsed =
        DateTime.parse(tokenExpiryTime!).add(Duration(hours: int.parse('-4')));

    setState(() {
      launchLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));

    debugPrint('refresh _getTokenAndFetchCount initiated');

    if (_completer.isCompleted == false) {
      if (DateTime.now().isAfter(tokenExpiryTimeParsed)) {
        _completer.complete(false);
      } else {
        await _getTokenAndFetchCount(_completer);
      }

      tokenFuture.then((value) {
        debugPrint('refresh tokenFuture initiated');
        _tokenStatus = value;

        debugPrint('_tokenStatus : ${_tokenStatus}');

        if (_tokenStatus == false) {
          debugPrint('refresh: Failed to fetch API.');
          Navigator.pushNamed(context, AppRoutes.login);

          FloatingSnackBar(
            message: 'Token Expired. Please login back to the system.',
            context: context,
          );
        } else {
          launchLoading = false;
        }
      });
    }
  }

  Future<void> deleteDraft() async {
  if (token == null) {
    Navigator.pushNamed(context, AppRoutes.login);
    FloatingSnackBar(
      message: 'Token Expired. Please login back to the system.',
      context: context,
    );
    return;
  }

  final String? _domainName = await TokenUtil.getDomainName();
  String url = '${_domainName}/api/wms/warehouse_stock_take/delete_draft';
  final Dio dio = Dio();

  const String _mainBody = 'deletedDraft';

  try {
    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    ).timeout(const Duration(seconds: 3));

    int statusCode = response.statusCode ?? 0;

    if (statusCode == 200 || statusCode == 201) {
      final json = response.data;

      debugPrint("RESPONSE JSON :: ${json.toString()}");

      try {
        final List<dynamic> deletedDrafts = json[_mainBody];
        int count = deletedDrafts.length;

        debugPrint('Deleted drafts count: $count');
        debugPrint('Deleted drafts list: $deletedDrafts');

      } catch (e) {
        debugPrint('Failed to parse JSON: $e');
      }
    } else if (statusCode == 401 || statusCode == 403) {
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
        message: 'Token Expired. Please login back to the system.',
        context: context,
      );
      return;
    } else {
      debugPrint('Failed to delete drafts. Status code: $statusCode');
      debugPrint('Error Body: ${response.data}');
      FloatingSnackBar(
        message: 'Delete draft failed with status code: $statusCode',
        context: context,
      );
    }
  } on TimeoutException {
    const errMsg = 'This may be due to server hiccups. Please wait for a while.';
    FloatingSnackBar(
      message: 'Delete draft encountered an error. $errMsg',
      context: context,
    );
    Navigator.of(context).pop();
  } on DioException catch (e) {
    debugPrint("Dio ERROR :: ${e.toString()}");
    const errMsg = 'This may be due to server hiccups. Please wait for a while.';
    FloatingSnackBar(
      message: 'Delete draft encountered an error. $errMsg',
      context: context,
    );
    Navigator.of(context).pop();
  } catch (e) {
    debugPrint("ERROR :: ${e.toString()}");
    const errMsg = 'This may be due to server hiccups. Please wait for a while.';
    FloatingSnackBar(
      message: 'Delete draft encountered an error. $errMsg',
      context: context,
    );
    Navigator.of(context).pop();
  }
}


  Future<void> _getUserDetails(Completer _completer) async {
    if (_completer.isCompleted) {
      return;
    }
    debugPrint('_getUserDetails initiated');

    if (token == null) {
      if (_completer.isCompleted == false) _completer.complete(false);
      return;
    }

    String _subDirectory = '/api/user/self';

    final String? _domainName = await TokenUtil.getDomainName();
    String domainName = _domainName!;

    String url = '$domainName$_subDirectory';
    final uri = Uri.parse(url);

    final request = http.Request(
      'GET',
      uri,
    )..headers.addAll(
        {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

    http.StreamedResponse response = await request.send();

    String stringResponse = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final json = jsonDecode(stringResponse);

      setState(() {
        userDetails = Map<String, dynamic>.from(json);
        realUsername = userDetails['user']['name'];
      });

      if (_completer.isCompleted == false) _completer.complete(true);
    } else {
      if (_completer.isCompleted == false) _completer.complete(false);
    }
  }

  Future<void> _getAppVersion() async {
    appVersion = await TokenUtil.getAppVersion();
  }

  Future<void> fetchData(String? token, Completer _completer) async {
    if (_completer.isCompleted) {
      return;
    }
    debugPrint('fetchData initiated');
    if (token == null) {
      if (_completer.isCompleted == false) _completer.complete(false);
      return;
    }
    String _mainBody = 'wms_acknowledgment';
    String _vanReqBody = 'van_requests';
    String _subDirectory = '/api/wms/android-list';
    String _vanReqDirectory = '/api/wms/van_request/list';

    List<String> recordType = [
      ALLOT_PLAN,
      ALLOT_BALANCE,
      ALLOT_ADDITIONAL,
      MARKET_RETURN,
      RETURN_ORDER,
      ALLOT_REQUEST,
      ADHOC_RETURN,
      TRANSFER_IN,
      TRANSFER_OUT,
    ];

    final String? domainName = await TokenUtil.getDomainName();
    DateTime currentDate = DateTime.now();
    String formattedDate2 = DateFormat('yyyy-MM-dd').format(currentDate);
    debugPrint('formattedDate2:: $formattedDate2');

    for (var i = 0; i < (recordType.length) + 3; i++) {
      String rootUrl = '$domainName$_subDirectory?limit_rows=1';
      String url = rootUrl;

      if (i < recordType.length) {
        if (i == 3)
          // url = '${rootUrl}&type=${recordType[i]}&allotment_date=${formattedDate2}&status=unacknowledged';
          url = '${rootUrl}&type=${recordType[i]}&status=unacknowledged';
        else
          url = '${rootUrl}&type=${recordType[i]}&status=unacknowledged';
      } else if (i == recordType.length) {
        url = '${domainName}${_vanReqDirectory}?limit_rows=0&status=pending';
      } else if (i == recordType.length + 2) {
        url = '${rootUrl}&status=acknowledged';
      }

      final uri = Uri.parse(url);

      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          switch (i) {
            case 0:
              debugPrint(
                  "case $i: ${url} ${data[_mainBody]["count"].toString()}");

              allotPlanCount = data[_mainBody]["count"];
              break;
            case 1:
              debugPrint(
                  "case $i: ${url} ${data[_mainBody]["count"].toString()}");

              allotBalanceCount = data[_mainBody]["count"];
              break;
            case 2:
              debugPrint(
                  "case $i: ${url} ${data[_mainBody]["count"].toString()}");

              allotAdditionalCount = data[_mainBody]["count"];
              break;
            case 3:
              debugPrint(
                  "case $i: ${url} ${data[_mainBody]["count"].toString()}");

              marketReturnCount = data[_mainBody]["count"];
              break;
            case 4:
              debugPrint(
                  "case $i: ${url} ${data[_mainBody]["count"].toString()}");

              mrReturnOrderCount = data[_mainBody]["count"];
              break;
            case 5:
              debugPrint(
                  "case $i: ${url} ${data[_mainBody]["count"].toString()}");

              allotRequestCount = data[_mainBody]["count"];
              break;
            case 6:
              debugPrint(
                  "case $i: ${url} ${data[_mainBody]["count"].toString()}");

              adhocReturnCount = data[_mainBody]["count"];
              break;
            case 7:
              debugPrint(
                  "case $i: ${url} ${data[_mainBody]["count"].toString()}");

              transferInCount = data[_mainBody]["count"];
              break;
            case 8:
              debugPrint(
                  "case $i: ${url} ${data[_mainBody]["count"].toString()}");

              transferOutCount = data[_mainBody]["count"];
              break;
            case 9:
              debugPrint(
                  "case $i: ${url} ${data[_vanReqBody]["count"].toString()}");

              adhocRequestCount = data[_vanReqBody]["count"];
              break;
            case 10:
              debugPrint(
                  "case $i: ${url} ${data[_mainBody]["count"].toString()}");

              totalListing = data[_mainBody]["count"];
              break;
            default:
              // FOR ACKNOWLDEGE COUNT ONLY
              debugPrint(
                  "case default: acknowledgedCount: ${url} ${data[_mainBody]["count"].toString()}");
              debugPrint(
                  "case default: pendingCount: ${url} ${data[_mainBody]["count"].toString()}");

              acknowledgedCount = data[_mainBody]["count"];
              pendingCount = totalListing - acknowledgedCount;
              break;
          }
        });
        await fetchReconCount(token, _completer);
      } else {
        if (_completer.isCompleted == false) _completer.complete(false);
      }
    }
  }

  Future<void> fetchReconCount(String? token, Completer _completer) async {
    if (_completer.isCompleted) {
      return;
    }
    debugPrint('fetchReconCount initiated');
    if (token == null) {
      if (_completer.isCompleted == false) _completer.complete(false);
      return;
    }
    final String? domainName = await TokenUtil.getDomainName();
    String _subDirectory = '/api/reconciliation/wms/list';

    String url = '$domainName$_subDirectory?status=ready&limit_rows=1';
    final uri = Uri.parse(url);

    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        reconCount = data['data']['count'];
      });
      await fetchPickListCount(token, _completer);
      // await _getUserDetails(_completer);
    } else {
      if (_completer.isCompleted == false) _completer.complete(false);
    }
  }

  Future<void> fetchPickListCount(String? token, Completer _completer) async {
    if (_completer.isCompleted) {
      return;
    }
    debugPrint('fetchPickListCount initiated');
    if (token == null) {
      if (_completer.isCompleted == false) _completer.complete(false);
      return;
    }
    String _mainBody = 'picklists';
    String _subDirectory = '/api/picklist/android/list';

    final String? _domainName = await TokenUtil.getDomainName();
    String domainName = _domainName!;

    String url = '$domainName$_subDirectory?limit_rows=1';
    final uri = Uri.parse(url);

    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        picklistCount = data[_mainBody]['count'];
      });
      await fetchSalesOrderCount(token, _completer);
    } else {
      if (_completer.isCompleted == false) _completer.complete(false);
    }
  }

  Future<void> fetchSalesOrderCount(String? token, Completer _completer) async {
    if (_completer.isCompleted) {
      return;
    }
    debugPrint('fetchSalesOrderCount initiated');
    if (token == null) {
      if (_completer.isCompleted == false) _completer.complete(false);
      return;
    }
    String _mainBody = 'pre_sales_order';
    String _subDirectory = '/api/sale/order/list/all';

    final String? _domainName = await TokenUtil.getDomainName();
    String domainName = _domainName!;

    String url =
        '$domainName$_subDirectory?limit_rows=1&status=sent%20for%20picking';
    final uri = Uri.parse(url);

    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        salesOrderCount = data[_mainBody]['count'];
      });
      await fetchReturnOrderCount(token, _completer);
    } else {
      if (_completer.isCompleted == false) _completer.complete(false);
    }
  }

  Future<void> fetchReturnOrderCount(String? token, Completer _completer) async {
    if (_completer.isCompleted) {
      return;
    }
    debugPrint('fetchReturnOrderCount initiated');
    if (token == null) {
      if (_completer.isCompleted == false) _completer.complete(false);
      return;
    }
    String _mainBody = 'pre_sales_order_return';
    String _subDirectory = '/api/sale/order/return/list';

    final String? _domainName = await TokenUtil.getDomainName();
    String domainName = _domainName!;

    String url = '$domainName$_subDirectory?limit_rows=1';
    final uri = Uri.parse(url);

    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        returnOrderCount = data[_mainBody]['count'];
      });
      await fetchTinToutData(token, _completer);
    } else {
      if (_completer.isCompleted == false) _completer.complete(false);
    }
  }

  Future<void> fetchTinToutData(String? token, Completer _completer) async {
    if (_completer.isCompleted) {
      return;
    }
    debugPrint('fetchTinToutData initiated');
    if (token == null) {
      if (_completer.isCompleted == false) _completer.complete(false);
      return;
    }
    final String? domainName = await TokenUtil.getDomainName();

    const String _tInApi = '/api/tin_tout/transfer_in/list';
    const String _tOutApi = '/api/tin_tout/transfer_out/list';

    List<String> apiLists = [
      _tInApi,
      _tOutApi,
    ];

    for (var i = 0; i < apiLists.length; i++) {
      final api = apiLists[i];
      
      String rootUrl = '$domainName$api?limit_rows=1';
      String url = rootUrl;

      final uri = Uri.parse(url);

      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          switch (api) {
            case _tInApi:
              tInCount = int.parse(data['transferIn']["count"]);
              break;
            case _tOutApi:
              tOutCount = data['transferOut']["count"];
              break;
          }
        });
        await _getUserDetails(_completer);
      } else {
        if (_completer.isCompleted == false) _completer.complete(false);
      }
    }
  }

  Widget drawerItem(IconData icon, String title, void Function()? navigateTo) {
    return SizedBox(
      height: 60,
      width: widthScreen * 0.5,
      child: ListTile(
        leading: Icon(
          icon,
          color: biruImran4,
        ),
        title: Text(
          title,
          style: TextStyle(
              color: biruImran4, fontWeight: FontWeight.normal, fontSize: 24),
        ),
        onTap: navigateTo,
      ),
    );
  }

  TableRow accountTile(String title, String data) {
    TextStyle _thisStyle(double _fontSize, FontWeight _fontWeight) {
      return TextStyle(
          color: biruImran4, fontWeight: _fontWeight, fontSize: _fontSize);
    }

    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: SizedBox(
            height: 50,
            child: Text(
              title,
              textAlign: TextAlign.end,
              style: _thisStyle(18, FontWeight.w300),
            )),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: AutoSizeText(
          data,
          maxLines: 1,
          style: _thisStyle(20, FontWeight.normal),
        ),
      )
    ]);
  }

  Widget showAccountProfileWidget() {
    String userID = userDetails['user']['id'];
    String userName = userDetails['user']['name'];
    String userRole = userDetails['user']['role'];
    String userPhone = userDetails['user']['phone'];
    String userEmail = userDetails['user']['email'];
    // String sites = userDetails['sites'];

    return Center(
      child: SizedBox(
          width: widthScreen * 0.45,
          child: Table(
            border: TableBorder(
              verticalInside: BorderSide(
                  width: 1, color: biruImran2, style: BorderStyle.solid),
            ),
            columnWidths: {
              0: FractionColumnWidth(0.3),
              1: FractionColumnWidth(0.7)
            },
            children: [
              accountTile('ID', userID),
              accountTile('Name', userName.capitalize()),
              accountTile('Role', userRole),
              accountTile('Phone', userPhone),
              accountTile('Email', userEmail),
              // accountTile('Sites', sites),
            ],
          )),
    );
  }

  Widget showAllowedSitesWidget() {
    List<dynamic> sites = userDetails['sites'];

    return Center(
      child: SizedBox(
          width: widthScreen * 0.45,
          child: Table(
              border: TableBorder(
                verticalInside: BorderSide(
                    width: 1, color: biruImran2, style: BorderStyle.solid),
              ),
              columnWidths: {
                0: FractionColumnWidth(0.3),
                1: FractionColumnWidth(0.7)
              },
              children: sites.asMap().entries.map((site) {
                return accountTile('Site', site.value);
              }).toList())),
    );
  }

  Widget stockMovementTile(
    String tileImage,
    String title,
    int count,
    void Function() navigateToPage,
  ) {
    // count = count*100;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: navigateToPage,
        // onTap: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const AllotmentPlanListing()),
        //   );
        // },
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(24.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [biruImran, colorFirst],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: 200,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              child: Image.asset(
                                tileImage,
                                color: Colors.white,
                                // width: 110,
                                // height: 110,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              child: Text(
                                count < 1000
                                    ? '${count}'
                                    : NumberFormat.compact().format(count),
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  // SizedBox(height: 35),
                  Expanded(
                    child: SizedBox(
                      child: AutoSizeText(
                        title,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget stockMovementTileEmpty() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              color: Colors.transparent),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('d MMM y').format(currentDate);
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150.0),
          child: AppBarWidget(
            formattedDate: formattedDate,
            appVersion: appVersion ?? 'unknown',
            scaffoldKey: scaffoldKey,
          ),
        ),
        drawer: Drawer(
          width: widthScreen * 0.6,
          backgroundColor: biruImran,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade300,
                      child: Icon(
                        Icons.person_outline_sharp,
                        size: 50,
                        color: biruImran,
                      ),
                    ),
                    SizedBox(width: 5),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            realUsername.capitalize(),
                            style: TextStyle(fontSize: 28, color: white),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 19,
                                color: white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  color: white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: biruImran2,
                  height: 48,
                ),
                Expanded(
                    child: RawScrollbar(
                  radius: Radius.circular(10),
                  thickness: 2,
                  thumbColor: biruImran3,
                  thumbVisibility: true,
                  scrollbarOrientation: ScrollbarOrientation.left,
                  controller: drawerScrollController,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: drawerScrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        drawerItem(Icons.phone, 'Contact Us', () async {
                          await launchURL().whenComplete(() {
                            setState(() {
                              scaffoldKey.currentState!.closeDrawer();
                            });
                          });
                        }),
                        Stack(
                          children: [
                            Positioned(
                              right: 0,
                              top: 5,
                              child: Icon(
                                showAccountProfile
                                    ? Icons.arrow_drop_down
                                    : Icons.arrow_drop_up,
                                color: biruImran4,
                                size: 40,
                              ),
                            ),
                            drawerItem(Icons.person, 'Account Profile', () {
                              setState(() {
                                showAccountProfile = !showAccountProfile;
                                debugPrint(showAccountProfile.toString());
                              });
                            }),
                          ],
                        ),
                        showAccountProfile
                            ? SizedBox()
                            : showAccountProfileWidget(),
                        Stack(
                          children: [
                            Positioned(
                              right: 0,
                              top: 5,
                              child: Icon(
                                showAllowedSites
                                    ? Icons.arrow_drop_down
                                    : Icons.arrow_drop_up,
                                color: biruImran4,
                                size: 40,
                              ),
                            ),
                            drawerItem(Icons.house, 'Allowed Sites', () {
                              setState(() {
                                showAllowedSites = !showAllowedSites;
                                debugPrint(showAllowedSites.toString());
                              });
                            }),
                          ],
                        ),
                        showAllowedSites
                            ? SizedBox()
                            : showAllowedSitesWidget(),
                      ],
                    ),
                  ),
                )),
                Divider(
                  color: biruImran2,
                  height: 48,
                ),
                drawerItem(Icons.logout, 'Log Out', () async {
                  bool _confirmLogout = false;

                  _confirmLogout = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogLogOutConfirmation();
                    },
                  );
                  if (_confirmLogout) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('token');
                    await prefs.remove('tokenExpiryTime');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginView(),
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
        body: launchLoading == false
            ? RefreshIndicator(
                color: colorFirst,
                edgeOffset: 10,
                onRefresh: _refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Action Summary
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: const Text(
                                  'Actions Summary',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                height: 45,
                                child: IconButton(
                                  icon: Icon(
                                    showActionSummary
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      // debugPrint(showActionSummary);
                                      showActionSummary = !showActionSummary;
                                      // debugPrint(showActionSummary);
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          showActionSummary
                              ? actionSummary(
                                  pendingCount: pendingCount,
                                  acknowledgedCount: acknowledgedCount,
                                  totalListing: totalListing)
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      showActionSummary = !showActionSummary;
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      'Show more',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w300,
                                        color: textColorTertiary,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),

                      // Stock Movement
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: SizedBox(
                                  child: AutoSizeText(
                                    maxLines: 1,
                                    'Stock Movement',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                height: 45,
                                child: IconButton(
                                  icon: Icon(
                                      showStockMovement
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      size: 40),
                                  onPressed: () {
                                    setState(() {
                                      showStockMovement = !showStockMovement;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          showStockMovement
                              ? Center(
                                  child: SizedBox(
                                  width: widthScreen * 0.9,
                                  height: heightScreen * 0.4,
                                  child: GridView.builder(
                                      gridDelegate: gridDelegate,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        if (index == 0) {
                                          return stockMovementTile(
                                              'assets/homepage/icon_allotmentPlan.png',
                                              'Allotment\nMovements',
                                              allotPlanCount +
                                                  allotAdditionalCount +
                                                  allotBalanceCount +
                                                  allotRequestCount, () async {
                                            await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DialogStockMovement(
                                                  title: "Allotment",
                                                  counts: [
                                                    {
                                                      "allotmentPlan":
                                                          allotPlanCount
                                                    },
                                                    {
                                                      "allotmentBalance":
                                                          allotBalanceCount
                                                    },
                                                    {
                                                      "allotmentAdditional":
                                                          allotAdditionalCount
                                                    },
                                                    {
                                                      "allotmentRequest":
                                                          allotRequestCount
                                                    },
                                                  ],
                                                  routes: [
                                                    {
                                                      "allotmentPlan":
                                                          AllotmentListsLookup(
                                                        allotmentType:
                                                            ALLOT_PLAN,
                                                      )
                                                    },
                                                    {
                                                      "allotmentBalance":
                                                          AllotmentListsLookup(
                                                        allotmentType:
                                                            ALLOT_BALANCE,
                                                      )
                                                    },
                                                    {
                                                      "allotmentAdditional":
                                                          AllotmentListsLookup(
                                                        allotmentType:
                                                            ALLOT_ADDITIONAL,
                                                      )
                                                    },
                                                    {
                                                      "allotmentRequest":
                                                          AllotmentListsLookup(
                                                        allotmentType:
                                                            ALLOT_REQUEST,
                                                      )
                                                    },
                                                  ],
                                                );
                                              },
                                            );
                                          });
                                        } else if (index == 1) {
                                          return stockMovementTile(
                                              'assets/homepage/icon_adhocRequest.png',
                                              'Adhoc\nMovements',
                                              adhocRequestCount +
                                                  adhocReturnCount, () async {
                                            await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DialogStockMovement(
                                                  title: "Adhoc",
                                                  counts: [
                                                    {
                                                      "adhocRequest":
                                                          adhocRequestCount
                                                    },
                                                    {
                                                      "adhocReturn":
                                                          adhocReturnCount
                                                    },
                                                  ],
                                                  routes: [
                                                    {
                                                      "adhocRequest":
                                                          AdhocRequestListing()
                                                    },
                                                    {
                                                      "adhocReturn":
                                                          AdhocReturnListing()
                                                    },
                                                  ],
                                                );
                                              },
                                            );
                                          });
                                        } else if (index == 2) {
                                          return stockMovementTile(
                                              'assets/homepage/icon_marketReturn.png',
                                              'Market Return\nMovements',
                                              marketReturnCount + mrReturnOrderCount,

                                              () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return DialogStockMovement(
                                                      title: "Market Return",
                                                      counts: [
                                                        {
                                                          "marketReturn": marketReturnCount
                                                        },
                                                        {
                                                          "mrReturnOrder": mrReturnOrderCount
                                                        },
                                                      ],
                                                      routes: [
                                                        {
                                                          "marketReturn": MarketReturnListing()
                                                        },
                                                        {
                                                          "mrReturnOrder": MRReturnOrderListing()
                                                        },
                                                      ],
                                                    );
                                                  },
                                                );
                                              });
                                        } else if (index == 3) {
                                          return stockMovementTile(
                                              'assets/homepage/icon_stockRecon.png',
                                              'Stock\nRecon',
                                              reconCount, () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const StockReconViewListing()),
                                            );
                                          });
                                        } else if (index == 4) {
                                          return stockMovementTile(
                                              'assets/homepage/icon_transferInOut.png',
                                              'Transfer I/O \nMovements',
                                              tInCount + tOutCount + transferInCount + transferOutCount,
                                              
                                              () async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return DialogStockMovement(
                                                      title: "Transfer I/O",
                                                      counts: [
                                                        {"transferIn": tInCount},
                                                        {"transferOut": tOutCount},
                                                        {
                                                          "transferInOutAcknowledgement":
                                                              transferInCount +
                                                                  transferOutCount
                                                        },
                                                      ],
                                                      routes: [
                                                        {
                                                          "transferIn":
                                                              TransferInListing()
                                                        },
                                                        {
                                                          "transferOut":
                                                              TransferOutListing()
                                                        },
                                                        {
                                                          "transferInOutAcknowledgement":
                                                              TransferInOutListing()
                                                        },
                                                      ],
                                                    );
                                                  },
                                                );
                                          });
                                        } else {
                                          return SizedBox();
                                        }
                                      }),
                                ))
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      showStockMovement = !showStockMovement;
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      'Show more',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w300,
                                        color: textColorTertiary,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      
                      // Inventory Stock Take && Presales Order
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          child: AutoSizeText(
                                            maxLines: 1,
                                            'Inventory Stock Take',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        height: 45,
                                        child: IconButton(
                                          icon: Icon(
                                            showInventoryStockTake
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                            size: 40,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              showInventoryStockTake =
                                                  !showInventoryStockTake;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: ListTile(
                                          onTap: () {
                                            deleteDraft();
                                            Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BlocProvider(
                                                create: (_) => WarehouseBloc()..init(),
                                                child: const WarehouseStocksScreen(),
                                              ),
                                            ),
                                          );
                                          },
                                          title: Material(
                                            elevation: 3,
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                                // color: Colors.orange,
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.orange,
                                                    Color.fromARGB(
                                                        255, 255, 186, 82)
                                                  ],
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          24.0, 16, 24, 16),
                                                      child: SizedBox(
                                                        child: AutoSizeText(
                                                          "Warehouse Inventory",
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: biruImran),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Image.asset(
                                                    "assets/homepage/icon_warehouseStockTake.png",
                                                    width: 100,
                                                    height: 100,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                showInventoryStockTake
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: ListTile(
                                          onTap: () {
                                            deleteDraft();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StockTake(
                                                          type: 'Warehouse')),
                                            );
                                          },
                                          title: Material(
                                            elevation: 3,
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                                // color: Colors.orange,
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.orange,
                                                    Color.fromARGB(
                                                        255, 255, 186, 82)
                                                  ],
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          24.0, 16, 24, 16),
                                                      child: SizedBox(
                                                        child: AutoSizeText(
                                                          "Warehouse Stock Take",
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: biruImran),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Image.asset(
                                                    "assets/homepage/icon_warehouseStockTake.png",
                                                    width: 100,
                                                    height: 100,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            showInventoryStockTake =
                                                !showInventoryStockTake;
                                          });
                                        },
                                        child: Center(
                                          child: Text(
                                            'Show more',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w300,
                                              color: textColorTertiary,
                                            ),
                                          ),
                                        ),
                                      ),
                                showInventoryStockTake
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StockTake(
                                                          type: 'Van EOD')),
                                            );
                                          },
                                          title: Material(
                                            elevation: 3,
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(24.0),
                                                // color: Colors.orange,
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.orange,
                                                    Color.fromARGB(
                                                        255, 255, 186, 82)
                                                  ],
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          24.0, 16, 24, 16),
                                                      child: SizedBox(
                                                        child: AutoSizeText(
                                                          "Van EOD\nStock Take",
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: biruImran),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Image.asset(
                                                    "assets/homepage/icon_vanEODStockTake.png",
                                                    width: 100,
                                                    height: 100,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          child: AutoSizeText(
                                            maxLines: 1,
                                            'Presales Order',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        height: 45,
                                        child: IconButton(
                                          icon: Icon(
                                            showPresalesOrder
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                            size: 40,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              showPresalesOrder =
                                                  !showPresalesOrder;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                showPresalesOrder
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const PickListView(),
                                              ),
                                            );
                                          },
                                          title: Text(
                                            "Picking List",
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Color(0xff0F75BC)),
                                          ),
                                          leading: Icon(
                                            Icons.local_grocery_store,
                                            color: biruImran,
                                          ),
                                          trailing: picklistCount == 0
                                              ? null
                                              : CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor: colorMerah,
                                                  child: Text(
                                                    "${picklistCount}",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: white),
                                                  ),
                                                ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            showPresalesOrder =
                                                !showPresalesOrder;
                                          });
                                        },
                                        child: Center(
                                          child: Text(
                                            'Show more',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w300,
                                              color: textColorTertiary,
                                            ),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: 5,
                                ),
                                showPresalesOrder
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const SalesOrderView(),
                                              ),
                                            );
                                          },
                                          title: Text(
                                            "Sales Order List",
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Color(
                                                    0xff0F75BC) // Set the font size here
                                                ),
                                          ),
                                          leading: Icon(
                                            Icons.local_offer,
                                            color: biruImran,
                                          ),
                                          trailing: salesOrderCount == 0
                                              ? null
                                              : CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor: colorMerah,
                                                  child: Text(
                                                    "${salesOrderCount}",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: white),
                                                  ),
                                                ),
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 5,
                                ),
                                showPresalesOrder
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ReturnedOrderView(),
                                              ),
                                            );
                                            // FloatingSnackBar(
                                            //     message: 'Coming soon',
                                            //     context: context);
                                          },
                                          title: Text(
                                            "Returned Order",
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Color(0xff0F75BC)),
                                          ),
                                          leading: Icon(
                                            Icons.keyboard_return,
                                            color: biruImran,
                                          ),
                                          trailing: returnOrderCount == 0
                                              ? null
                                              : CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor: colorMerah,
                                                  child: Text(
                                                    "${returnOrderCount}",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: white),
                                                  ),
                                                ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                color: white,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(child: CircularProgressIndicator()),
              ),
      ),
    );
  }
}

class actionSummary extends StatelessWidget {
  actionSummary({
    super.key,
    required this.pendingCount,
    required this.acknowledgedCount,
    required this.totalListing,
  });

  final int pendingCount;
  int acknowledgedCount;
  final int totalListing;

  @override
  Widget build(BuildContext context) {
    Widget _actionSummaryTile(String subtitle, int count) {
      // count = count*10;

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 4.2,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                  child: Text(
                    count < 1000
                        ? '${count}'
                        : NumberFormat.compact().format(count),
                    style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800),
                  ),
                ),

                // const SizedBox(height: 5),
                SizedBox(
                  height: 30,
                  child: AutoSizeText(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, color: Color(0xff0F75BC)),
                  ),
                ),

                count < 1000
                    ? SizedBox()
                    : Text(
                        '${count} qty',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: biruImran),
                      ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _actionSummaryTile('Unacknowledged', pendingCount),
          const SizedBox(width: 20),
          _actionSummaryTile('Acknowledged', acknowledgedCount),
          const SizedBox(width: 20),
          _actionSummaryTile('Total Listing', totalListing),
        ],
      ),
    );
  }
}
