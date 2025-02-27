// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_print, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:warehouse/page_returned_order/layout/detail_returned_order.dart';
import 'package:warehouse/page_returned_order/widget/dialog_Widget.dart';

import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';

class ReturnedOrderView extends StatefulWidget {
  const ReturnedOrderView({super.key});

  @override
  State<ReturnedOrderView> createState() => _ReturnedOrderViewState();
}

class _ReturnedOrderViewState extends State<ReturnedOrderView> {
  List<Map<String, dynamic>> returnedOrder = [];
  List<String> filters = [
    'All',
    'Failed',
    'Delivered',
  ];
  String selectedFilter = 'Failed';
  int _currentPage = 0;
  int _numPages = 10;

  final TextEditingController _searchFieldController = TextEditingController();
  final NumberPaginatorController _paginatorController =
      NumberPaginatorController();

  DateFormat? _myFormat;
  DateFormat? _myFormat2;
  String? _token;

  @override
  void initState() {
    super.initState();
    _myFormat = DateFormat('dd-MM-yyyy').add_Hms();
    _myFormat2 = DateFormat('dd-MM-yyyy');
    _getToken();
  }

  Future<void> _getToken() async {
    final String? token = await TokenUtil.getToken();
    setState(() {
      _token = token!;
    });
    if (token != null) {
      await fetchAPI(_token);
    }
  }

  Future<void> fetchAPI(String? token) async {
    if (token == null) {
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
      return;
    }
    String _mainBody = 'pre_sales_order_return';
    String _subDirectory = '/api/sale/order/return/list';

    // debugPrint('fetch Unacknowledged API');
    final String? _domainName = await TokenUtil.getDomainName();
    String domainName = _domainName!;

    String url = '$domainName$_subDirectory';
    final uri = Uri.parse(url);

    Map<String, String> params = {
      'limit_rows': '20',
      'page': (_currentPage + 1).toString()
    };

    // if (selectedFilter.toLowerCase() != 'all') {
    //   params['status'] = selectedFilter.toLowerCase();
    // }

    debugPrint('selectedFilter: $selectedFilter');
    debugPrint('_currentPage: $_currentPage');

    final newUri = uri.replace(queryParameters: params);
    debugPrint(newUri.toString());

    final request = http.Request(
      'GET',
      newUri,
    )..headers.addAll(
        {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

    request.body = jsonEncode(params);
    http.StreamedResponse response = await request.send();

    String stringResponse = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      debugPrint('response.statusCode: ${response.statusCode}');
      try {
        final json = jsonDecode(stringResponse);
        final List<dynamic> rows = json[_mainBody]['rows'];
        int count = json[_mainBody]['count'];

        if (count == 0) {
          count = 1;
        }

        _numPages = (count / 20).round();
        if (_numPages < (count / 20)) {
          _numPages++;
        }
        debugPrint('response.statusCode == 200 count: $count');
        debugPrint('response.statusCode == 200 _numPages: $_numPages');

        setState(() {
          returnedOrder = List<Map<String, dynamic>>.from(rows).toList();
        });
      } catch (e) {
        debugPrint('Failed to parse JSON: $e');
      }
    } else {
      debugPrint(
          'Failed to fetch Unacknowledged API. Status code: ${response.statusCode}');
      debugPrint('Error Body: ${stringResponse}');
      Navigator.pushNamed(context, AppRoutes.login);

      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      returnedOrder.clear(); // Clear the existing data
    });

    await Future.delayed(
      const Duration(seconds: 2),
    ); // Simulate a delay (replace with your actual data fetching logic)

    await fetchAPI(_token);
  }

