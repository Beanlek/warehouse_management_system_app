// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_print, unnecessary_brace_in_string_interps, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:warehouse/page_picking_list/widget/dialog_Widget.dart';
import 'package:warehouse/page_picking_list/layout/pdf_screen.dart';

import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';

class PickListDetail extends StatefulWidget {
  const PickListDetail(
      {super.key,
      required this.pickListId,
      required this.siteId,
      required this.status,
      required this.createdAt});

  final String pickListId;
  final String siteId;
  final String status;
  final String createdAt;

  @override
  State<PickListDetail> createState() => _PickListDetailState();
}

class _PickListDetailState extends State<PickListDetail> {
  List<Map<String, dynamic>> SKUs = [];
  List<Map<String, dynamic>> SKUsToShow = [];
  Map<String, dynamic> filters = {
    "Sales Order" : [],
    "Van" : [],
  };
  List<DataRow> skuRow = [];
  final List<bool> _allIsPicked = [];
  
  String selectedFilter = 'All';
  String selectedFilterClass = 'All';

  Map<String, dynamic> picklistDetail = {};

  bool _somePicked = false;
  bool _allPicked = false;
  bool _isLoading = false;
  bool _showErrorOverlay = false;
  int batchCount = 0;

  final ScrollController _scrollController = ScrollController();
  final double dateCellHeight = 60;
  final DateFormat _myFormat = DateFormat('yyMMdd');
  final DateFormat _myFormat2 = DateFormat('dd-MM-yyyy').add_Hms();

  String? _token;
  String? _documentFilePath;

  @override
  void initState() {
    super.initState();
    _getToken();
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
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

    String _subDirectory = '/api/picklist/android/o';

    final String? _domainName = await TokenUtil.getDomainName();
    String domainName = _domainName!;

    String url = '$domainName$_subDirectory/${widget.pickListId}';
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

    if (response.statusCode == 500) {
      final json = jsonDecode(stringResponse);
      final errMsg = json['errMsg'];

      FloatingSnackBar(
          message: '${widget.pickListId} encounter an error. $errMsg',
          context: context);

      Navigator.of(context).pop();
    }

    else if (response.statusCode == 502) {
      final json = jsonDecode(stringResponse);
      final errMsg = json['errMsg'];

      FloatingSnackBar(
          message: '${widget.pickListId} encounter an error. $errMsg',
          context: context);

      Navigator.of(context).pop();
    }

    else if (response.statusCode == 200) {
      print('fetchApi status : 200');
      try {
        final json = jsonDecode(stringResponse);
        bool _alreadyHasFilterSO = false;
        bool _alreadyHasFilterVan = false;

        final List<dynamic> packing = json['packing'];
        final List<dynamic> batch = json['batch'];
        final picklist = json['picklist'];

        // print('packing.length : ${packing.length}');
        setState(() {
          batchCount = batch.length;
        });

        for (var i = 0; i < packing.length; i++) {
          final int _filterLengthSO = filters['Sales Order'].length;
          final int _filterLengthVan = filters['Van'].length;

          if (_filterLengthSO > 0) {
            for (var k = 0; k < _filterLengthSO; k++) {
              if (filters['Sales Order'][k] == packing[i]['pso_id']) {
                _alreadyHasFilterSO = true;
                k = filters['Sales Order'].length;

              } else {
                _alreadyHasFilterSO = false;
              }
            }
          }

          if (_alreadyHasFilterSO == false) {
            filters['Sales Order'].add(packing[i]['pso_id']);
          }

          if (_filterLengthVan > 0) {
            for (var k = 0; k < _filterLengthVan; k++) {
              if (filters['Van'][k] == packing[i]['van_id']) {
                _alreadyHasFilterVan = true;
                k = filters['Van'].length;

              } else {
                _alreadyHasFilterVan = false;
              }
            }
          }

          if (_alreadyHasFilterVan == false) {
            filters['Van'].add(packing[i]['van_id']);
          }
        }

        // print('inistate packing: $packing');
        // print('inistate filters: $filters');

        setState(() {
          print('fetchApi setState()');
          final int packingQty = packing.length;
          SKUs = List<Map<String, dynamic>>.from(packing).toList();
          print('packingQty : $packingQty');

          for (var i = 0; i < packingQty; i++) {
            final List<dynamic> _allot_details = SKUs[i]['allot_details'];
            final int skuQty = _allot_details.length;
            print('_allot_details : $_allot_details');

            for (var j = 0; j < skuQty; j++) {
              SKUs[i]['allot_details'][j].putIfAbsent(
                'pick_status', () => false
              );
              print('SKUs[$i][allot_details][$j] : ${SKUs[i]['allot_details'][j]}');
            }
          }
          picklistDetail = Map<String,dynamic>.from(picklist);
          setSKUsToShow();
        });
      } catch (e) {
        print('Failed to parse JSON: $e');
      }
    } else {
      print('Failed to fetch Unacknowledged API. Status code: ${response.statusCode}');
      print('Error Body: ${stringResponse}');
      // Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
    }
  }

