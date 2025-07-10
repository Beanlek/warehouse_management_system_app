// ignore_for_file: library_private_types_in_public_api, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, use_build_context_synchronously

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
import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/presentation/views/stock_recon/recon_details.dart';
import 'package:warehouse/utils/utils.dart';

class StockReconViewListing extends StatefulWidget {
  const StockReconViewListing({super.key});

  @override
  _StockReconViewListingState createState() => _StockReconViewListingState();
}

class _StockReconViewListingState extends State<StockReconViewListing> {
  final List<String> filters = [
    'All',
    'Ready',
    'Pending',
    'Received',
  ];
  
  List<Map<String, dynamic>> recons = [];
  
  String selectedStatusFilter = 'Ready';
  int _currentPage = 0;
  int _numPages = 10;
  // int _numPages = 1;

  final TextEditingController _searchFieldController = TextEditingController();
  final NumberPaginatorController _paginatorController =
      NumberPaginatorController();

  DateFormat? _myFormat;
  String? _token;

  @override
  void initState() {
    super.initState();
    _myFormat = DateFormat('dd-MM-yyyy').add_Hms();
    _getToken();
  }

  @override
  void dispose() {
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

    String _subDirectory = '/api/reconciliation/wms/list';

    final String? _domainName = await TokenUtil.getDomainName();
    String domainName = _domainName!;

    String url = '$domainName$_subDirectory';
    final uri = Uri.parse(url);

    Map<String, String> params = {
      'limit_rows': '20',
      'page': (_currentPage + 1).toString(),
      'status': selectedStatusFilter.toLowerCase(),
    };
    

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
      try {
        final json = jsonDecode(stringResponse);
        final List<dynamic> rows = json['data']['rows'];
        String stringCount = json['data']['count'].toString();
        int count = int.parse(stringCount);

        if (count == 0) {
          count = 1;
        }

        _numPages = (count / 20).round();
        if (_numPages < (count / 20)) {
          _numPages++;
        }

        setState(() {
          recons = List<Map<String, dynamic>>.from(rows).toList();
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

  void _onSearchSubmitted(String query) {
    setState(() async {
      await fetchAPI(_token);
      _searchFieldController.text = query;

      // Filter reconciliation data based on search text and selected status filter
      recons = recons.where((recon) {
          final id = recon['id'].toString().toLowerCase();
          final vanId = recon['van_id'].toString().toLowerCase();
          final searchText = _searchFieldController.text.toLowerCase();

          return vanId.contains(searchText) ||
            id.contains(searchText);
        }).toList();
      });
  }

  Future<void> _refreshData() async {
    setState(() {
      recons.clear(); // Clear the existing data
    });

    await Future.delayed(
      const Duration(seconds: 2),
    ); // Simulate a delay (replace with your actual data fetching logic)

    await fetchAPI(_token);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          title: Text(
            'Stock Reconcilliation Lists',
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
                padding: EdgeInsets.only(left: 20, top: 24.0, right: 20),
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
                      children: [TextSpan(text: '> Stock Reconcilliation')]),
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: greyColor, width: 2)),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: DropdownButton<String>(
                            padding: EdgeInsets.only(right: 12, left: 12),
                            isExpanded: true,
                            value: selectedStatusFilter,
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
                            onChanged: (filter) async {
                              setState(
                                () {
                                  selectedStatusFilter = filter!;
                                  _currentPage = 0;
                                  _paginatorController.currentPage = 0;
                                  recons.clear();
                                },
                              );
                              await fetchAPI(_token);
                            },
                          ),
                        ),
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
                    recons.clear();
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
            
            Expanded(
              child: RefreshIndicator(
                color: colorFirst,
                backgroundColor: whiteColor,
                onRefresh: _refreshData,
                child: _buildListView(selectedStatusFilter),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Color colorCheck(String _status) {
    switch (_status) {
        case 'ready':
          return hijauImran;
        case 'pending':
          return category4Color;
        case 'received':
          return colorSecond;
        default:
          return textColorSecondary;
      }
  }

  // Builds the ListView to display allotment data
  Widget _buildListView(String _filter) {
    // Show shimmer if data is empty
    _filter = _filter.toLowerCase();
    if (recons.isEmpty) {
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
    List<Map<String, dynamic>> filteredRecon =
        recons.where((recon) {
      final id = recon['id'].toString().toLowerCase();
      final vanId = recon['van_id'].toString().toLowerCase();
      final searchText = _searchFieldController.text.toLowerCase();

      return vanId.contains(searchText) ||
          id.contains(searchText);
    }).toList();

    return ListView.builder(
      itemCount: filteredRecon.length,
      itemBuilder: (context, index) {
        final recon = filteredRecon[index];
        final reconId = recon['id'] ?? 'null';
        final siteId = recon['site_id'] ?? 'null';
        final vanId = recon['van_id'] ?? 'null';
        final salesDate = recon['sales_date'] ?? 'null';
        final clockOutDate = recon['planned_clockout_date'] ?? 'null';
        final status = recon['status'] ?? 'null';

        return _buildListTile(
          index,
          reconId,
          siteId,
          vanId,
          salesDate,
          clockOutDate,
          status,
        );
      },
      // controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }

  Widget showEmptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No ${selectedStatusFilter.toLowerCase()} list for now',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
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
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200]!,
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 16.0,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 200,
                    height: 12.0,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 80,
                    height: 12.0,
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

  // Builds an individual ListTile
  Widget _buildListTile(
    int index,
    String reconId,
    String siteId,
    String vanId,
    String salesDate,
    String clockOutDate,
    String status,
  ) {
    DateTime salesDateParsed = DateTime.parse(salesDate).add(Duration(hours: int.parse('8')));
    salesDate = _myFormat!.format(salesDateParsed);
    DateTime clockOutDateParsed = DateTime.parse(clockOutDate).add(Duration(hours: int.parse('8')));
    clockOutDate = _myFormat!.format(clockOutDateParsed);

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
                        debugPrint('RECON ID : $reconId');
                        tempRefresh = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReconDetailPage(
                                reconId: reconId,
                                status: status,
                                plannedClockOutDate: clockOutDate,
                              ),
                          ),
                        );
                        if (tempRefresh) {
                          setState(() {
                            recons.clear();
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
                                reconId,
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
                          SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                          RichText(
                            textAlign: TextAlign.end,
                            text: TextSpan(
                                text: 'Sales Date\n',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: black,
                                  fontSize: 15.0,
                                ),
                                children: [
                                  TextSpan(
                                    text: salesDate,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                          ),
                          RichText(
                            textAlign: TextAlign.end,
                            text: TextSpan(
                                text: 'Planned Clock Out\n',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: black,
                                  fontSize: 15.0,
                                ),
                                children: [
                                  TextSpan(
                                    text: clockOutDate,
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
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.circle_rounded,
                        size: 8,
                        color: colorCheck(status),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: AutoSizeText(
                          status.capitalize(),
                          maxLines: 1,
                          style: TextStyle(
                              color: colorCheck(status),
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      ),
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