  void _onSearchSubmitted(String query) {
    setState(() async {
      await fetchAPI(_token);
      _searchFieldController.text = query;

      // Filter allotments based on search text
      returnedOrder = returnedOrder.where((_returnedOrder) {
        final returnedOrderId = _returnedOrder['id'].toString().toLowerCase();
        final site = _returnedOrder['site_id'].toString().toLowerCase();
        final outletId = _returnedOrder['outlet_id'].toString().toLowerCase();
        final vanId = _returnedOrder['van_id'].toString().toLowerCase();
        final outletName = _returnedOrder['name'].toString().toLowerCase();
        final searchText = _searchFieldController.text.toLowerCase();

        return vanId.contains(searchText) ||
            outletName.contains(searchText) ||
            site.contains(searchText) ||
            outletId.contains(searchText) ||
            returnedOrderId.contains(searchText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          centerTitle: true,
          title: Text(
            'Returned Order',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: biruImran,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 20.0, right: 20),
                child: RichText(
                  text: TextSpan(
                      text: 'Home ',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pop();
                        },
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: textColorTertiary,
                      ),
                      children: [TextSpan(text: '> Returned Order')]),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: _onSearchSubmitted,
                          controller: _searchFieldController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'Search ...',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: greyColor, width: 2))),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _numPages == 1 ? 12 : 24,
            ),
            _numPages == 1 ?
            SizedBox() :
            SizedBox(
              width: (MediaQuery.of(context).size.width / 7) * 4,
              child: NumberPaginator(
                controller: _paginatorController,
                numberPages: _numPages,
                onPageChange: (index) async {
                  setState(() {
                    returnedOrder.clear();
                    _currentPage = index;
                  });
                  await fetchAPI(_token);
                },
                config: NumberPaginatorUIConfig(
                  buttonSelectedForegroundColor: white,
                  buttonUnselectedForegroundColor: textColorTertiary,
                  buttonSelectedBackgroundColor: biruImran,
                ),
                showNextButton: _numPages == 1 ? false : true,
                showPrevButton: _numPages == 1 ? false : true,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            // Text(selectedFilter),
            Expanded(
              child: SizedBox(
                child: RefreshIndicator(
                  color: colorFirst,
                  backgroundColor: Colors.transparent,
                  onRefresh: _refreshData,
                  child: _buildListView(selectedFilter),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget shimmerList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          period: const Duration(milliseconds: 800),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200]!,
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(50, 12, 50, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 60.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget showEmptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Add your Lottie animation widget here
          // Lottie.asset('assets/lottie/no_pending_list.json', width: 200, height: 400),
          Text(
            'No returned order list for now.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(String _filter) {

    _filter = _filter.toLowerCase();
    if (returnedOrder.isEmpty) {
      return FutureBuilder<void>(
        future: Future.delayed(const Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return showEmptyList();
          } else {
            return shimmerList(); // Display shimmer while waiting
          }
        },
      );
    }

    // Filter allotments based on search text
    List<Map<String, dynamic>> filteredReturnedOrder =
        returnedOrder.where((_returnedOrder) {
      final vanId = _returnedOrder['van_id'].toString().toLowerCase();
      final outletName = _returnedOrder['name'].toString().toLowerCase();
      final site = _returnedOrder['site_id'].toString().toLowerCase();
      final outletId = _returnedOrder['outlet_id'].toString().toLowerCase();
      final returnedOrderId = _returnedOrder['id'].toString().toLowerCase();
      final searchText = _searchFieldController.text.toLowerCase();

      return vanId.contains(searchText) ||
          outletName.contains(searchText) ||
          site.contains(searchText) ||
          outletId.contains(searchText) ||
          returnedOrderId.contains(searchText);
    }).toList();

    // debugPrint(filteredSalesOrder);
    // debugPrint(salesOrder);

    // if (_filter != 'all') {
    //   debugPrint('_filter : $_filter');
    //   filteredSalesOrder = filteredSalesOrder.where(
    //     (_salesOrder) {
    //       final String salesOrderStatus = _salesOrder['status'];
    //       return salesOrderStatus.startsWith(_filter);
    //     },
    //   ).toList();
    // }

    return ListView.builder(
      itemCount: filteredReturnedOrder.length,
      itemBuilder: (context, index) {
        final _returnedOrder = filteredReturnedOrder[index];
        final _returnedOrderId = _returnedOrder['id'];

        final _siteId = _returnedOrder['site_id'];
        final _vanId = _returnedOrder['van_id'];
        final _outletId = _returnedOrder['outlet_id'];

        final _awb = _returnedOrder['awb'];
        final _outletName = _returnedOrder['name'];
        final _status = _returnedOrder['status'] ?? _returnedOrder['awb'];
        final _wms_status = _returnedOrder['wms_status'] ?? _returnedOrder['awb'];

        final _soDate = _returnedOrder['so_date'];
        final _deliveryDate = _returnedOrder['delivery_date'] ?? 'NNN';
        final _createdAt = _returnedOrder['created_at'];

        var _rejectionReason = _returnedOrder['rejection_reason'] ?? 'No reason attached';
        if (_status == 'delivered') {
          _rejectionReason = 'NNN';
        }

        return _buildListTile(
            index,
            _returnedOrderId,
            _siteId,
            _vanId,
            _outletId,
            _outletName,
            _awb,
            _status,
            _wms_status,
            _soDate,
            _createdAt,
            _deliveryDate,
            _rejectionReason,
          );
      },
      // controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }

  Widget _buildListTile(
    int index,
    String returnedOrderId,
    String siteId,
    String vanId,
    String outletId,
    String outletName,
    String awb,
    String status,
    String wms_status,
    String soDate,
    String createdAt,
    String deliveryDate,
    String rejectionReason,
  ) {
    DateTime soDateParsed = DateTime.parse(soDate);
    soDate = _myFormat2!.format(soDateParsed);
    DateTime createdAtParsed = DateTime.parse(createdAt).add(Duration(hours: int.parse('8')));
    createdAt = _myFormat!.format(createdAtParsed);

    if (deliveryDate != 'NNN') {
      DateTime deliveryDateParsed = DateTime.parse(deliveryDate).add(Duration(hours: int.parse('8')));
      deliveryDate = _myFormat!.format(deliveryDateParsed);
    }

    Color colorCheck(String _status) {
      switch (_status) {
        case 'failed':
          return colorMerah;
        case 'unacknowledged':
          return colorMerah;
        case 'delivered':
          return colorSecond; //biru
        default:
          return textColorSecondary;
      }
    }

    if (_currentPage != 0) {
      index = index + (20 * _currentPage);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(24.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [biruImran3, layoutBackgroundWhite],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    child: ListTile(
                      splashColor: white,
                      titleAlignment: ListTileTitleAlignment.titleHeight,
                      onTap: () async {
                        bool tempRefresh = false;
                        tempRefresh = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReturnedOrderDetail(
                              returnedOrderId: returnedOrderId,
                              siteId: siteId,
                              vanId: vanId,
                              outletId: outletId,

                              outletName: outletName,
                              status: status,
                              awb: awb,

                              soDate: soDate,
                              deliveryDate: deliveryDate,
                              createdAt: createdAt,

                              rejectionReason: rejectionReason,
                            ),
                          ),
                        );
                        if (tempRefresh) {
                          setState(() {
                            returnedOrder.clear();
                            tempRefresh = false;
                          });
                          await fetchAPI(_token);
                        }
                      },
                      leading: CircleAvatar(
                        maxRadius: 10,
                        backgroundColor: Colors.transparent,
                        child: Text(
                          '${index + 1}',
                          style:
                              const TextStyle(color: biruImran, fontSize: 14),
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              child: AutoSizeText(
                                maxLines: 1,
                                returnedOrderId,
                                style: const TextStyle(
                                  color: biruImran,
                                  fontSize: 21.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 110,
                            child: RichText(
                              text: TextSpan(
                                  text: 'Van ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: black,
                                    fontSize: 16.0,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: vanId,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'Site ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: black,
                                  fontSize: 16.0,
                                ),
                                children: [
                                  TextSpan(
                                    text: siteId,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width / 7) * 2.5,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: AutoSizeText(
                                '$outletName | $outletId',
                                maxLines: 2,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.end,
                            text: TextSpan(
                                text: 'Created At\n',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: black,
                                  fontSize: 15.0,
                                ),
                                children: [
                                  TextSpan(
                                    text: createdAt,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.21,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Expanded(
                      //   flex: 1,
                      //   child: Icon(
                      //     Icons.circle_rounded,
                      //     size: 8,
                      //     color: colorCheck(status),
                      //   ),
                      // ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context, // Make sure to have access to the BuildContext
                              builder: (BuildContext context) {
                                return DialogInfo(
                                  returnedOrderId: returnedOrderId,
                                  status: status,
                                  info: status == 'delivered' ? deliveryDate : rejectionReason,
                                  );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.info,
                            // size: MediaQuery.of(context).size.width >= 800 ? 30 : 15,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: AutoSizeText(
                          wms_status.capitalize(),
                          // 'Status',
                          maxLines: 1,
                          style: TextStyle(
                              color: colorCheck(wms_status),
                              fontWeight: FontWeight.w500,
                              fontSize: MediaQuery.of(context).size.width >= 800 ? 12 : 10
                              ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