  Future<void> printPage(String? token) async {
    if (token == null) {
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
      return;
    }

    String _subDirectory = '/a/report/bulk_picklist_android';
    DateTime currentDate = DateTime.now();
    String fileName = '${widget.pickListId}-${_myFormat.format(currentDate)}-document.pdf';
    print('fileName : $fileName');

    final String? _domainName = await TokenUtil.getDomainName();
    String domainName = _domainName!;

    String url = '$domainName$_subDirectory?report_id=${widget.pickListId}';
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
    
    Uint8List fileBytes = await response.stream.toBytes();
    // print('fileBytes : $fileBytes');

    // docFromAsset('assets/document/dummyDoc.pdf', 'dummyDoc.pdf').then((f) {
    //   setState(() {
    //     _documentFilePath = f.path;
    //   });
    // });
    docFromAPI(fileBytes, fileName).then((f) {
      setState(() {
        _documentFilePath = f.path;
        if (_documentFilePath != 'null') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFScreen(path: _documentFilePath!, fileName: fileName),
            ),
          );
        } else {
          FloatingSnackBar(
              message: 'Something went wrong. Please contact system admin',
              context: context,
            );
        }
      });
    });
    // print('_documentFilePath : $_documentFilePath');

  }

  Future<File> docFromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");

      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Future<File> docFromAPI(Uint8List fileBytes, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      
      await file.writeAsBytes(fileBytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Future<void> postPicked(String? token) async {
    if (token == null) {
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
      return;
    }
    
    final int _packingQty = SKUs.length;
    String _subDirectory = '/api/picklist/android/picking';
    Map<String, dynamic> dataReceive = {};
    Response response;
    String errMsg = 'null';
    int _skuCount = 0;

    final String? _domainName = await TokenUtil.getDomainName();
    String domainName = _domainName!;

    String url = '$domainName$_subDirectory/${widget.pickListId}';
    final uri = Uri.parse(url);

    for (var i = 0; i < _packingQty; i++) {
      final List<dynamic> _allot_details = SKUs[i]['allot_details'];
      final int _skuQty = _allot_details.length;

      for (var j = 0; j < _skuQty; j++) {
        if (_allot_details[j]['pick_status']) {
          dataReceive = {
            'sku_id' : _allot_details[j]['sku_id'],
            'uom_id' : _allot_details[j]['uom_id']
          };

          response = await http.post(
            uri,
            headers: 
              {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
            body: jsonEncode(dataReceive)
          );

          if (response.statusCode == 500) {
            errMsg = 'Error ${response.statusCode}. Error occured at SKU ${_allot_details[j]}';
          }

          else if (response.statusCode == 302) {
            errMsg = 'Error ${response.statusCode}. Error occured at SKU ${_allot_details[j]}';
          }

          else if (response.statusCode == 200) {
            errMsg = 'null';
            _allIsPicked[_skuCount] = true;
          }

          else {
            print('Failed to complete process. Status code: ${response.statusCode}');
            print('Error Body: ${response.body}');
            errMsg = 'Failed to complete process. Status code: ${response.statusCode}';
            // Navigator.pushNamed(context, AppRoutes.login);

            // FloatingSnackBar(
            //     message: 'Token Expired. Please login back to the system.',
            //     context: context,
            // );
          }
        }

        _skuCount++;
      }
    }

    if (errMsg != 'null') {
      FloatingSnackBar(
          message: errMsg,
          context: context,
      );
      return;
    }
    FloatingSnackBar(
        message: 'SKUs picked.',
        context: context,
    );
    setState(() {
      SKUsToShow.clear();
      fetchAPI(token);
    });
  }

  void setSKUsToShow() {
    if (selectedFilter != 'All') {
      SKUsToShow.clear();
      skuRow.clear();
      SKUsToShow = List<Map<String,dynamic>>.from(SKUs).where((_SKU) {

        final van_id = _SKU['van_id'].toString();
        final pso_id = _SKU['pso_id'].toString();

        return
          van_id.startsWith(selectedFilter) ||
          pso_id.startsWith(selectedFilter);

      }).toList();
    }
    else {
      SKUsToShow.clear();
      skuRow.clear();
      SKUsToShow = List<Map<String,dynamic>>.from(SKUs);
    }

    if (SKUsToShow.isEmpty) {
      FloatingSnackBar(
        message: 'Error: SKU is null. Please contact system admin.',
        context: context,
      );

      _showErrorOverlay = true;
      return;
    }

    final int packingQty = SKUsToShow.length;
    final TextStyle _thisStyle = TextStyle(
      fontSize: _responsiveFontSize(),
      fontWeight: FontWeight.w400,
      color: biruImran,
    );

    DataRow _singleSKURow;
    print('setSKUsToShow packingQty : ${packingQty}');

    for (var i = 0; i < packingQty; i++) {
      final List<dynamic> _allot_details = SKUsToShow[i]['allot_details'];
      final int skuQty = _allot_details.length;
      print('setSKUsToShow for 1 packingQty : ${skuQty}');


      for (var j = 0; j < skuQty; j++) {
        final String sku_id = _allot_details[j]['sku_id'];
        final String uom_id = _allot_details[j]['uom_id'];
        final int orderQty = _allot_details[j]['quantity'][0];
        final bool isPicked = _allot_details[j]['is_picked'] ?? false;

        if (_allIsPicked.length < batchCount) {
          _allIsPicked.add(isPicked);
        }

        SKUsToShow[i]['allot_details'][j].putIfAbsent(
          'pick_status', () => false
        );
        final bool pick_status = SKUsToShow[i]['allot_details'][j]['pick_status'];

        _singleSKURow = DataRow(cells: [
          DataCell(Text(sku_id, style: _thisStyle,)),
          DataCell(Text(uom_id, style: _thisStyle,)),
          DataCell(Text(orderQty.toString(), style: _thisStyle,)),
          DataCell(
            Center(
              child: RoundCheckBox(
                size: 30,
                isChecked: isPicked ? 
                  isPicked : _allPicked ? true : 
                    pick_status,
                onTap: isPicked ?
                null :
                (selected) {
                  setState(() {
                    SKUsToShow[i]['allot_details'][j]['pick_status'] = selected ?? false;
                    print('DataRow Picked : ${SKUsToShow[i]['allot_details'][j]}');
                  });
                  _setSomePicked();
                },
              ),
            ),
          ),
        ]);

        skuRow.add(_singleSKURow);
        print('SKUsToShow[$i][allot_details][$j] : ${SKUsToShow[i]['allot_details'][j]}');
      }
      
    }
    print('_allIsPicked : $_allIsPicked');
  }

  void _setSomePicked() {
    final int _packingQty = SKUs.length;
    _somePicked = false;
    List<bool> _selectAll = [];
    int _skuCount = 0;

    for (var i = 0; i < _packingQty; i++) {
      final List<dynamic> _allot_details = SKUs[i]['allot_details'];
      final int _skuQty = _allot_details.length;

      for (var j = 0; j < _skuQty; j++) {
        bool _isPicked = SKUs[i]['allot_details'][j]['is_picked'] ?? false;

        // print('_skuQty j = $j : $_skuQty');
        if (_selectAll.length < batchCount) {
          if (_isPicked) {
            _selectAll.add(true);
          }
          else {
            _selectAll.add(SKUs[i]['allot_details'][j]['pick_status']);
          }
        }
        
        if (SKUs[i]['allot_details'][j]['pick_status']) {
          setState(() {
            _somePicked = true;
            _selectAll[_skuCount] = true;
          });
          // return;
        }

        _skuCount++;
      }
    }

    print('_setSomePicked _selectAll : $_selectAll');

    if (_selectAll.every((e) => e==true)) {
      setState(() {
        _allPicked = true;
      });
    } else {
      setState(() {
        _allPicked = false;
      });
    }
  }
  
  void _setAllPicked(bool selected) {
    final int _packingQty = SKUsToShow.length;
    for (var i = 0; i < _packingQty; i++) {
      final List<dynamic> _allot_details = SKUsToShow[i]['allot_details'];
      final int _skuQty = _allot_details.length;

      for (var j = 0; j < _skuQty; j++) {
        
        setState(() {
          SKUsToShow[i]['allot_details'][j]['pick_status'] = selected;
          _allPicked = selected;
          _somePicked = selected;
        });
        
      }
    }
    setState(() {
      setSKUsToShow();
    });
    print('SKUsToShow _setAllPicked : $SKUsToShow');
  }

  double _responsiveFontSize() {
    final screenWidth = MediaQuery.of(context).size.width;
    const maxResolution = 1200.0;
    const maxSize = 26.0;

    return (screenWidth / maxResolution) * maxSize;
  }

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

  ListTile _buildDropDownItems(String data, String dataClass) {
    return ListTile(
        title: Align(alignment: Alignment.centerRight,
          child: Text(data,
            style: TextStyle(
              fontSize: _responsiveFontSize(),
              fontWeight: FontWeight.normal,
              color: biruImran
            ),
          ),
        ),
        onTap: () async {
          setState(() {
            selectedFilter = data;
            selectedFilterClass = dataClass;
          });
          setSKUsToShow();
          Navigator.pop(context, data);
        },
      );
  }

  Widget _buildDropDownMenu() {
    final int _filterLengthSO = filters['Sales Order'].length;
    final int _filterLengthVan = filters['Van'].length;
    List<Widget> _tile = [];

    _tile.add(_buildDropDownItems('All', 'All'));

    _tile.add(
      ListTile(
        title: Align(alignment: Alignment.centerRight,
          child: Text('\nSales Order',
            style: TextStyle(
              fontSize: _responsiveFontSize() - 2,
              fontWeight: FontWeight.w300,
              color: greyColor
            ),
          ),
        ),
      )
    );

    for (var i = 0; i < _filterLengthSO; i++) {
      _tile.add(_buildDropDownItems(filters['Sales Order'][i], 'Sales Order'));
    }

    _tile.add(
      ListTile(
        title: Align(alignment: Alignment.centerRight,
          child: Text('\nVan',
            style: TextStyle(
              fontSize: _responsiveFontSize() - 2,
              fontWeight: FontWeight.w300,
              color: greyColor
            ),
          ),
        ),
      )
    );

    for (var i = 0; i < _filterLengthVan; i++) {
      _tile.add(_buildDropDownItems(filters['Van'][i], 'Van'));
    }

    return Column(
          children: _tile
        );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double tableWidth = MediaQuery.of(context).size.width * 0.8;
    // final double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          centerTitle: true,
          title: AutoSizeText(
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
      body:
      _showErrorOverlay ?
      ERROR_OVERLAY() :
      WillPopScope(
        onWillPop: () async {
          if (_allIsPicked.every((e) => e == true)) {
            return true;
          }
          bool willPop = false;
          willPop = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogConfirmation();
            },
          );

          return willPop;
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 20.0, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Home ',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DialogConfirmation(toHome: true);
                                        },
                                      );
                                },
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                color: textColorTertiary,
                              ),
                              children: [
                                TextSpan(
                                  text: '> Picklist ',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Navigator.of(context).pop();
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DialogConfirmation();
                                        },
                                      );
                                    },
                                ),
                                TextSpan(
                                  text: '> ${widget.pickListId.toUpperCase()}',
                                ),
                              ],
                            ),
                          ),
                          widget.status == 'sent for picking' ?
                          IconButton(
                              onPressed: () async {
                                print('Acessing print button...');
                                setState(() {
                                  _isLoading = true;
                                });
        
                                await printPage(_token).whenComplete(() {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              },
                              icon: Icon(Icons.print, size: 32, color: biruImran,),
                            ) : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: widget.pickListId,
                                  style: TextStyle(
                                    color: biruImran,
                                    fontSize: _responsiveFontSize() * 2.5,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins'
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '\t\tSite',
                                      style: TextStyle(
                                        color: biruImran,
                                        fontSize: _responsiveFontSize(),
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\t${widget.siteId}',
                                      style: TextStyle(
                                        color: biruImran,
                                        fontSize: _responsiveFontSize() + 4,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                        SizedBox(
                          child: Row(
                                  children: [
                                    Icon(
                                      Icons.circle_rounded,
                                      size: 10,
                                      color: colorCheck(widget.status),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      widget.status.capitalize(),
                                      style: TextStyle(
                                        color: colorCheck(widget.status),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SKUsToShow.isEmpty ?
                  Expanded(child: Center(child: CircularProgressIndicator())) :
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  _buildCell('Created at', picklistDetail['createdAt'], dateCellHeight),
                                  _buildCell('Sent for picking at', picklistDetail['sent_for_picking_at'] ?? 'null', dateCellHeight),
                                  _buildCell('Started packing at', picklistDetail['started_packing_at'] ?? 'null', dateCellHeight),
                                  _buildCell('Done packing at', picklistDetail['done_packing_at'] ?? 'null', dateCellHeight),
                                ]
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 65, 
                                child: RichText(
                                  text: TextSpan(
                                    text: 
                                    selectedFilter == 'All' ?
                                      'All\n' : selectedFilterClass == 'Sales Order' ?
                                        '${SKUsToShow[0]['pso_id']}\n' :
                                        '${SKUsToShow[0]['van_id']}\n',
                                    style: TextStyle(
                                      fontSize: _responsiveFontSize() + 6,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Poppins',
                                      color: biruImran,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 
                                        selectedFilterClass != 'Sales Order' ?
                                          '' :
                                          SKUsToShow[0]['van_id'],
                                        style: TextStyle(
                                          fontSize: _responsiveFontSize() + 6,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Poppins',
                                          color: biruImran,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            
                              Expanded(
                                flex: 35, 
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: biruImran, width: 2)),
                                    child: PopupMenuButton(
                                      elevation: 0,
                                      color: Colors.transparent,
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          PopupMenuItem(
                                            child: Material(
                                              elevation: 5,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: white,
                                                  shape: BoxShape.rectangle
                                                ),
                                                width: screenWidth / 3,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                                  child: _buildDropDownMenu()
                                                ),
                                              ),
                                            ),
                                          ),
                                        ];
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: screenWidth * 0.2,
                                              child: AutoSizeText(
                                                selectedFilter,
                                                maxLines: 1,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontSize: _responsiveFontSize(),
                                                  fontWeight: FontWeight.normal,
                                                  color: biruImran
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down
                                            )
                                          ],
                                        ),
                                      )
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Expanded(
                            child: RawScrollbar(
                              radius: Radius.circular(10),
                              thickness: 8,
                              thumbColor: biruImran4,
                              thumbVisibility: true,
                              controller: _scrollController,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'SKU Details',
                                        style: TextStyle(
                                          fontSize: 28.0,
                                          fontWeight: FontWeight.bold,
                                          color: biruImran,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      _buildSKUTable(skuRow, tableWidth),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          
            _isLoading ? Opacity(opacity: 0.5,child: Container(
              color: white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator()),
              ),
            ) : SizedBox()
          ],
        ),
      ),
    ));
  }

  Widget _buildSKUTable(List<DataRow> _skuRow, double tableWidth) {

    return Column(
        children: [
          SizedBox(
            width: tableWidth,
            child: DataTable(
              dataRowMaxHeight: 60.0,
              border: TableBorder(
                horizontalInside: BorderSide(
                    width: 1, color: biruImran2, style: BorderStyle.solid),
                verticalInside: BorderSide(
                    width: 1, color: biruImran2, style: BorderStyle.solid),
              ),
              headingRowColor: WidgetStateProperty.all(biruImran),
              headingTextStyle: TextStyle(
                fontSize: _responsiveFontSize(),
                fontWeight: FontWeight.bold,
                color: white,
              ),
              columns: [
                DataColumn(
                  label: Text(
                    'SKU ID',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'UOM',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'QTY',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Picked',
                  ),
                ),
              ],
              rows: _skuRow
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          // selectedFilter != 'All' ?
          // SizedBox() :
          _allIsPicked.every((e) => e == true) ?
          SizedBox() :
          SizedBox(
            width: tableWidth * 0.82,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Select All',
                  style: TextStyle(
                    fontSize: _responsiveFontSize(),
                    fontWeight: FontWeight.normal,
                    color: biruImran,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                RoundCheckBox(
                  size: 30,
                  isChecked: _allPicked,
                  onTap: _allIsPicked.every((e) => e==true) ?
                  null :
                  (selected) {
                    setState(() {
                      _setAllPicked(selected ?? false);
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 150,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    // Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogConfirmation();
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    elevation: 10,
                    backgroundColor: biruImran4,
                  ),
                  child: const Text(
                    "Back",
                    style: TextStyle(
                      color: biruImran,
                      fontSize: 16
                    ),
                  ),
                ),
              ),
              _allIsPicked.every((e) => e == true) ?
              SizedBox() :
              SizedBox(
                width: 300,
                height: 50,
                child: TextButton(
                  onPressed: _somePicked ? () async {
                    bool _confirmPicked = false;

                    _confirmPicked = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogReceiveConfirmation();
                      },
                    );

                    if (_confirmPicked) {
                      setState(() {
                        _isLoading = true;
                      });

                      await postPicked(_token).whenComplete(() {
                        setState(() {
                          _isLoading = false;
                        });
                      });
                    }
                    
                  } :
                  () {
                    FloatingSnackBar(
                      message: 'Nothing is picked yet. Please pick the following SKUs.',
                      context: context,
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: _somePicked ? hijauImran : Colors.transparent,
                    side: BorderSide(
                      color: _somePicked ? Colors.transparent : greyColor
                    )
                  ),
                  child: Text(
                    "Confirm",
                    style: TextStyle(
                      color: _somePicked ? white : greyColor,
                      fontSize: 16
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 150,
          ),
        ],
      );
  }

  Widget _buildCell(String title, String date, double cellHeight) {

    if (date != 'null') {
      DateTime dateParsed = DateTime.parse(date).add(Duration(hours: int.parse('8')));
      date = _myFormat2.format(dateParsed);
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
              text: TextSpan(
                text: '${title}\n',
                style: TextStyle(
                  fontSize: _responsiveFontSize(),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: biruImran,
                ),
                children: [
                  TextSpan(
                    text: date,
                    style: TextStyle(
                      fontSize: _responsiveFontSize() - 4,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                      color: biruImran,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
