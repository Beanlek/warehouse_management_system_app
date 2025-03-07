import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/utils/utils.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:http/http.dart' as http;
import 'package:warehouse/van_allotment/layout/allotment_detail.dart';

mixin AllotmentComponents<T extends StatefulWidget> on State<T> {
  String allotment_type = '';
  
  List<Map<String, dynamic>> allotments = [];
  List<String> filters = [
    ALL,
    ACKNOWLEDGED,
    UNACKNOWLEDGED,
  ];
  String selectedFilter = UNACKNOWLEDGED;
  int currentPage = 0;
  int numPages = 10;

  final TextEditingController searchFieldController = TextEditingController();
  final ScrollController mainScrollController = ScrollController();
  final NumberPaginatorController paginatorController = NumberPaginatorController();

  DateFormat? myFormat;
  String? tokenComponent;

   Future<void> getToken() async {
    final String? token = await TokenUtil.getToken();
    setState(() {
      tokenComponent = token!;
      // showPickLists = true;
    });
    if (token != null) {
      await fetchAPI(tokenComponent);
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
    String _mainBody = 'wms_van_ids';
    String _subDirectory = '/api/wms/van_ids';
    
    final String? _domainName = await TokenUtil.getDomainName();
    String domainName = _domainName!;

    String url = '$domainName$_subDirectory';
    final uri = Uri.parse(url);

    Map<String, String> params = {
      'limit_rows': '20',
      'page': (currentPage + 1).toString(),
      'type': allotment_type,
      'status': selectedFilter.toLowerCase(),
    };

    debugPrint('selectedFilter: $selectedFilter');
    debugPrint('currentPage: $currentPage');

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

    if (response.statusCode == 500) {
      const errMsg = 'This may due to server hickups. Please wait for a while.';

      FloatingSnackBar(
          message: '${titleCheck(allotment_type)} encounter an error ${response.statusCode}. $errMsg',
          context: context);

      Navigator.of(context).pop();
    }

    else if (response.statusCode == 403) {
      Navigator.pushNamed(context, AppRoutes.login);
      
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
    }

    else if (response.statusCode == 200) {
      try {
        final json = jsonDecode(stringResponse);
        final List<dynamic> wms_van_ids = json[_mainBody]['rows'];
        String stringCount = json[_mainBody]['count'];
        int count = int.parse(stringCount);

        if (count == 0) {
          count = 1;
        }

        numPages = (count / 20).round();
        if (numPages < (count / 20)) {
          numPages++;
        }

        setState(() {
          allotments = List<Map<String, dynamic>>.from(wms_van_ids).toList();
        });
      } catch (e) {
        debugPrint('Failed to parse JSON: $e');
      }
    } else {
      debugPrint('Failed to fetch Unacknowledged API. Status code: ${response.statusCode}');
      debugPrint('Error Body: ${stringResponse}');
      const errMsg = 'This may due to server hickups. Please wait for a while.';

      FloatingSnackBar(
          message: '${titleCheck(allotment_type)} encounter an error ${response.statusCode}. $errMsg',
          context: context);

      Navigator.of(context).pop();
    }
  }

  Future<void> refreshData() async {
    setState(() {
      allotments.clear(); // Clear the existing data
    });

    await Future.delayed(
      const Duration(seconds: 2),
    ); // Simulate a delay (replace with your actual data fetching logic)

    await fetchAPI(tokenComponent);
  }

  void onSearchSubmitted(String query) {
    setState(() async {
      await fetchAPI(tokenComponent);
      searchFieldController.text = query;

      // Filter allotments based on search text
      allotments = allotments.where((_allotments) {
        final vanId = _allotments['van_id'].toString().toLowerCase();
        final allotmentsId = _allotments['id'].toString().toLowerCase();
        final site = _allotments['site_id'].toString().toLowerCase();
        final recordType = _allotments['record_type'].toString().toLowerCase();
        final status = _allotments['status'].toString().toLowerCase();
        final searchText = searchFieldController.text.toLowerCase();

        return vanId.contains(searchText) ||
            allotmentsId.contains(searchText) ||
            site.contains(searchText) ||
            recordType.contains(searchText) ||
            status.contains(searchText);
      }).toList();
    });
  }

  Color colorCheck(String _status) {
    if (_status == ACKNOWLEDGED) {
      return hijauImran2;
    } else {
      return colorMerah;
    }
  }

  // Builds the ListView to display allotment data
  Widget buildListView(String _filter) {
    // Show shimmer if data is empty
    _filter = _filter.toLowerCase();
    if (allotments.isEmpty) {
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
    List<Map<String, dynamic>> filteredAllotments =
        allotments.where((_allotments) {
      final vanId = _allotments['van_id'].toString().toLowerCase();
      final allotmentsId = _allotments['id'].toString().toLowerCase();
      final site = _allotments['site_id'].toString().toLowerCase();
      final recordType = _allotments['record_type'].toString().toLowerCase();
      final status = _allotments['status'].toString().toLowerCase();
      final searchText = searchFieldController.text.toLowerCase();

      return vanId.contains(searchText) ||
          allotmentsId.contains(searchText) ||
          site.contains(searchText) ||
          recordType.contains(searchText) ||
          status.contains(searchText);
    }).toList();

    return ListView.builder(
      itemCount: filteredAllotments.length,
      itemBuilder: (context, index) {
        final allotment = filteredAllotments[index];

        final vanId = allotment['van_id'] ?? 'null';
        final allotmentId = allotment['id'] ?? 'null';
        final siteId = allotment['site_id'] ?? 'null';
        final recordType = allotment['record_type'] ?? 'null';
        final status = allotment['status'] ?? 'null';
        final createdAt = allotment['created_at'] ?? 'null';

        return buildListTile(
          index,
          tag: titleCheck(allotment_type),
          vanId: vanId,
          allotmentId: allotmentId,
          siteId: siteId,
          recordType: recordType,
          status: status,
          createdAt: createdAt,
        );
      },
      controller: mainScrollController,
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }

  Widget showEmptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No ${selectedFilter.toLowerCase()} list for now',
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
  Widget buildListTile(
    int index,
    {
      required String tag,
      required String vanId,
      required String allotmentId,
      required String siteId,
      required String recordType,
      required String status,
      required String createdAt,
    }
  ) {
    DateTime dateTimeParsed =
        DateTime.parse(createdAt).add(Duration(hours: int.parse('8')));
    String dateCreatedAt = myFormat!.format(dateTimeParsed);

    if (currentPage != 0) {
      index = index + (20 * currentPage);
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
                            builder: (context) => AllotmentDetailView(
                                allotmentId: allotmentId,
                                allotmentType: allotment_type,
                                status: status,
                                createdAt: dateCreatedAt,
                              ),
                          ),
                        );
                        if (tempRefresh) {
                          setState(() {
                            allotments.clear();
                            tempRefresh = false;
                          });
                          await fetchAPI(tokenComponent);
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
                                allotmentId,
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
                          AutoSizeText(
                            tag,
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: black,
                              fontSize: 18.0,
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