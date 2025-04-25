// ignore_for_file: avoid_print, use_build_context_synchronously, unused_field, library_private_types_in_public_api, prefer_const_constructors, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, non_constant_identifier_names, constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:warehouse/page_transfer_in/layout/transfer_in_detail.dart';
import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';

const String TYPE = TRANSFER_IN;

class TransferInListing extends StatefulWidget {
  const TransferInListing({super.key});

  @override
  _TransferInListingState createState() => _TransferInListingState();
}

class _TransferInListingState extends State<TransferInListing> {
  List<dynamic> transferInLists = [];
  List<Map<String, dynamic>> transferIns = [];
  Map filters = TI_filter;
  String selectedFilter = '';
  int _currentPage = 0;
  int _numPages = 10;

  final TextEditingController _searchFieldController = TextEditingController();
  final NumberPaginatorController _paginatorController =
      NumberPaginatorController();

  DateFormat? _myFormat;
  DateFormat the_date_format = DateFormat('yyyy-MM-dd');
  DateTime currentDate = DateTime.now();
  String stringDate = "null";
  String? _token;

  @override
  void initState() {
    super.initState();
    selectedFilter = filters.values.first;
    _myFormat = DateFormat('dd-MM-yyyy').add_Hms();
    stringDate = the_date_format.format(currentDate);

    _getToken();
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

  // Future<void> fetchAPI(String? token) async {
  //   if (token == null) {
  //     Navigator.pushNamed(context, AppRoutes.login);
  //     FloatingSnackBar(
  //         message: 'Token Expired. Please login back to the system.',
  //         context: context);
  //     return;
  //   }
  //   String _mainBody = 'wms_acknowledgment';
  //   String _subDirectory = '/api/tin_tout/transfer_in/list';
  //   //'/api/wms/android-list';

  //   // debugPrint('fetch Unacknowledged API');
  //   final String? _domainName = await TokenUtil.getDomainName();
  //   String domainName = _domainName!;

  //   String url = '$domainName$_subDirectory';
  //   final uri = Uri.parse(url);

  //   Map<String, String> params = {
  //     'page': (_currentPage + 1).toString(),
  //     'limit_rows': '20',
  //     //'type': TYPE,
  //     'status': filters.keys.firstWhere(
  //       (key) => filters[key] == selectedFilter,
  //       orElse: () => 'received',
  //     ),
  //   };

  //   debugPrint("stringDate: $stringDate");

  //   debugPrint('selectedFilter: $selectedFilter');
  //   debugPrint('_currentPage: $_currentPage');

  //   final newUri = uri.replace(queryParameters: params);
  //   debugPrint('The new URI is : ${newUri.toString()}');

  //   final request = http.Request(
  //     'GET',
  //     newUri,
  //   )..headers.addAll(
  //       {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );

  //   request.body = jsonEncode(params);
  //   http.StreamedResponse response = await request.send();

  //   String stringResponse = await response.stream.bytesToString();

  //   if (response.statusCode == 500) {
  //     const errMsg = 'This may due to server hickups. Please wait for a while.';

  //     FloatingSnackBar(
  //         message: '${titleCheck(TYPE)} encounter an error. $errMsg',
  //         context: context);

  //     Navigator.of(context).pop();
  //   } else if (response.statusCode == 200) {
  //     try {
  //       final json = jsonDecode(stringResponse);
  //       final List<dynamic> wms_van_ids = json[_mainBody]['rows'];
  //       transferInLists = List.from(wms_van_ids);
  //       int count = json[_mainBody]['count'];

  //       if (count == 0) {
  //         count = 1;
  //       }

  //       _numPages = (count / 20).round();
  //       if (_numPages < (count / 20)) {
  //         _numPages++;
  //       }

  //       setState(() {
  //         transferIns = List<Map<String, dynamic>>.from(wms_van_ids).toList();
  //       });
  //     } catch (e) {
  //       debugPrint('Failed to parse JSON: $e');
  //     }
  //   } else {
  //     debugPrint(
  //         'Failed to fetch Unacknowledged API. Status code: ${response.statusCode}');
  //     debugPrint('Error Body: ${stringResponse}');
  //     Navigator.pushNamed(context, AppRoutes.login);
  //     FloatingSnackBar(
  //         message: 'Token Expired. Please login back to the system.',
  //         context: context);
  //   }
  // }

  Future<void> fetchAPI(String? token) async {
    if (token == null) {
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
      return;
    }

    int statusCode = 505;
    
    final String? _domainName = await TokenUtil.getDomainName();
    String url = '${_domainName}/api/tin_tout/transfer_in/list';
    final Dio dio = Dio();

    String _mainBody = 'transferIn';

    Map<String, String> params = {
      'page': (_currentPage + 1).toString(),
      'limit_rows': '20',
      'status': filters.keys.firstWhere(
        (key) => filters[key] == selectedFilter,
        orElse: () => '',
      ),
    };

    try {
      debugPrint("URL :: $url, params: $params");
      final response = await dio.get(
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),

        url,
        queryParameters: params
      ).timeout(Duration(seconds: 3));

      statusCode = response.statusCode!;

      if (statusCode == 200 || statusCode == 201) {
        final json = response.data;

        try {

          debugPrint("RESPONSE JSON :: ${json.toString()}");
          
          final List<dynamic> wms_van_ids = json[_mainBody]['rows'];
          int count = int.parse(json[_mainBody]['count']);

          if (count == 0) {
            count = 1;
          }

          _numPages = (count / 20).round();
          if (_numPages < (count / 20)) {
            _numPages++;
          }

          setState(() {
            transferIns = List<Map<String, dynamic>>.from(wms_van_ids).toList();
          });
        } catch (e) {
          debugPrint('Failed to parse JSON: $e');
        }
      } else {
        debugPrint('Failed to fetch Unacknowledged API. Status code: ${response.statusCode}');
        debugPrint('Error Body: ${json}');

        Navigator.pushNamed(context, AppRoutes.login);
        FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context
        );
      }

    } on TimeoutException {
      
      const errMsg = 'This may due to server hickups. Please wait for a while.';

      FloatingSnackBar(
          message: '${titleCheck(TYPE)} encounter an error. $errMsg',
          context: context);

      Navigator.of(context).pop();

    } on DioException catch (e) {
      
      debugPrint("ERROR :: ${e.toString()}");
      const errMsg = 'This may due to server hickups. Please wait for a while.';

      FloatingSnackBar(
          message: '${titleCheck(TYPE)} encounter an error. $errMsg',
          context: context);

      Navigator.of(context).pop();

    } catch (e) {

      debugPrint("ERROR :: ${e.toString()}");
      const errMsg = 'This may due to server hickups. Please wait for a while.';

      FloatingSnackBar(
          message: '${titleCheck(TYPE)} encounter an error. $errMsg',
          context: context);

      Navigator.of(context).pop();
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      transferIns.clear(); // Clear the existing data
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

      // Filter transferIns based on search text
      transferIns = transferIns.where((_transferIns) {
        // final vanId = _transferIns['van_id'].toString().toLowerCase();
        final transferInsId = _transferIns['id'].toString().toLowerCase();
        final site = _transferIns['site_id'].toString().toLowerCase();
        final recordType = _transferIns['record_type'].toString().toLowerCase();
        final status = _transferIns['status'].toString().toLowerCase();
        final searchText = _searchFieldController.text.toLowerCase();

        return //vanId.contains(searchText) ||
            transferInsId.contains(searchText) ||
                site.contains(searchText) ||
                recordType.contains(searchText) ||
                status.contains(searchText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          title: Text(
            '${titleCheck(TYPE)} Lists',
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
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
                        children: [TextSpan(text: '> ${titleCheck(TYPE)}')]),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: biruImran,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                    ),
                    child: Text(
                      'Create Transfer In',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: white,
                      ),
                    ),
                    onPressed: () {
                      debugPrint("You're a frog now");
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
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
                            items: filters.values
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
                                  selectedFilter = filter!;
                                  _currentPage = 0;
                                  _paginatorController.currentPage = 0;
                                  transferIns.clear();
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
            _numPages == 1
                ? SizedBox()
                : SizedBox(
                    width: (MediaQuery.of(context).size.width / 7) * 4,
                    child: NumberPaginator(
                      controller: _paginatorController,
                      numberPages: _numPages,
                      onPageChange: (index) async {
                        setState(() {
                          transferIns.clear();
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
                child: _buildListView(selectedFilter),
              ),
            ),
          ],
        ),
      ),

      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   // linen_items.add("dummy002");
      //   showDialog(context: context, builder: (context) {
      //     return AlertDialog(
      //       content: SizedBox.square(
      //         dimension: 500,
      //         child: Center(child: Text(transferInLists.toString()),)
      //       ),
      //     );
      //   });
      // } ),
    );
  }

  Color colorCheck(String _status) {
    switch (_status){
      case 'received':
        return hijauImran2;
      case 'partially received':
        return category4Color;
      case 'in transit':
        return biruImran;
      default:
        return biruImran;
    }
    // if (_status == 'acknowledged') {
    //   return hijauImran2;
    // } else {
    //   return colorMerah;
    // }
  }

  // Builds the ListView to display transferIn data
  Widget _buildListView(String _filter) {
    // Show shimmer if data is empty
    _filter = _filter.toLowerCase();
    if (transferIns.isEmpty) {
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

    // Filter transferIns based on search text
    List<Map<String, dynamic>> filteredTransferIns =
        transferIns.where((_transferIns) {
      // final vanId = _transferIns['van_id'].toString().toLowerCase();
      final transferInsId = _transferIns['id'].toString().toLowerCase();
      final site = _transferIns['site_id'].toString().toLowerCase();
      final recordType = _transferIns['record_type'].toString().toLowerCase();
      final status = _transferIns['status'].toString().toLowerCase();
      final searchText = _searchFieldController.text.toLowerCase();

      return //vanId.contains(searchText) ||
          transferInsId.contains(searchText) ||
              site.contains(searchText) ||
              recordType.contains(searchText) ||
              status.contains(searchText);
    }).toList();

    return ListView.builder(
      itemCount: filteredTransferIns.length,
      itemBuilder: (context, index) {
        final transferIn = filteredTransferIns[index];

        final id = transferIn['id'] ?? 'null';
        final tid = transferIn['tid'] ?? 'null';
        final refId = transferIn['ref_id'] ?? 'null';
        final date = transferIn['date'] ?? 'null';
        final siteId = transferIn['site_id'] ?? 'null';
        final type = transferIn['type'] ?? 'null';
        final principal = transferIn['principal'] ?? 'null';
        final createdBy = transferIn['created_by'] ?? 'null';
        final status = transferIn['status'] ?? 'null';
        final remark = transferIn['remark'] ?? 'null';


        return _buildListTile(
          index,
          id,
          tid,
          refId,
          date,
          siteId,
          type,
          principal,
          createdBy,
          status,
          remark,
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
  Widget _buildListTile(
    int index,
    String transferInId,
    String tid,
    String refId,
    String createdAt,
    String siteId,
    String type,
    String principal,
    String createdBy,
    String status,
    String? comment,
  ) {
    DateTime dateTimeParsed =
        DateTime.parse(createdAt).add(Duration(hours: int.parse('8')));
    String dateCreatedAt = _myFormat!.format(dateTimeParsed);

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
                        debugPrint(transferInId);
                        bool tempRefresh = false;
                        tempRefresh = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransferInDetailView(
                              transferInId: transferInId,
                              status: status,
                            ),
                          ),
                        );
                        if (tempRefresh) {
                          setState(() {
                            transferIns.clear();
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
                                transferInId,
                                style: const TextStyle(
                                  color: biruImran,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
                      subtitle: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                titleCheck(TYPE),
                                maxLines: 1,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: black,
                                  fontSize: 18.0,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
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
                                  AutoSizeText(
                                    'Created by: $createdBy',
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: black,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                          Opacity(
                            opacity: .65,
                            child: Row(
                              children: [
                                Text(
                                  'Remark: ',
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: black,
                                  ),
                                ),
                                AutoSizeText(
                                  comment ?? 'No remark',
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: black,
                                  ),
                                  wrapWords: false,
                                  maxLines: 2,
                                  minFontSize: 1,
                                ),
                              ],
                            ),
                          )
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
                          (status == 'pending_wa_ack')?
                          'Pending WA Acknowledged' : status.capitalize(),
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
