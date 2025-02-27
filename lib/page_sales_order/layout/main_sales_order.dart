// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_print

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
import 'package:warehouse/page_sales_order/layout/detail_sales_order.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/color.dart';

class SalesOrderView extends StatefulWidget {
  const SalesOrderView({super.key});

  @override
  State<SalesOrderView> createState() => _SalesOrderViewState();
}

class _SalesOrderViewState extends State<SalesOrderView> {
  List<Map<String, dynamic>> salesOrder = [];
  List<String> filters = [
    'All',
    'Unconfirmed',
    'Confirmed',
    'Cancelled',
    'Add-to-picklist',
    'Sent-for-picking',
    'Failed',
    'Delivered',
    'In-transit',
  ];
  String selectedFilter = 'Sent-for-picking';
  int _currentPage = 0;
  int _numPages = 10;
  late int _isAWB;

  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchFieldController = TextEditingController();
  final NumberPaginatorController _paginatorController =
      NumberPaginatorController();

  DateFormat? _myFormat;
  String? _token;

  @override
  void initState() {
    super.initState();
    _isAWB = 0;
    _myFormat = DateFormat('dd-MM-yyyy').add_Hms();
    _getToken();
  }
  
  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _getToken() async {
    final String? token = await TokenUtil.getToken();
    setState(() {
      _token = token!;
      // showPickLists = true;
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
    String _mainBody = 'pre_sales_order';
    String _subDirectory = '/list/all';

    if (_isAWB == 1) {
      _subDirectory = '/awb/list';
      _mainBody = 'pre_sales_order_awb';
    }

    // print('fetch Unacknowledged API');
    final String? _domainName = await TokenUtil.getDomainName();
    String domainName = _domainName!;
    // String url = '$domainName/api/sale/order$_subDirectory?limit_rows=9999999';
    String url = '$domainName/api/sale/order$_subDirectory?limit_rows=20&page=${_currentPage + 1}';

    if (selectedFilter != 'All') {
      print('selectedFilter != \'All\' selectedFilter: $selectedFilter');
      print('selectedFilter != \'All\' _currentPage: $_currentPage');

      String _thisFilter = selectedFilter;
      if (selectedFilter == 'Sent-for-picking') {
        _thisFilter = selectedFilter.replaceAll(RegExp(r'[^\w\s]+'), '%20');
        print('_thisFilter: $_thisFilter');
      }
      url = '$domainName/api/sale/order$_subDirectory?limit_rows=20&page=${_currentPage + 1}&status=${_thisFilter.toLowerCase()}';
    }
    print('selectedFilter: $selectedFilter');
    print('_currentPage: $_currentPage');
    final uri = Uri.parse(url);

    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print('response.statusCode: ${response.statusCode}');
      try {
        final json = jsonDecode(response.body);
        final List<dynamic> rows = json[_mainBody]['rows'];
        int count = json[_mainBody]['count'];

        if (count == 0) {
          count = 1;
        }

        _numPages = (count / 20).round();
        if (_numPages < (count / 20)) {
          _numPages++;
        }
        print('response.statusCode == 200 count: $count');
        print('response.statusCode == 200 _numPages: $_numPages');

        setState(() {
          // print('salesOrder init');
          salesOrder = List<Map<String, dynamic>>.from(rows).toList();
          // print('salesOrder: $salesOrder');
        });
      } catch (e) {
        print('Failed to parse JSON: $e');
      }
    } else {
      print(
          'Failed to fetch Unacknowledged API. Status code: ${response.statusCode}');
      print('Error Body: ${response.body}');
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      salesOrder.clear(); // Clear the existing data
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
      salesOrder = salesOrder.where((_salesOrder) {
        String salesOrderStatus = '';
        final vanId = _salesOrder['van_id'].toString().toLowerCase();
        final outletName = _salesOrder['name'].toString().toLowerCase();
        final site = _salesOrder['site_id'].toString().toLowerCase();
        final outletId = _salesOrder['outlet_id'].toString().toLowerCase();
        final salesOrderId = _salesOrder['id'].toString().toLowerCase();

        _isAWB == 0 ? null :
        salesOrderStatus = _salesOrder['awb'].toString().toLowerCase();

        final searchText = _searchFieldController.text.toLowerCase();

        return vanId.contains(searchText) ||
            outletName.contains(searchText) ||
            site.contains(searchText) ||
            outletId.contains(searchText) ||
            salesOrderStatus.contains(searchText) ||
            salesOrderId.contains(searchText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        if (isKeyboardVisible == false) {
          _searchFocusNode.unfocus();
        }
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90),
            child: AppBar(
              centerTitle: true,
              title: Text(
                'Sales Order',
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
                          children: [TextSpan(text: '> Sales Order')]),
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
                              focusNode: _searchFocusNode,
                              onChanged: _onSearchSubmitted,
                              onEditingComplete: () => _searchFocusNode.unfocus(),
                              onTapOutside: (_) => _searchFocusNode.unfocus(),
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
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: greyColor, width: 2)),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: DropdownButton<String>(
                                padding: EdgeInsets.only(right: 12, left: 12),
                                isExpanded: true,
                                value: selectedFilter,
                                items: filters
                                    .map(
                                      (filter) => DropdownMenuItem<String>(
                                        alignment: AlignmentDirectional.centerEnd,
                                        value: filter,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: SizedBox(
                                            child: Text(
                                              filter,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: _isAWB == 0 ? (filter) async {
                                  setState(
                                    () {
                                      salesOrder.clear();
                                      selectedFilter = filter!;
                                      _currentPage = 0;
                                      _paginatorController.currentPage = 0;
                                    },
                                  );
                                  await fetchAPI(_token);
                                } : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width /5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('AWB',style: const TextStyle(fontSize: 18),),
                              Switch(
                                value: _isAWB == 0 ? false : true,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      _isAWB = 1;
                                    } else {
                                      _isAWB = 0;
                                    }
                                    _currentPage = 0;
                                    _paginatorController.currentPage = 0;
                                    salesOrder.clear();
        
                                    print('switch value: $value ($_isAWB)');
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      )
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
                        salesOrder.clear();
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
        );
      }
    );
  }

  Widget shimmerList() {
    print('_isAWB shimmerList(): $_isAWB');
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
            'No ${selectedFilter.toLowerCase()} list for now.',
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
    // Show shimmer if data is empty
    _filter = _filter.toLowerCase();
    if (salesOrder.isEmpty) {
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
    print('_isAWB _buildListView(): $_isAWB');

    // Filter allotments based on search text
    List<Map<String, dynamic>> filteredSalesOrder =
        salesOrder.where((_salesOrder) {
          String salesOrderStatus = '';
      final vanId = _salesOrder['van_id'].toString().toLowerCase();
      final outletName = _salesOrder['name'].toString().toLowerCase();
      final site = _salesOrder['site_id'].toString().toLowerCase();
      final outletId = _salesOrder['outlet_id'].toString().toLowerCase();
      final salesOrderId = _salesOrder['id'].toString().toLowerCase();

      _isAWB == 0 ? null :
      salesOrderStatus = _salesOrder['awb'].toString().toLowerCase();

      final searchText = _searchFieldController.text.toLowerCase();

      return vanId.contains(searchText) ||
          outletName.contains(searchText) ||
          site.contains(searchText) ||
          outletId.contains(searchText) ||
          salesOrderStatus.contains(searchText) ||
          salesOrderId.contains(searchText);
    }).toList();

    // print(filteredSalesOrder);
    // print(salesOrder);

    // if (_filter != 'all') {
    //   print('_filter : $_filter');
    //   filteredSalesOrder = filteredSalesOrder.where(
    //     (_salesOrder) {
    //       final String salesOrderStatus = _salesOrder['status'];
    //       return salesOrderStatus.startsWith(_filter);
    //     },
    //   ).toList();
    // }

    return ListView.builder(
      itemCount: filteredSalesOrder.length,
      itemBuilder: (context, index) {
        final _salesOrder = filteredSalesOrder[index];
        final _salesOrderId = _salesOrder['id'];

        final _siteId = _salesOrder['site_id'];
        final _vanId = _salesOrder['van_id'];
        final _outletId = _salesOrder['outlet_id'];

        final _outletName = _salesOrder['name'];
        final _status = _salesOrder['status'] ?? _salesOrder['awb'] ?? 'NULL';
        final _stockAvailability = _salesOrder['stock_availability'] ?? 'NNN';

        final _soDate = _salesOrder['so_date'];

        return _buildListTile(index, _salesOrderId, _siteId, _vanId, _outletId,
            _outletName ?? 'null', _status, _stockAvailability, _soDate);
      },
      // controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }

  Widget _buildListTile(
      int index,
      String salesOrderId,
      String siteId,
      String vanId,
      String outletId,
      String outletName,
      String status,
      String stockAvailability,
      String soDate) {
    DateTime dateTimeParsed =
        DateTime.parse(soDate).add(Duration(hours: int.parse('8')));
    String dateCreatedAt = _myFormat!.format(dateTimeParsed);
    // return Text('$index $pickListId $status $dateCreatedAt');
    Color colorCheck(String _status) {
      switch (_status) {
        case 'confirmed':
          return hijauImran2;
        case 'cancelled':
          return colorMerah;
        case 'failed':
          return colorMerah;
        case 'delivered':
          return colorSecond; //biru
        case 'in-transit':
          return category4Color; //oren
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
                            builder: (context) => SalesOrderDetail(
                              AWBCheck: _isAWB,
                              salesOrderId: salesOrderId,
                              siteId: siteId,
                              vanId: vanId,
                              outletId: outletId,
                              outletName: outletName,
                              status: status,
                              stockAvailability: stockAvailability,
                              soDate: dateCreatedAt,
                            ),
                          ),
                        );

                        if (tempRefresh) {
                          setState(() {
                            salesOrder.clear();
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
                                salesOrderId,
                                style: const TextStyle(
                                  color: biruImran,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 120,
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
                            width: (MediaQuery.of(context).size.width / 7) * 3,
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
                                    text: dateCreatedAt,
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
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(
                            _isAWB == 0 ? Icons.circle_rounded : Icons.check,
                            size: _isAWB == 0 ? 8 : 20,
                            color: _isAWB == 0 ? colorCheck(status) : hijauImran,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: AutoSizeText(
                              _isAWB == 0 ? status.capitalize() : status,
                              maxLines: 2,
                              style: TextStyle(
                                  color: _isAWB == 0 ? colorCheck(status) : hijauImran,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      _isAWB == 0 ? RichText(
                        text: TextSpan(
                            text: 'Stock ',
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              color: black,
                              fontSize: 16.0,
                            ),
                            children: [
                              TextSpan(
                                text: stockAvailability,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ]),
                      ) : SizedBox(),
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
