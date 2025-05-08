// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:floating_snackbar/floating_snackbar.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/data/models/transfer_out_inventory.dart';
import 'package:warehouse/data/models/warehouse.dart';

import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/stock_recon/widget/dialog_widget.dart';
import 'package:warehouse/utils/utils.dart';
import 'package:warehouse/widgets/global_dialog.dart';


class TransferOutCreate extends StatefulWidget {
  const TransferOutCreate({
    super.key,
  });

  @override
  State<TransferOutCreate> createState() => _TransferOutCreateState();
}

class _TransferOutCreateState extends State<TransferOutCreate> {

  ScrollController mainScrollController = ScrollController();
  TextEditingController remarkController = TextEditingController(text: 'No remarks.');
  FocusNode remarkFocusnode = FocusNode();

  int activeStep = 0;
  bool isLoading = true;
  bool isExpanded = false;

  List<Warehouse> sourceSitesWarehouse = [];
  List<Warehouse> destinationSitesWarehouse = [];

  Warehouse selectedSourceSite = Warehouse(id: '', name: '');
  Warehouse selectedDestinationSite = Warehouse(id: '', name: '');

  List<TOInventory> toInventory = [];
  Map<String, dynamic> brandToInventory = {};

  final Map<String, Map<String, TextEditingController>> controllers = {};
  String selectedPrincipal = '';
  List<String> brandNames = [];
  List<TOInventory> displayInventory = [];
  
  String? token;
  String errMsg = "Unknown error";

  Future<void> _getToken() async {
    await TokenUtil.getToken().then((v) async {
      token = v;

      if (token != null) {
        await fetchSites(token).whenComplete(() {
          setState(() {
            isLoading = false;
          });
        });
      } else {
        FloatingSnackBar(message: 'Session ended. Please log in again.', context: context);

        Navigator.of(context).pop();
      }
    });

  }

  Future<void> sortBrands() async {
    debugPrint('Starting sortBrands');
    brandNames.clear(); // Clear existing brand names
    brandToInventory.clear(); // Clear existing brandToInventory map

    for (var item in toInventory) {
      String brand = item.brand;

      // Add brand to brandNames if not already present
      if (!brandNames.contains(brand)) {
        brandNames.add(brand);
      }
    }

    debugPrint('Brand names populated: $brandNames');
    debugPrint('Number of brands: ${brandNames.length}');
  }

  void updateDisplayInventory(String principalName) {
    displayInventory.clear();
    for (var item in toInventory) {
      if (item.brand == principalName) {
        displayInventory.add(item);
      }
    }
    debugPrint('Display Inventory: $displayInventory');
  }

  Future<void> fetchSites(String? token) async {
    
    final String? domainName = await TokenUtil.getDomainName();

    String url = '$domainName/api/dataLookup/sites/list';
    final uri = Uri.parse(url);

    final response = await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body);
        final List<Map<String,dynamic>> sitesRaw = List.from(json['sites'] as List);

        sourceSitesWarehouse = sitesRaw.map((sites) => Warehouse.fromJson(sites) ).toList();
        destinationSitesWarehouse = sitesRaw.map((sites) => Warehouse.fromJson(sites) ).toList();

