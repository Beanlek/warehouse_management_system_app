// ignore_for_file: avoid_print, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/page_stock_take/component/components.dart';
import 'package:warehouse/page_stock_take/widget/dialog_widget.dart';

import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';
import 'package:warehouse/widgets/global_dialog.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({super.key, required this.id, required this.warehouseName});

  final String id;
  final String warehouseName;

  @override
  _WarehousePageState createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> with StockTakeComponents {
  final TextEditingController _searchFieldController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  final ScrollController _filterScrollController = ScrollController();
  final ScrollController _filterContainerScrollController = ScrollController();
  final ScrollController _mainScrollController = ScrollController();
  
  final FocusNode _searchFieldFocusNode = FocusNode();
  final FocusNode _commentFocusNode = FocusNode();

  final Map<String, Map<String, List<Map<String, dynamic>>>> _groupedItems = {};
  
  late List<Map<String, dynamic>> _inventoryData = [];
  late List<Map<String, dynamic>> _searchedInventoryData = [];

  bool _isLoading = true;
  // bool _expanded = false;

  @override
  void initState() {
    fetchInventoryData().whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _searchFieldController.dispose();
    _commentFocusNode.dispose();
    _searchFieldFocusNode.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    setState(() {
      _isLoading = true;
      _searchFieldController.text = query;
      _searchedInventoryData.clear();

      _searchedInventoryData = _inventoryData.where((_inventory) {
        final sku_id = _inventory['sku_id'].toString().toLowerCase();
        final sku_name = _inventory['sku_name'].toString().toLowerCase();
        final name = _inventory['name'].toString().toLowerCase();
        final brand = _inventory['brand'].toString().toLowerCase();
        final short_code = _inventory['short_code'].toString().toLowerCase();
        final searchText = _searchFieldController.text.toLowerCase();

        return
          sku_id.contains(searchText) ||
          sku_name.contains(searchText) ||
          name.contains(searchText) ||
          brand.contains(searchText) ||
          short_code.contains(searchText);
      }).toList();

      _isLoading = false;
    });
  }

  double _responsiveFontSize() {
    final screenWidth = MediaQuery.of(context).size.width;
    const maxResolution = 1200.0;
    const maxSize = 26.0;

    return (screenWidth / maxResolution) * maxSize;
  }

  ListTile _buildDropDownItems(int index, String data, bool _filterSelected) {
    // bool _filterSelected = false;

    return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(alignment: Alignment.centerRight,
              child: Text(data,
                style: TextStyle(
                  fontSize: _responsiveFontSize(),
                  fontWeight: FontWeight.normal,
                  color: white
                ),
              ),
            ),
            SizedBox(width: 12),
            RoundedCheckBox(
              size: _responsiveFontSize() * 2,
              isChecked: _filterSelected,
              onTap: (value) {
                setState(() {
                  _filterSelected = value!;
                  subCategorySelection[index] = _filterSelected;
                  _filterContainerItems();
                  debugPrint('_filterSelected = $_filterSelected');
                });
              },
            )
          ],
        ),
        onTap: () {},
      );
  }

  Widget _buildDropDownMenu(double _screenWidth, double _screenHeigth) {
    final int _length = subCategoryFilters.length;
    List<Widget> _tile = [];

    for (var i = 0; i < _length; i++) {
      _tile.add(_buildDropDownItems(i ,subCategoryFilters[i], subCategorySelection[i]));
    }

    return
    SizedBox(
      width: _screenWidth * 0.7,
      height: _screenHeigth * 0.4,
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0, bottom: 12),
        child: RawScrollbar(
          radius: Radius.circular(10),
          thickness: 8,
          thumbColor: biruImran3,
          thumbVisibility: true,
          scrollbarOrientation: ScrollbarOrientation.left,
          controller: _filterScrollController,
          child: SingleChildScrollView(
            controller: _filterScrollController,
            child: Column(
              children: _tile
            ),
          ),
        ),
      ),
    );
  }

  void _filterContainerItems() {
    final int _length = subCategoryFilters.length;
    bool _selectionExist = false;

    for (var i = 0; i < _length; i++) {
      debugPrint('subCategorySelection[$i] : ${subCategorySelection[i]}');
      if (subCategorySelection[i] == false) {
        final int _widgetLength = filterSelection.length;

        for (var j = 0; j < _widgetLength; j++) {
          final String _subCategory = filterSelection[j]['sub_category'];
          debugPrint('filterSelection[$j] : ${filterSelection[j]}');

          if (_subCategory == subCategoryFilters[i]) {
            setState(() {
              filterSelection.removeAt(j);
            });
          }
        }
      }

      else {
        final int _widgetLength = filterSelection.length;

        for (var j = 0; j < _widgetLength; j++) {
          final String _subCategory = filterSelection[j]['sub_category'];

          if (_subCategory == subCategoryFilters[i]) {
            _selectionExist = true;
            j = _widgetLength;
          } else {
            _selectionExist = false;
          }
        }

        if (_selectionExist == true) {
          continue;
        }

        final Widget _singleContainerItem =
        
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(_responsiveFontSize()),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_responsiveFontSize()),
                color: biruImran
              ),
          
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(subCategoryFilters[i],
                      style: TextStyle(
                        fontSize: _responsiveFontSize(),
                        fontWeight: FontWeight.normal,
                        color: white
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        debugPrint('x pressed');
                        filterSelection.removeWhere((item) => item['sub_category'] == subCategoryFilters[i]);
                        subCategorySelection[i] = false;
                      });
                    },
                    icon: Icon(Icons.close, color: white, size: _responsiveFontSize(),)
                  ),
                ],
              ),
            )
          ),
        );

        filterSelection.add({
          'widget' : _singleContainerItem,
          'sub_category' : subCategoryFilters[i]
        });

      }

    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        bool willPop = false;
        willPop = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogExitConfirmation();
          },
        );
  
        return willPop;
      },
      
      child:

      GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: AppBar(
              centerTitle: true,
              title: Text(
                'Warehouse Stock Take',
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
            
            
            Stack(
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
                          padding: EdgeInsets.only(left: 20, top: 24.0, right: 20),
                          child: RichText(
                              text: TextSpan(
                                text: 'Home ',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DialogExitConfirmation(toHome: true);
                                      },
                                    );
                                  },
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  color: textColorTertiary,
                                ),
                                children: [
                                  TextSpan(
                                    text: '> Warehouse Stock Take ',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DialogExitConfirmation();
                                          },
                                        );
                                      },
                                  ),
                                  TextSpan(
                                    text: '> ${widget.warehouseName}',
                                  ),
                                ],
                              ),
                            ),
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
                              flex: 3,
                              child: SizedBox(
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    onChanged: _onSearchSubmitted,
                                    controller: _searchFieldController,
                                    focusNode: _searchFieldFocusNode,
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
                        
                            SizedBox(width: 12),
                        
                            SizedBox(
                              width: screenWidth * 0.15,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLoading = true;
                        
                                    for (var i = 0; i < subCategorySelection.length; i++) {
                                      subCategorySelection[i] = false;
                                    }
                        
                                    filterSelection.clear();
                                    
                                    _isLoading = false;
                                  });
                                },
                                child: AutoSizeText(
                                  'Clear filter',
                                  maxLines: 1,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: _responsiveFontSize(),
                                    fontWeight: FontWeight.normal,
                                    color: biruImran
                                  ),
                                ),
                              ),
                            ),
                        
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 55,
                                    // decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(12),
                                    //     border: Border.all(color: greyColor, width: 2)),
                                    child: PopupMenuButton(
                                      constraints: BoxConstraints(
                                        maxWidth: screenWidth
                                      ),
                                      elevation: 0,
                                      color: Colors.transparent,
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          PopupMenuItem(
                                            child: Material(
                                              elevation: 5,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: biruImran,
                                                  shape: BoxShape.rectangle
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        title:
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              IconButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                icon: Icon(Icons.close, color: white, size: _responsiveFontSize(),)
                                                              ),
                                                              Text('Sub Categories',
                                                                style: TextStyle(
                                                                  fontSize: _responsiveFontSize() - 2,
                                                                  fontWeight: FontWeight.w300,
                                                                  color: biruImran3
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        onTap: () {},
                                                      ),
                                                      Divider(color: biruImran3,),
                                                      _buildDropDownMenu(screenWidth, screenHeight),
                                                    ],
                                                  )
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
                                              child: AutoSizeText(
                                                'Filter by',
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
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      filterSelection.isEmpty ?
                      SizedBox() :
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:  8.0),
                        child: RawScrollbar(
                          radius: Radius.circular(10),
                          thickness: 2,
                          thumbColor: biruImran,
                          thumbVisibility: true,
                          scrollbarOrientation: ScrollbarOrientation.top,
                          controller: _filterContainerScrollController,
                          child: SizedBox(
                            width: screenWidth * 0.9,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _filterContainerScrollController,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for(var i in filterSelection) i['widget']
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(
                        height: 16,
                      ),
                      
                      Padding( padding: const EdgeInsets.symmetric(horizontal:  24.0), child: StatefulBuilder(
                        builder: (context, thisSetState) {

                          return Material(
                            elevation: 0,
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: biruImran
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 24),
                                child: DropdownButtonFormField(
                                  elevation: 5,
                                  isExpanded: true,

                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none
                                    )
                                  ),

                                  icon: 
                                  // onChanged == null ?
                                  //   PLACEHOLDER_ICON
                                  // :
                                    Icon(Icons.arrow_forward_ios_rounded, color: white,),
                                  iconSize: 18,
                                  
                                  dropdownColor: biruImran,

                                  value: conditionsSelected,
                                  items: conditions.map((filter) => DropdownMenuItem<String>(
                                    alignment: AlignmentDirectional.centerStart,
                                    value: filter,

                                    child: Text(
                                      filter,
                                      style: TextStyle(color: white, fontWeight: FontWeight.normal),
                                    ),
                                  )).toList(),

                                  onChanged: (value) {
                                    setState((){
                                      conditionsSelected = value!;
                                      conditionsIndex = conditions.indexWhere((cond) => cond == conditionsSelected);
                                      
                                      final groupedItemsLength = _groupedItems.length;
                                      for (var i = 0; i < groupedItemsLength; i++) {
                                        debugPrint("onChanged var");
                                        final String category = _groupedItems.keys.toList()[i];
                                        final Map<String, List<Map<String, dynamic>>> shortCodeGroup = _groupedItems[category]!;

                                        final shortCodeGroupLength = shortCodeGroup.length;

                                        final shortCodeGroupList = shortCodeGroup.entries.map( (entry) => {"data": entry.value}).toList();

                                        for (var j = 0; j < shortCodeGroupLength; j++) {
                                          final List<Map<String, dynamic>> items = shortCodeGroupList;

                                          if (items[0]['data'][0]['is_expanded'])
                                            debugPrint('items isExpanded $i : ${items[0]['data'][0]['is_expanded'].toString()}');

                                          items[0]['data'][0]['is_expanded'] = false;
                                        }
                                        // shortCodeGroup.entries.map((entry) {
                                        //   final List<Map<String, dynamic>> items = entry.value;
                                        //   items[0]['is_expanded'] = false;
                                        //   debugPrint('items isExpanded $i : ${items[0]['is_expanded'].toString()}');
                                        // });
                                      }
                                    });
                                  }
                                ),
                              )
                            ),
                          );
                        }
                      )),
                  
                      _isLoading ?
                      Expanded(child: Center(child: CircularProgressIndicator(),)) :
                      
                  
                      Expanded(
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child:
                              
                              RawScrollbar(
                                radius: Radius.circular(10),
                                thickness: 2,
                                thumbColor: biruImran,
                                thumbVisibility: true,
                                controller: _mainScrollController,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder(
                                    future: null, // Pass null since we're not using a future
                                    builder: (context, snapshot) {
                                      if (_inventoryData.isEmpty) {
                                        // return shimmerList();
                                        return Center(child: CircularProgressIndicator());
                                      } else {
                                        final int _length = subCategorySelection.length;
                                        List<Map<String, dynamic>> _filteredInventoryData = [];
                                        List<String> _filter = [];
                                                  
                                        bool containsAny(String text, List<String> substrings) {
                                          for (var substring in substrings) {
                                            if (text.contains(substring)) return true;
                                          }
                                          return false;
                                        }
                                                  
                                        for (var i = 0; i < _length; i++) {
                                          if (subCategorySelection[i]) {
                                            _filter.add(subCategoryFilters[i].toLowerCase());
                                          }
                                        }
                                                
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          _isLoading = true;
                                        });
                                        if (_searchFieldController.text == '') {
                                          _filteredInventoryData = _inventoryData.where((_inventory) {
                                            final sub_category = _inventory['sub_category'].toString().toLowerCase();
                                                  
                                            return
                                            _filter.isEmpty ?
                                            true :
                                            containsAny(sub_category, _filter);
                                          }).toList();
                                        
                                          _groupItems(_filteredInventoryData);
                                        } else {
                                          _filteredInventoryData = _searchedInventoryData.where((_inventory) {
                                            final sub_category = _inventory['sub_category'].toString().toLowerCase();
                                                  
                                            return
                                            _filter.isEmpty ?
                                            true :
                                            containsAny(sub_category, _filter);
                                          }).toList();
                                                  
                                          _groupItems(_filteredInventoryData);
                                        }
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          _isLoading = false;
                                        });
                                        
                                        return _buildInventoryList(context, controller: _mainScrollController);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox()
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  Future<void> fetchInventoryData() async {
    try {
      final String? token = await TokenUtil.getToken();
      final String? domainName = await TokenUtil.getDomainName();

      String apiUrl = '$domainName/api/inventory/list/${widget.id}?active=active';
      // eg: {{tnv}}/api/inventory/list/7Y?active=active
      final uri = Uri.parse(apiUrl);

      final response = await http.get(uri, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final inventoryData = List<Map<String, dynamic>>.from(data['inventory']);
        final inventoryLength = inventoryData.length;
        
        bool _alreadyHasFilterSubCategory = false;

        for (var i = 0; i < inventoryLength; i++) {
          final sub_category = inventoryData[i]['sub_category'];
          final quantity = [
            0,
            0,
            0,
            0,
          ];

          inventoryData[i]['quantity'] = List.from(quantity);
          
          final int subCategoryLength = subCategoryFilters.length;

          if (sub_category == null) {
            continue;
          }

          if (subCategoryLength > 0) {
            for (var k = 0; k < subCategoryLength; k++) {
              if (subCategoryFilters[k] == sub_category) {
                _alreadyHasFilterSubCategory = true;
                k = subCategoryLength;
              } else {
                _alreadyHasFilterSubCategory = false;
              }
            }
          }

          if (_alreadyHasFilterSubCategory == false) {
            subCategoryFilters.add(sub_category);
            subCategorySelection.add(false);
          }

        }

        setState(() {
          _inventoryData = inventoryData;
        });

        initializeStock();
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> initializeStock() async {
    try {
      final String? token = await TokenUtil.getToken();
      final String? domainName = await TokenUtil.getDomainName();

      String apiUrl = '$domainName/api/wms/warehouse_stock_take/initialize';
      final uri = Uri.parse(apiUrl);

      // Create the inventory data in the required format
      // final List<Map<String, dynamic>> inventoryData = _inventoryData.map((item) {
      //   return {
      //     'brand': item['brand'],
      //     'category': item['category'],
      //     'name': item['name'],
      //     'quantity': 
      //       item['quantity']
      //     ,
      //     'sequence': item['sequence'],
      //     'short_code': item['short_code'],
      //     'sku_id': item['sku_id'],
      //     'sku_name': item['sku_name'],
      //     'sub_category': item['sub_category'],
      //     'uom_id': item['uom_id'],
      //   };
      // }).toList();
      final List<Map<String, dynamic>> inventoryData = List.from(_inventoryData);

      debugPrint("inventorydata: ${inventoryData[0].toString()}");

      final payload = {
        'inventory': inventoryData,
        'site_id': widget.id,
      };

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      debugPrint(jsonEncode(payload));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          refID = responseData['transaction_id'] as String;
          debugPrint(refID);
        });
        debugPrint('Initialize successfully.');
      } else {
        throw Exception('Failed to save stocktake. Status code: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  Future<void> acknowledgeData() async {
    try {
      final String? token = await TokenUtil.getToken();
      final String? domainName = await TokenUtil.getDomainName();

      String apiUrl = '$domainName/api/wms/warehouse_stock_take/update_ackowledge/$refID';
      final uri = Uri.parse(apiUrl);

      final List<Map<String, dynamic>> inventoryData =
          _inventoryData.map((item) {
        return {
          'sku_id': item['sku_id'],
          'uom_id': item['uom_id'],
          'quantity': [
            item['quantity'][0].toString(),
            item['quantity'][1].toString(),
            item['quantity'][2].toString(),
            item['quantity'][3].toString(),
          ],
        };
      }).toList();

      final payload = {
        'site_id': widget.id,
        'comment': _commentController.text.trim(),
        'inventory': inventoryData,
      };

      final payloadDebug = {
        'site_id': widget.id,
        'comment': _commentController.text.trim(),
        'inventory': [
          inventoryData[0],
          inventoryData[1],
        ],
      };

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );
      debugPrint(apiUrl);
      debugPrint("payload debug:\n\n${jsonEncode(payloadDebug)}\n\n");

      if (response.statusCode == 200) {
        FloatingSnackBar(message: 'Successfully acknowledged into WMS log', context: context);
        Navigator.of(context).pop();
        debugPrint('Data acknowledged successfully. ${response.statusCode}');
      } else {
        debugPrint(token);
        throw Exception(
          'Failed to acknowledge data. Status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  void _groupItems(List<Map<String, dynamic>> inventoryData) {
    _groupedItems.clear();

    for (var item in inventoryData) {
      if (item['name'] == null && item['short_code'] == null) {
        continue;
      }
      item.putIfAbsent('is_expanded', () => false);

      // debugPrint("item['name'] : ${item['name']}");
      // debugPrint("item['short_code'] : ${item['short_code']}");
      debugPrint('run this');

      String category = item['category'] ?? 'Uncategorized';
      String shortCode = item['short_code'];


      _groupedItems.putIfAbsent(category, () => {});
      _groupedItems[category]!.putIfAbsent(shortCode, () => []);
      _groupedItems[category]![shortCode]!.add(item);
    }
  }

  Widget _buildInventoryList(BuildContext context, {required ScrollController controller}) {
    if (_groupedItems.isEmpty) {
      return const Center(
        child: Text('No inventory data available.'),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: controller,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _groupedItems.length,
                    itemBuilder: (context, index) {
                      final String category = _groupedItems.keys.toList()[index];
                      final Map<String, List<Map<String, dynamic>>> shortCodeGroup = _groupedItems[category]!;
                      // final List<String> short_code = shortCodeGroup.keys.toList();
                    
                      // printLongString('shortCodeGroup : $shortCodeGroup');
                      // debugPrint('shortCodeGroup allKeys : ${short_code}');
                      // debugPrint('shortCodeGroup.length : ${shortCodeGroup.length}');
                    
                      return ExpansionTile(
                        onExpansionChanged: (value) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          // debugPrint('SHORTCODE : ${shortCodeGroup.keys.toString()}');

                          // var shortCodeGroupList = [];

                          // shortCodeGroupList = shortCodeGroup.entries.map((entry) {
                          //   return {
                          //     entry.key,
                          //     entry.value
                          //   };
                          // }).toList();

                          // debugPrint('SHORTCODE LIST : ${shortCodeGroupList.toString()}');

                          // for (var i = 0; i < shortCodeGroupList.length; i++) {
                          //   debugPrint('SHORTCODE CODE : run');  
                          //   final code = shortCodeGroupList[i][1][0]['is_expanded'];
                          //   debugPrint('SHORTCODE CODE : ${code.toString()}');  

                          //   shortCodeGroup[code]![0]['is_expanded'] = false;
                          // }
                        },
                        shape: RoundedRectangleBorder(),
                        title: Text(
                          category,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: biruImran,
                          ),
                        ),
                        children:
                    
                        // [Text('Data')]
                    
                        // shortCodeGroup.entries
                        //     .map((entry) => InventoryGroup(
                        //           shortCode: entry.key,
                        //           items: entry.value,
                        //           onChanged: () {
                        //             setState(() {});
                        //           },
                        //         ))
                        //     .toList()
                    
                        shortCodeGroup.entries
                            .map((entry) => _buildInventoryGroup(entry.key, entry.value)).toList()
                    
                        ,
                      );
                    },
                  ),
                ),
                Divider(
                  color: biruImran,
                  thickness: 1,
                ),
                Container( color: Theme.of(context).scaffoldBackgroundColor, 
                  child: Padding( padding: const EdgeInsets.all(8.0),
                    child: Column( crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column( mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox( height: 32,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    showComment = !showComment;
                                  });
                                },
                                child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text( 'Comment',
                                      style: TextStyle(
                                        fontSize: _responsiveFontSize(),
                                        fontWeight: FontWeight.bold,
                                        color: biruImran,
                                      ),
                                    ),
                                    Icon(
                                      showComment ?
                                        Icons.keyboard_arrow_down :
                                        Icons.keyboard_arrow_up,
                                      color: biruImran,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            
                            !showComment ? SizedBox() :
                            const SizedBox(height: 12,),
                            
                            !showComment ? SizedBox() :
                            TextFormField(
                              focusNode: _commentFocusNode,
                              controller: _commentController,
                              keyboardType: TextInputType.multiline,
                              minLines: 5,
                              maxLines: 5,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: biruImran,
                                    width: 2
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: biruImran,
                                    width: 1
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 50,
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DialogExitConfirmation();
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
                            SizedBox(
                              width: 300,
                              height: 50,
                              child: TextButton(
                                // onPressed:() {
                                //   debugPrint('QUANTITY: ${_inventoryData[0]['quantity'].toString()}');
                                // },
                                onPressed: _commentController.text.isNotEmpty ? () async {
                                  bool _confirmSave = false;
                                    
                                  _confirmSave = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DialogSaveConfirmation();
                                    },
                                  );
                                    
                                  if (_confirmSave) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    
                                    await acknowledgeData().whenComplete(() {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    });
                                  }
                                  
                                } :
                                () {
                                  FloatingSnackBar(
                                    message: 'Please enter comment before saving.',
                                    context: context,
                                  );
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: _commentController.text.isNotEmpty ? hijauImran : Colors.transparent,
                                  side: BorderSide(
                                    color: _commentController.text.isNotEmpty ? Colors.transparent : greyColor
                                  )
                                ),
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                    color: _commentController.text.isNotEmpty ? white : greyColor,
                                    fontSize: 16
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        
      ],
    );
  }

  Widget _buildInventoryGroup(String shortCode, List<Map<String, dynamic>> items) {

    // debugPrint('buildInventoryGroup items[0][is_expanded] : ${items[0]['is_expanded']}');
    bool _expanded = items[0]['is_expanded'];

    return Card(
      color: biruImran,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  shortCode,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _responsiveFontSize() * 1.2,
                    color: white,
                  ),
                ),
                Text(
                  items[0]['name'] ?? 'N/A',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: _responsiveFontSize() * 0.8,
                    color: white,
                  ),
                ),
              ],
            ),
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                _expanded = !_expanded;
                debugPrint('_expanded : $_expanded');
              });

              items[0]['is_expanded'] = _expanded;
            },
            trailing: _expanded
                ? const Icon(Icons.keyboard_arrow_up, color: white)
                : const Icon(Icons.keyboard_arrow_down, color: white),
          ),
          if (_expanded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(36,0,36,18),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: biruImran3)
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ListTile(
                            title:
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: _responsiveFontSize() * 8,
                                  child: RichText(
                                    overflow: TextOverflow.visible,
                                    text: TextSpan(
                                        text: 'SKU ID\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: biruImran3,
                                          fontSize: _responsiveFontSize() * 0.8,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: item['sku_id'] ?? 'N/A',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: _responsiveFontSize(),
                                              color: white,
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                                SizedBox(width: 12,),
                                SizedBox(
                                  width: _responsiveFontSize() * 10,
                                  child: RichText(
                                    overflow: TextOverflow.visible,
                                    text: TextSpan(
                                        text: 'SKU Name\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: biruImran3,
                                          fontSize: _responsiveFontSize() * 0.8,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: item['sku_name'] ?? 'N/A',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: _responsiveFontSize(),
                                              color: white,
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                                SizedBox(width: 12,),
                                RichText(
                                  text: TextSpan(
                                      text: 'UOM ID\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: biruImran3,
                                        fontSize: _responsiveFontSize() * 0.8,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: item['uom_id'] ?? 'N/A',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: _responsiveFontSize(),
                                            color: white,
                                          ),
                                        ),
                                      ]),
                                ),
                                SizedBox(width: 12,),
                              ],
                            ),
                          ),
                        ),
                        
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                              
                              initialValue: item['quantity'][conditionsIndex].toString(),
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: biruImran),
                              onChanged: (value) {
                                setState(() {
                                  item['quantity'][conditionsIndex] = int.parse(value);
                                });
                                debugPrint(item['quantity'].toString());
                              },
                              decoration: InputDecoration(
                                labelText: 'Quantity',
                                suffixIcon: Icon(Icons.edit, size: _responsiveFontSize(), color: biruImran,),
                                contentPadding: const EdgeInsets.all(8),
                                filled: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
