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
import 'package:warehouse/page_picking_list/layout/detail_pick_list.dart';
// import 'package:warehouse/page_sales_order/layout/detail_sales_order.dart';

import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/color.dart';

class PickListView extends StatefulWidget {
  const PickListView({super.key});

  @override
  State<PickListView> createState() => _PickListViewState();
}

class _PickListViewState extends State<PickListView> {
  List<Map<String, dynamic>> pickLists = [];
  List<String> filters = [
    'All',
    'Done-packing',
    'Sent-for-picking',
  ];
  String selectedFilter = 'All';
  int _currentPage = 0;
  int _numPages = 10;

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
    String _mainBody = 'picklists';
    String _subDirectory = '/api/picklist/android/list';
    
    final String? _domainName = await TokenUtil.getDomainName();
    String domainName = _domainName!;
    
    String url = '$domainName$_subDirectory?limit_rows=20&page=${_currentPage + 1}';

    if (selectedFilter != 'All') {
      // print('selectedFilter != \'All\' selectedFilter: $selectedFilter');
      // print('selectedFilter != \'All\' _currentPage: $_currentPage');

      String _thisFilter = selectedFilter;
      // if (selectedFilter == 'Sent-for-picking') {
      //   _thisFilter = selectedFilter.replaceAll(RegExp(r'[^\w\s]+'), '%20');
      //   print('_thisFilter: $_thisFilter');
      // }
      url = '$domainName$_subDirectory?limit_rows=20&page=${_currentPage + 1}&status=${_thisFilter.toLowerCase()}';
    }
    // print('selectedFilter: $selectedFilter');
    // print('_currentPage: $_currentPage');
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
          pickLists = List<Map<String, dynamic>>.from(rows).toList();
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
      pickLists.clear(); // Clear the existing data
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
      pickLists = pickLists.where((_pickLists) {
        final site = _pickLists['site_id'].toString().toLowerCase();
        final pickListsId = _pickLists['id'].toString().toLowerCase();
        final searchText = _searchFieldController.text.toLowerCase();

        return site.contains(searchText) ||
            pickListsId.contains(searchText);
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
            'Picklist',
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
                      children: [TextSpan(text: '> Picklist')]),
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
                            onChanged: (filter) async {
                              setState(
                                () {
                                  pickLists.clear();
                                  selectedFilter = filter!;
                                  _currentPage = 0;
                                  _paginatorController.currentPage = 0;
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
                    pickLists.clear();
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
            'No picklist for now.',
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
    if (pickLists.isEmpty) {
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
    List<Map<String, dynamic>> filteredPickLists =
        pickLists.where((_pickLists) {
      final site = _pickLists['site_id'].toString().toLowerCase();
      final pickListsId = _pickLists['id'].toString().toLowerCase();
      final searchText = _searchFieldController.text.toLowerCase();

      return site.contains(searchText) ||
          pickListsId.contains(searchText);
    }).toList();

    return ListView.builder(
      itemCount: filteredPickLists.length,
      itemBuilder: (context, index) {
        final _pickLists = filteredPickLists[index];
        final _pickListsId = _pickLists['id'];

        final _siteId = _pickLists['site_id'];
        final _status = _pickLists['status'];

        final _createdBy = _pickLists['created_by'];
        final _createdAt = _pickLists['created_at'];

        return _buildListTile(
          index,
          _pickListsId,
          _siteId,
          _status,
          _createdBy,
          _createdAt,
        );
      },
      // controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }

  Widget _buildListTile(
      int index,
      String pickListId,
      String siteId,
      String status,
      String createdBy,
      String createdAt,
    ) {
    DateTime dateTimeParsed =
        DateTime.parse(createdAt).add(Duration(hours: int.parse('8')));
    String dateCreatedAt = _myFormat!.format(dateTimeParsed);
    // return Text('$index $pickListId $status $dateCreatedAt');
    Color colorCheck(String _status) {
      switch (_status) {
        case 'sent for picking':
          return colorSecond;
        case 'done packing':
          return hijauImran2;
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PickListDetail(
                              pickListId: pickListId,
                              siteId: siteId,
                              status: status,
                              createdAt: dateCreatedAt
                            )
                          ),
                        );
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
                                pickListId,
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
                          ),
                          SizedBox(width: 10,),
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