        debugPrint('fetch API completed');
      } catch (e) {
        debugPrint('Failed to parse JSON: $e');
      }
    } else {
      debugPrint('Failed to fetch API. Status code: ${response.statusCode}');
      debugPrint('Error Body: ${response.body}');

      Navigator.pushNamed(context, AppRoutes.login);
    }
  }

  Future<int> fetchTables(String? token, {
    required Warehouse selectedSite
  }) async {
    var statusCode = 505;
    final String? domainName = await TokenUtil.getDomainName();
    final dio = Dio();

    String url = '${domainName}/api/tin_tout/transfer_out/inventory/${selectedSite.id}';
    debugPrint("URL??? :: ${url.toString()}");
    try {
      
      await dio.get(
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),

        url,

      ).then((response) {
        statusCode = response.statusCode!;

        if (statusCode == 200 || statusCode == 201) {
          debugPrint("RESPONSE DATA :: ${response.data.toString()}");
          
          final List<Map<String,dynamic>> inventoryRaw = List.from(response.data['inventory'] as List);

          toInventory = inventoryRaw.map((sku) {
            final inv = TOInventory.fromJson(sku);
            if (inv.quantity.reduce((a,b) => int.parse(a.toString()) + int.parse(b.toString())) > 0 ) {
              return inv;
              
            } else {
              inv.clear();
              return inv;
            }
          } ).toList();

          toInventory.removeWhere((t) => t.isEmpty);

          debugPrint('COMPLETE :: ${toInventory.toString()}');

        } else if(statusCode == 404) {

          // Inventory empty for site
          final json = jsonDecode(response.data);
          errMsg = json['errmsg'];

          debugPrint('INVENTORY EMPTY :: ${errMsg}');

        } else if(response.data == 'Forbidden') {

          debugPrint('Failed to fetch API. Status code: ${response.statusCode}');
          debugPrint('Error Body: ${response.data}');

          FloatingSnackBar(
              message: 'Token Expired. Please login back to the system.',
              context: context);
          
          Navigator.pushNamed(context, AppRoutes.login);
        } else {
          debugPrint("${statusCode.toString()} :: ${response.data.toString()}");
          errMsg = 'This may due to server hickups. Please wait for a while.';

          FloatingSnackBar(
              message: 'Encountered an error. $errMsg', context: context);

          Navigator.of(context).pop();
        }

      }).timeout(Duration(seconds: 10));

    } on TimeoutException {
      debugPrint("ERROR TIMEOUT");
      errMsg = 'Action took a long time to run (10 seconds).';

      FloatingSnackBar(
          message: 'Encountered an error. $errMsg', context: context);

      Navigator.of(context).pop();

    } on DioException catch (e) {
      debugPrint("ERROR DIO STATUSCODE :: ${statusCode.toString()}");
      debugPrint("ERROR DIO :: ${e.toString()}");

      final String eString = e.toString();

      if (eString.contains('404')) {
        statusCode = 404;
        errMsg = "Inventory empty for ${selectedSite.id}";

        debugPrint('INVENTORY EMPTY :: ${errMsg}');

      } else {
        errMsg = 'This may due to server hickups. Please wait for a while.';

        FloatingSnackBar(
            message: 'Encountered an error. $errMsg', context: context);

        Navigator.of(context).pop();

      }
      

    } catch (e) {
      debugPrint("ERROR CATCH :: ${e.toString()}");
      errMsg = 'This may due to server hickups. Please wait for a while.';

      FloatingSnackBar(
          message: 'Encountered an error. $errMsg', context: context);

      Navigator.of(context).pop();
    }

    return statusCode;
  }

  Future<int> createTo() async {
    var statusCode = 505;
    final String? domainName = await TokenUtil.getDomainName();
    final dio = Dio();

    String url = '${domainName}/api/tin_tout/transfer_out/create';
    debugPrint("URL??? :: ${url.toString()}");

    const timeoutSec = 100;

    const key_fromSiteId = 'from_site_id';
    const key_toSiteId = 'to_site_id';
    const key_remark = 'remark';
    const key_skus = 'skus';
    const key_skuId = 'sku_id';
    const key_uomId = 'uom_id';
    const key_quantity = 'quantity';

    var skus = displayInventory.map((t) {
      if (t.quantityInput.reduce((a, b) => int.parse(a.toString()) + int.parse(b.toString())) > 0) {
        return {
          key_skuId : t.skuId,
          key_uomId : t.uomId,
          key_quantity : [
            int.parse(t.quantityInput[0].toString()),
            int.parse(t.quantityInput[1].toString()),
            int.parse(t.quantityInput[2].toString()),
            int.parse(t.quantityInput[3].toString()),
          ],
        };
      }
    }).toList();
    // var skus = brandToInventory.values
    //   .expand((e) => e['rows'].map(
    //     (t) {
    //       if (t.quantityInput.reduce((a, b) => int.parse(a.toString()) + int.parse(b.toString())) > 0) {
    //         return {
    //           key_skuId : t.skuId,
    //           key_uomId : t.uomId,
    //           key_quantity : [
    //             int.parse(t.quantityInput[0].toString()),
    //             int.parse(t.quantityInput[1].toString()),
    //             int.parse(t.quantityInput[2].toString()),
    //             int.parse(t.quantityInput[3].toString()),
    //           ],
    //         };
    //       }
    //     }
    //   )).toList();

    skus.removeWhere((t) => t == null);


    var payload = {
      key_fromSiteId : selectedSourceSite.id,
      key_toSiteId : selectedDestinationSite.id,
      key_remark : remarkController.text.trim(),
      key_skus : skus,
    };

    // {
    //   "from_site_id": "7X",
    //   "to_site_id": "SB",
    //   "remark": "remarknospaceworksplease",
    //   "skus": [
    //     {"sku_id": "CLIPPER", "uom_id": "PK", "quantity": [570, 0, 0, 0]},
    //     {"sku_id": "FIXEDFLAME", "uom_id": "PK", "quantity": [0, 0, 0, 30]}
    //   ]
    // }

    debugPrint('PAYLOAD??? :: ${payload}');
    debugPrint('PAYLOAD SKUS??? :: ${skus}');
    
    try {
      
      await dio.post(
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),

        url,
        data: payload

      ).then((response) async {
        statusCode = response.statusCode!;

        if (statusCode == 200 || statusCode == 201) {
          debugPrint("RESPONSE DATA :: ${response.data.toString()}");

          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogActionSuccess(
                title: 'Success',
                subtitle: 'Transfer Out successfully created.',
              );
            },
          ).whenComplete(() {
            Navigator.pushNamed(context, AppRoutes.homepage);
          });

        } else if(response.data == 'Forbidden') {

          debugPrint('Failed to fetch API. Status code: ${response.statusCode}');
          debugPrint('Error Body: ${response.data}');

          FloatingSnackBar(
              message: 'Token Expired. Please login back to the system.',
              context: context);
          
          Navigator.pushNamed(context, AppRoutes.login);
        } else {
          debugPrint("${statusCode.toString()} :: ${response.data.toString()}");
          errMsg = 'Failed to create Transfer Out. ${response.data.toString()}';

          FloatingSnackBar(
              message: 'Encountered an error. $errMsg', context: context);
        }

      }).timeout(Duration(seconds: timeoutSec));

    } on TimeoutException {
      debugPrint("ERROR TIMEOUT :: Action took a long time to run (${timeoutSec.toString()} seconds).");
      errMsg = 'Failed to create Transfer Out. Action took a long time to run (${timeoutSec.toString()} seconds).';

      FloatingSnackBar(
          message: 'Encountered an error. $errMsg', context: context);

    } on DioException catch (e) {
      debugPrint("ERROR DIO STATUSCODE :: ${e.response!.statusCode.toString()}");
      debugPrint("ERROR DIO :: ${e.response.toString()}");

      statusCode = e.response!.statusCode ?? 505;
      errMsg = e.response!.data['errMsg'] ?? 'Failed to create Transfer Out.';
      

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogNotice(
            title: 'Error',
            notice: errMsg,
          );
        },
      );
      
    } catch (e) {
      debugPrint("ERROR CATCH :: ${e.toString()}");
      errMsg = 'Failed to create Transfer Out. Please wait for a while.';

      FloatingSnackBar(
          message: 'Encountered an error. $errMsg', context: context);

    }

    return statusCode;
  }

  // ---TABLE SKU----
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey[200],
      child: Row(
        children: const [
          Expanded(flex: 2, child: Text('CODE', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('SKU ID', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text('UOM ID', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Fresh', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Damaged', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Old', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Recalled', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildTableRow(TOInventory item) {

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(flex: 2, child: Text(item.shortCode)),
              Expanded(flex: 2, child: Text(item.skuId)),
              Expanded(flex: 1, child: Text(item.uomId)),
              Expanded(flex: 2, child: Text('${item.quantity[0]}')),
              Expanded(flex: 2, child: Text('${item.quantity[1]}')),
              Expanded(flex: 2, child: Text('${item.quantity[2]}')),
              Expanded(flex: 2, child: Text('${item.quantity[3]}')),
            ],
          ),
          Row(
            children: [
              Expanded(flex: 2, child: SizedBox()),
              Expanded(flex: 2, child: SizedBox()),
              Expanded(flex: 1, child: SizedBox()),
              Expanded(flex: 2, child: Padding( padding: const EdgeInsets.only(right: 8.0),
                child: qtyTextField(item, 'fresh', value: item.quantityInput[0].toString()),
              )),
              Expanded(flex: 2, child: Padding( padding: const EdgeInsets.only(right: 8.0),
                child: qtyTextField(item, 'damaged', value: item.quantityInput[1].toString()),
              )),
              Expanded(flex: 2, child: Padding( padding: const EdgeInsets.only(right: 8.0),
                child: qtyTextField(item, 'old', value: item.quantityInput[2].toString()),
              )),
              Expanded(flex: 2, child: Padding( padding: const EdgeInsets.only(right: 8.0),
                child: qtyTextField(item, 'recalled', value: item.quantityInput[3].toString()),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget createSKUTable({
    required List<dynamic> itemList,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildTableHeader(),
          const SizedBox(height: 8),
          ...itemList.map((item) => _buildTableRow(item)),
        ],
      ),
    );
  }

  // Widget qtyTextField(TOInventory item, String field, {
  //   required String value
  // }) {
  //   return SizedBox(
  //     height: 40,
  //     child: TextFormField(
  //       initialValue: value,
  //       keyboardType: TextInputType.number,
  //       onChanged: (value) {
  //         setState(() {
  //           int parsedValue = int.tryParse(value) ?? 0;
  //           switch (field) {
  //             case 'fresh':
  //               item.quantityInput[0] = parsedValue;
  //               break;
  //             case 'damaged':
  //               item.quantityInput[1] = parsedValue;
  //               break;
  //             case 'old':
  //               item.quantityInput[2] = parsedValue;
  //               break;
  //             case 'recalled':
  //               item.quantityInput[3] = parsedValue;
  //           }
  //           debugPrint('TOINVENTORY QUANTITY INPUT??? :: ${item.skuId}, $field: ${parsedValue.toString()}');
  //           debugPrint('TOINVENTORY QUANTITY INPUT ALL??? :: ${item.quantityInput.toString()}');
  //         });
  //       },
  //       decoration: InputDecoration(
  //         contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  //         border: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: Colors.grey,
  //           ),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: Colors.grey,
  //           ),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: Colors.blue,
  //             width: 2,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget qtyTextField(TOInventory item, String field, {
  required String value
}) {
  // Create controllers map for this SKU if it doesn't exist
  if (!controllers.containsKey(item.skuId)) {
    controllers[item.skuId] = {
      'fresh': TextEditingController(text: item.quantityInput[0].toString()),
      'damaged': TextEditingController(text: item.quantityInput[1].toString()),
      'old': TextEditingController(text: item.quantityInput[2].toString()),
      'recalled': TextEditingController(text: item.quantityInput[3].toString()),
    };
  }

  return SizedBox(
    height: 40,
    child: TextField(
      controller: controllers[item.skuId]![field],
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          int parsedValue = int.tryParse(value) ?? 0;
          switch (field) {
            case 'fresh':
              item.quantityInput[0] = parsedValue;
              break;
            case 'damaged':
              item.quantityInput[1] = parsedValue;
              break;
            case 'old':
              item.quantityInput[2] = parsedValue;
              break;
            case 'recalled':
              item.quantityInput[3] = parsedValue;
          }
          debugPrint('TOINVENTORY QUANTITY INPUT??? :: ${item.skuId}, $field: ${parsedValue.toString()}');
          debugPrint('TOINVENTORY QUANTITY INPUT ALL??? :: ${item.quantityInput.toString()}');
        });
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
      ),
    ),
  );
}

  ExpansionPanelRadio  principalRows({
    required String brand,
    required String name,
    required List<dynamic> items,
  }) {

    return ExpansionPanelRadio(
      value: brand,
      canTapOnHeader: true,
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Card(
          color: biruImran,
          margin: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  brand,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: white,
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: white,
                  ),
                ),
              ],
            ),
          ),
        );
      },

      body: createSKUTable(itemList: items),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    controllers.values.forEach((controllerMap) {
      controllerMap.values.forEach((controller) {
        controller.dispose();
      });
    });
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getToken().whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
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
            'Create Transfer Out',
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
          WillPopScope(
            onWillPop: () async {
              bool willPop = false;
              willPop = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogConfirmation();
                },
              );
        
              return willPop;
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Breadcrumbs
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
                                  return DialogConfirmation(toHome: true,);
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
                              text: '> Transfer Out ',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DialogConfirmation();
                                    },
                                  );
                                },
                            ),
                            TextSpan(
                              text: '> Create',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  // Content
                  Expanded(
                    child: RawScrollbar(
                      radius: Radius.circular(10),
                      thickness: 8,
                      thumbColor: biruImran4,
                      thumbVisibility: true,
                      controller: mainScrollController,
                      child: SingleChildScrollView(
                        controller: mainScrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            
                            // SOURCE SITE
                            ListTile(
                              dense: true,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Select Source Site',
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: biruImran
                                    ),
                                  ),
                                  Divider(color: biruImran2, height: 34,)
                                ],
                              ),
                              subtitle:
                              selectedSourceSite.id == '' ?
                                GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  
                                  shrinkWrap: true,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    childAspectRatio: 2,
                                
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                  ),
                                  itemCount: sourceSitesWarehouse.length,
                                  itemBuilder: (context, index) {
                                    final site = sourceSitesWarehouse[index];
                                
                                    var siteSelect = site.select;
                                    final siteID = site.id;
                                    final siteName = site.name;
                                
                                    var cardColor = siteSelect ? biruImran4 : biruImran;
                                    var fontColor = siteSelect ? biruImran : white;
                                    
                                    return InkWell(
                                      splashColor: white,
                                      onTap: () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        
                                        await Future.delayed(Duration(seconds: 1)).whenComplete(() async {
                                          await fetchTables(token, selectedSite: site).then((v) async{
                                            if (v == 404) {
                                              await showDialog(context: context,
                                                builder: (context) {
                                                  return DialogNotice(
                                                    title: errMsg,
                                                    notice: 'Please select a different site.'
                                                  );
                                                }
                                              );

                                            } else {
                                              setState(() {
                                                siteSelect = !siteSelect;
                                                site.select = siteSelect;

                                                if (siteSelect) {
                                                  selectedSourceSite = Warehouse.from(site);
                                                } else {
                                                  selectedDestinationSite.clear();
                                                  selectedSourceSite.clear();
                                                }
                                              });

                                              debugPrint('SITE SELECT :: ${siteSelect.toString()}');
                                              debugPrint('SITE SELECTEDSITE :: ${selectedSourceSite.toString()}');
                                              
                                              await sortBrands();

                                            }
                                            
                                          });

                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                        
                                        
                                      },
                                      child: Material(
                                        elevation: 3,
                                        borderRadius: BorderRadius.circular(24),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(24),
                                            border: Border.all(color: fontColor, width: 1),
                                            color: cardColor
                                          ),// Set card color
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: AutoSizeText(
                                                    siteID,
                                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: fontColor,
                                                    ),
                                                  
                                                    maxLines: 1,
                                                    minFontSize: 1,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: AutoSizeText(
                                                    siteName,
                                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                      color: fontColor,
                                                    ),
                                                  
                                                    maxLines: 2,
                                                    minFontSize: 1,
                                                    wrapWords: false,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                ) :
                              
                                InkWell(
                                  splashColor: biruImran,
                                  onTap: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await showDialog(context: context,
                                      builder: (context) {
                                        return DialogActionConfirmation(
                                          title: 'Reselecting Source Site',
                                          notice: 'Are you sure you want to reselect Source Site? Progress will be lost.',
                                          buttonConfirmText: 'Reselect',
                                        );
                                      }
                                    ).then((v) {
                                      v = v ?? false;

                                      if (v) {
                                        setState(() {
                                          for (var site in sourceSitesWarehouse) {
                                            final siteID = site.id;

                                            if (siteID == selectedSourceSite.id) {
                                              site.select = false;
                                              break;
                                            } 
                                          }

                                          selectedSourceSite.select = false;
                                          selectedSourceSite.clear();

                                          selectedDestinationSite.clear();
                                          for (var site in destinationSitesWarehouse) {
                                            site.select = false;
                                          }

                                          toInventory.clear();
                                          brandToInventory.clear();
                                          selectedPrincipal = '';
                                          displayInventory.clear();

                                          for (var item in toInventory) {
                                            item.quantityInput = [0, 0, 0, 0];
                                          }

                                          controllers.forEach((_, controllerMap) {
                                            controllerMap.values.forEach((controller) {
                                              controller.clear(); 
                                              controller.dispose();
                                            });
                                          });
                                          controllers.clear();
                                          remarkController.text = 'No Remarks.';


                                        });
                                        
                                      }
                                    });

                                    
                                    setState(() {
                                      isLoading = false;
                                    });

                                  },
                                  child: Material(
                                    elevation: 3,
                                    borderRadius: BorderRadius.circular(24),
                                    color: Colors.transparent,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(color: biruImran, width: 1),
                                        color: biruImran4
                                      ),// Set card color
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(
                                              selectedSourceSite.id,
                                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: biruImran,
                                              ),
                                            
                                              maxLines: 1,
                                              minFontSize: 1,
                                            ),
                                            AutoSizeText(
                                              selectedSourceSite.name,
                                              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                color: biruImran,
                                              ),
                                            
                                              maxLines: 2,
                                              minFontSize: 1,
                                              wrapWords: false,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ),


                            // DESTINATION SITE
                            if(selectedSourceSite.isNotEmpty)
                              ListTile(
                                dense: true,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Select Destination Site',
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: biruImran
                                      ),
                                    ),
                                    Divider(color: biruImran2, height: 34,)
                                  ],
                                ),
                                subtitle:
                                selectedDestinationSite.isEmpty ?
                                  GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    
                                    shrinkWrap: true,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 2,
                                  
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                    ),
                                    itemCount: destinationSitesWarehouse.length,
                                    itemBuilder: (context, index) {
                                      final site = destinationSitesWarehouse[index];
                                  
                                      var siteSelect = site.select;
                                      final siteID = site.id;
                                      final siteName = site.name;
                                  
                                      var cardColor = siteSelect ? biruImran4 : biruImran;
                                      var fontColor = siteSelect ? biruImran : white;

                                      final isSourceSite = siteID == selectedSourceSite.id; 
                                      
                                      return InkWell(
                                        splashColor: white,
                                        onTap: isSourceSite ? null : () async {
                                          
                                          setState(() {
                                            siteSelect = !siteSelect;
                                            site.select = siteSelect;

                                            if (siteSelect) {
                                              selectedDestinationSite = Warehouse.from(site);
                                            } else {
                                              selectedDestinationSite.clear();
                                            }
                                          });

                                          debugPrint('SITE SELECT :: ${siteSelect.toString()}');
                                          debugPrint('SITE SELECTEDSITE :: ${selectedDestinationSite.toString()}');


                                        },
                                        child: Opacity(
                                          opacity: isSourceSite ? .3 : 1,
                                          child: Material(
                                            elevation: 3,
                                            borderRadius: BorderRadius.circular(24),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(24),
                                                border: Border.all(color: fontColor, width: 1),
                                                color: cardColor
                                              ),// Set card color
                                              child: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        siteID,
                                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color: fontColor,
                                                        ),
                                                      
                                                        maxLines: 1,
                                                        minFontSize: 1,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        siteName,
                                                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                          color: fontColor,
                                                        ),
                                                      
                                                        maxLines: 2,
                                                        minFontSize: 1,
                                                        wrapWords: false,
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
                                  ) :
                                
                                  InkWell(
                                    splashColor: biruImran,
                                    onTap: () async {
                                      
                                      setState(() {
                                        for (var site in destinationSitesWarehouse) {
                                          final siteID = site.id;

                                          if (siteID == selectedDestinationSite.id) {
                                            site.select = false;
                                            break;
                                          } 
                                        }

                                        selectedDestinationSite.select = false;
                                        selectedDestinationSite.clear();
                                        selectedPrincipal = '';
                                        displayInventory.clear();
                                        for (var item in toInventory) {
                                          item.quantityInput = [0, 0, 0, 0]; // Reset quantities to zero
                                        }
                                        controllers.forEach((_, controllerMap) {
                                        controllerMap.values.forEach((controller) {
                                          controller.clear(); // Clear the text
                                          controller.dispose(); // Dispose the controller
                                        });
                                      });
                                      controllers.clear();
                                      });
                                    },
                                    child: Material(
                                      elevation: 3,
                                      borderRadius: BorderRadius.circular(24),
                                      color: Colors.transparent,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(24),
                                          border: Border.all(color: biruImran, width: 1),
                                          color: biruImran4
                                        ),// Set card color
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                selectedDestinationSite.id,
                                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: biruImran,
                                                ),
                                              
                                                maxLines: 1,
                                                minFontSize: 1,
                                              ),
                                              AutoSizeText(
                                                selectedDestinationSite.name,
                                                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                  color: biruImran,
                                                ),
                                              
                                                maxLines: 2,
                                                minFontSize: 1,
                                                wrapWords: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              ),

                            // REMARK
                            if(selectedSourceSite.isNotEmpty && selectedDestinationSite.isNotEmpty)
                              ListTile(
                                dense: true,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Enter Remark',
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: biruImran
                                      ),
                                    ),
                                    Divider(color: biruImran2, height: 34,)
                                  ],
                                ),
                                subtitle: TextFormField(
                                  focusNode: remarkFocusnode,
                                  controller: remarkController,
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
                                )
                              ),

                            // SKU TABLE
                            if(selectedSourceSite.isNotEmpty && selectedDestinationSite.isNotEmpty)
                              ListTile(
                                dense: true,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Please select principal',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(color: biruImran),
                                    ),
                                    Divider(
                                      color: biruImran2,
                                      height: 34,
                                    )
                                  ],
                                ),
                                subtitle: (brandNames.isNotEmpty)
                                  ? DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Select principal',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      ),
                                      items: brandNames.map((String brand) {
                                        return DropdownMenuItem<String>(
                                          value: brand,
                                          child: Text(brand),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedPrincipal = newValue!;
                                          updateDisplayInventory(selectedPrincipal);
                                        });
                                      },
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                        color: biruImran,
                                      ),
                                    ),
                              ),
                              (selectedPrincipal.isNotEmpty && selectedSourceSite.isNotEmpty && selectedDestinationSite.isNotEmpty)
                                ? createSKUTable(itemList: displayInventory)
                                : SizedBox.shrink(),
                          ],
                        ),
                      )
                    )
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: ElevatedButton(
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
                        'Create Transfer Out',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: white,
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        // var totalQuantity = brandToInventory.values
                        //   .expand((e) => e["rows"])
                        //   .fold(0, (total, data) => total + (data.quantityInput.reduce((a, b) => int.parse(a.toString()) + int.parse(b.toString()))) as int);
                        
                        var totalQuantity = displayInventory
                          .fold(0, (total, data) => total + (data.quantityInput.reduce((a, b) => 
                            int.parse(a.toString()) + int.parse(b.toString()))));
                        
                        debugPrint("TOTAL QUANTITY??? :: ${totalQuantity.toString()}");
                        
                        bool proceed = false;
                        if (selectedSourceSite.isEmpty) {
                          errMsg = 'Please select a source site.';
                        } else if(selectedDestinationSite.isEmpty) {
                          errMsg = 'Please select a destination site.';
                        } else if(remarkController.text.isEmpty) {
                          errMsg = 'Please enter remark.';
                        } else if(totalQuantity <= 0) {
                          errMsg = 'Please fill up at least one row.';
                        } else {
                          proceed = true;
                        }
                    
                        if (proceed) {
                          await createTo();
                          debugPrint('Transfer Payload BOOM!');
                          
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogNotice(
                                title: 'Missing Information',
                                notice: errMsg,
                              );
                            },
                          );
                    
                        }
                    
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                  ),
                  
                  
                  
                ],
              ),
            ),
          ),
          
          
        
          isLoading ? Opacity(opacity: 0.5,child: Container(
              color: white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator()),
              ),
            ) : SizedBox()
        ],
      ),

      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   debugPrint("TOINVENTORY ??? :: ${toInventory[20].toString()}");
      //   debugPrint("TOINVENTORY ??? :: ${toInventory[20].isEmpty.toString()}");
      // }),
      
      ));
  }

  
}
