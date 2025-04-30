// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables, deprecated_member_use, unnecessary_brace_in_string_interps, unused_import

import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/data/models/sku.dart';
import 'package:warehouse/data/models/stock_item.dart';
import 'package:warehouse/data/models/transfer_out_details.dart';
import 'package:warehouse/page_homepage/widget/dialog_Widget.dart';
import 'package:warehouse/routes/routes.dart';

import 'package:http/http.dart' as http;

import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';

import '../../data/models/transfer_out.dart';
import '../../data/models/warehouse.dart';
import '../../widgets/global_dialog.dart';

const String TYPE = TRANSFER_IN;
const String TITLE = TRANSFER_IN_CREATE;

class TransferInCreateView extends StatefulWidget {
  String? site;
  String? type;
  String? refId;
  String? remark;

  TransferInCreateView(
      {super.key, this.site, this.type, this.refId, this.remark});

  @override
  State<TransferInCreateView> createState() => _TransferInCreateViewState();
}

class _TransferInCreateViewState extends State<TransferInCreateView> {
  final Map<String, Map<String, TextEditingController>> controllers = {};

  List<Warehouse> sourceSitesWarehouse = [];

  bool isSwapped = false;

  List<String> refrerenceTypes = ['Stock Arrival', 'Transfer'];
  Warehouse selectedSourceSite = Warehouse(id: '', name: '');
  TransferOut selectectedTransferOut = TransferOut(
    id: '',
    date: '',
    status: '',
    fromSiteId: '',
    toSiteId: '',
    createdBy: '',
    createdAt: '',
    remark: '',
    selected: false,
  );

  String selectedReferenceType = '';
  String poId = '';
  String remark = '';
  String errMsg = '';

  List<Sku> skus = [];
  List<TransferOut> transferOuts = [];
  List<StockItem> transferSkus = [];
  Map<String, dynamic> brandSku = {};

  bool isExpanded = false;
  bool _isLoading = true;

  String? _token;

  @override
  // void initState() {
  //   super.initState();
  //   _getToken().whenComplete(() {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }
  void initState() {
    super.initState();
    _getToken().whenComplete(() {
      setState(() {
        _isLoading = false;
        // Use provided parameters if available
        if (widget.site != null && widget.site!.isNotEmpty) {
          selectedSourceSite.id = widget.site!;
        }
        if (widget.type != null && widget.type!.isNotEmpty) {
          selectedReferenceType = widget.type!;
        }
        if (widget.refId != null && widget.refId!.isNotEmpty) {
          selectectedTransferOut.id = widget.refId!;
          // Fetch transfer details if refId is provided
          fetchTransferOutDetails();
        }
        if (widget.remark != null && widget.remark!.isNotEmpty) {
          remark = widget.remark!;
          selectectedTransferOut.remark = widget.remark ?? '';
        }
        fetchTransferOuts();
      });
    });
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

  Future<void> _getToken() async {
    final String? token = await TokenUtil.getToken();
    setState(() {
      _token = token!;
    });
    if (token != null) {
      await fetchSites(_token);
      // After fetching sites, set the selected site if provided
      if (widget.site != null && widget.site!.isNotEmpty) {
        for (var site in sourceSitesWarehouse) {
          if (site.id == widget.site) {
            site.select = true;
            selectedSourceSite = Warehouse.from(site);
            break;
          }
        }
      }
    }
  }
  // Future<void> _getToken() async {
  //   final String? token = await TokenUtil.getToken();
  //   setState(() {
  //     _token = token!;
  //     // showPickLists = true;
  //   });
  //   if (token != null) {
  //     await fetchSites(_token);
  //   }
  // }

  void swapFreshWithUnreceived() {
    isSwapped = !isSwapped;

    if (isSwapped) {
      setState(() {
        for (var sku in transferSkus) {
          int temp = sku.quantity[0];
          sku.quantity[0] = sku.unreceivedQuantity[0];
          sku.unreceivedQuantity[0] = temp;

          if (controllers.containsKey(sku.skuId)) {
            controllers[sku.skuId]!['fresh']?.text = sku.quantity[0].toString();
            controllers[sku.skuId]!['unreceived']?.text =
                sku.unreceivedQuantity[0].toString();
          }
        }
      });
    } else {
      // On untoggle: restore original values from transferOutDetails
      brandSku.clear();
      fetchTransferOutDetails().then((_) {
        for (var sku in transferSkus) {
          // Update controllers with original values
          if (controllers.containsKey(sku.skuId)) {
            controllers[sku.skuId]!['fresh']?.text = sku.quantity[0].toString();
            controllers[sku.skuId]!['unreceived']?.text =
                sku.unreceivedQuantity[0].toString();
          }
        }
        //sortBrands();
      });
    }
  }

  Future<void> fetchSites(String? token) async {
    final String? domainName = await TokenUtil.getDomainName();

    String url = '$domainName/api/dataLookup/sites/list';
    final uri = Uri.parse(url);
    setState(() {
      _isLoading = true;
      debugPrint('is loading: $_isLoading');
    });

    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body);
        final List<Map<String, dynamic>> sitesRaw =
            List.from(json['sites'] as List);

        sourceSitesWarehouse =
            sitesRaw.map((sites) => Warehouse.fromJson(sites)).toList();

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

  Future<void> fetchTransferOutDetails() async {
    debugPrint('Calling fetchTransferout details');
    final String? domainName = await TokenUtil.getDomainName();
    if (_token == null) return;

    String url =
        '$domainName/api/tin_tout/transfer_out/o/${selectectedTransferOut.id}';
    final uri = Uri.parse(url);
    setState(() {
      _isLoading = true;
      debugPrint('is loading: $_isLoading');
    });

    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $_token'});

    if (response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body);
        final List<Map<String, dynamic>> sitesRaw =
            List.from(json['details'] as List);
        transferSkus =
            sitesRaw.map((sites) => StockItem.fromJson(sites)).toList();

        debugPrint(
            'fetch transferoutdetails completed\nTransferSKUS: ${transferSkus[0].quantity}');
        setState(() {
          sortBrands();
        });
      } catch (e) {
        debugPrint('Failed to parse JSON: $e');
      }
    } else {
      debugPrint('Failed to fetch API. Status code: ${response.statusCode}');
      debugPrint('Error Body: ${response.body}');
      Navigator.pushNamed(context, AppRoutes.login);
    }
  }

  Future<void> fetchSkus() async {
    setState(() {
      _isLoading = true;
    });
    if (_token == null) return;

    final String? domainName = await TokenUtil.getDomainName();
    if (domainName == null) return;

    String url = '$domainName/api/tin_tout/transfer_in/tablelist';
    final uri = Uri.parse(url);

    try {
      final response =
          await http.get(uri, headers: {'Authorization': 'Bearer $_token'});

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['skus'] != null) {
          final List<dynamic> skusRaw = json['skus'] as List;
          setState(() {
            //remember to remove the take(10) when you want to show all skus
            skus = skusRaw
                // .where((sku) =>
                //     sku['principalname'] == 'BIKA' ||
                //     sku['principalname'] == 'ZUS' ||
                //     sku['principalname'] == 'CARABAO')
                .map((sku) => Sku.fromJson(sku))
                .toList();
            sortBrands();
            _isLoading = false;
          });
          debugPrint('fetch API completed');
        } else {
          debugPrint('No SKUs found in response');
        }
      } else {
        debugPrint('Failed to fetch API. Status code: ${response.statusCode}');
        if (response.statusCode == 401) {
          Navigator.pushNamed(context, AppRoutes.login);
        }
      }
    } catch (e) {
      debugPrint('Failed to fetch or parse SKUs: $e');
    }
  }

  Future<void> fetchTransferOuts() async {
    debugPrint('fetchTransferOuts called');
    setState(() {
      _isLoading = true;
    });
    if (_token == null) return;

    final String? domainName = await TokenUtil.getDomainName();
    if (domainName == null) return;

    String url =
        '$domainName/api/tin_tout/transfer_out/list?to_site_id=${selectedSourceSite.id}&status=in%20transit';
    final uri = Uri.parse(url);

    try {
      final response =
          await http.get(uri, headers: {'Authorization': 'Bearer $_token'});

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['transferOut'] != null) {
          final List<dynamic> refIdsRaw = json['transferOut']['rows'] as List;

          setState(() {
            var temp =
                refIdsRaw.map((refId) => TransferOut.fromJson(refId)).toList();
            if (temp.isEmpty) {
              // Only clear and show dialog if no data
              selectedReferenceType = '';
              errMsg =
                  "No Unreceived Transfer, select 'Stock Arrival' to proceed with receiving";
              // Remove the showDialog from here - will be handled in the UI
            }
            transferOuts = temp; // Always update transferOuts
            _isLoading = false;
          });

          // Show dialog outside setState if needed
          if (transferOuts.isEmpty) {
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
        }
      } else {
        debugPrint('Failed to fetch API. Status code: ${response.statusCode}');
        if (response.statusCode == 401) {
          Navigator.pushNamed(context, AppRoutes.login);
        }
      }
    } catch (e) {
      debugPrint('Failed to fetch or parse refIds: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> sortBrands() async {
    List items = [];
    if (selectedReferenceType == 'Transfer') {
      items = transferSkus;
    } else {
      items = skus;
    }
    for (var item in items) {
      String brand = item.principalName;

      if (!brandSku.containsKey(brand)) {
        brandSku.addEntries({brand: {}}.entries);

        brandSku[brand].addEntries({'name': item.name}.entries);
        brandSku[brand].addEntries({'rows': []}.entries);
      }

      brandSku[brand]['rows']!.add(item);
    }
  }

  String printSkus(List<Sku> skus) {
    StringBuffer sb = StringBuffer();
    for (var sku in skus) {
      sb.writeln(
          '[${sku.skuId}] fresh: ${sku.fresh}, damaged: ${sku.damaged}, old: ${sku.old}, recalled: ${sku.recalled}');
    }
    return sb.toString();
  }

  void validatePayload() {
    List<Sku> receivingSkusList =
        skus.where((sku) => sku.hasValidReceivedValues()).toList();
    List<Sku> nonReceivingSkusList =
        skus.where((sku) => sku.hasValidUnreceivedValues()).toList();

    if (selectedReferenceType == 'Stock Arrival') {
      if (receivingSkusList.isNotEmpty || nonReceivingSkusList.isNotEmpty) {
        StockArrivalPayload(receivingSkusList, nonReceivingSkusList);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogNotice(
              title: 'Missing Information',
              notice:
                  'Please fill in the SKU quantity for Stock Arrival before proceeding.',
            );
          },
        );
      }
    } else {
      StockTransferPayload();
    }
  }

  void StockTransferPayload() {
    String typeId = 'tr';
    String siteId = selectedSourceSite.id;
    String type = 'transfer';
    String refId = selectectedTransferOut.id;
    String remark = this.remark;

    String receiving = '''[
    ${transferSkus.map((sku) => jsonEncode(sku.toPostJsonReceived())).join(',')}]''';

    String nonReceiving = '''[
    ${transferSkus.map((sku) => jsonEncode(sku.toPostJsonUnreceived())).join(',')}]''';

    String payload = '''{
    "type_id": "$typeId",
    "site_id": "$siteId",
    "type": "$type",
    "ref_id": "$refId",
    "remark": "$remark",
    "receivingSkus": $receiving,
    "nonReceivingSkus": $nonReceiving
  }''';

    createTransfer(payload);
    debugPrint('Payload: $payload');
  }

  void StockArrivalPayload(
      List<Sku> receivingSkusList, List<Sku> nonReceivingSkusList) {
    String typeId = 'ad';
    String siteId = selectedSourceSite.id;
    String type = 'stock arrival';
    String refId = poId;
    String remark = this.remark;

    String receivingSkus = receivingSkusList.isNotEmpty
        ? '[${receivingSkusList.map((sku) => jsonEncode(sku.toPostJsonReceived())).join(',')}]'
        : '[]'; // Ensure to create an empty array if no valid receiving SKUs

    String nonReceivingSkus = nonReceivingSkusList.isNotEmpty
        ? '[${nonReceivingSkusList.map((sku) => jsonEncode(sku.toPostJsonUnreceived())).join(',')}]'
        : '[]'; // Ensure to create an empty array if no non-receiving SKUs

    String payload = '''{
    "type_id": "$typeId",
    "site_id": "$siteId",
    "type": "$type",
    "ref_id": "$refId",
    "remark": "$remark",
    "receivingSkus": $receivingSkus,
    "nonReceivingSkus": $nonReceivingSkus
  }''';

    createTransfer(payload);
    debugPrint('Payload: $payload');
  }

  Future<void> createTransfer(String payload) async {
    setState(() {
      _isLoading = true;
    });
    if (_token == null) return;

    final String? domainName = await TokenUtil.getDomainName();
    if (domainName == null) return;

    String url = '$domainName/api/tin_tout/transfer_in/create';

    final dio = Dio();
    dio.options.headers = {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await dio.post(
        url,
        data: payload,
      );

      if (response.statusCode == 200) {
        errMsg = 'You have successfully created transfer in';
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogActionSuccess(
              title: 'Success!',
              subtitle: errMsg,
            );
          },
        ).whenComplete(
          () {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.homepage, (route) => false);
          },
        );
      } else {
        debugPrint('Failed to fetch API. Status code: ${response.statusCode}');
        if (response.statusCode == 401) {
          Navigator.pushNamed(context, AppRoutes.login);
        }
      }
    } catch (e) {
      debugPrint('Failed to fetch or parse SKUs: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: AppBar(
                centerTitle: true,
                title: Text(
                  'Create Transfer In',
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
            body: Stack(
              children: [
                WillPopScope(
                  onWillPop: () async {
                    bool willPop = false;
                    willPop = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogConfirmation();
                          },
                        ) ??
                        false;
                    return willPop;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                  text: 'Home ',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pop(context, false);
                                      Navigator.pop(context, false);
                                    },
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    color: textColorTertiary,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: '> ${titleCheck(TYPE)}',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pop(context);
                                          }),
                                    TextSpan(
                                        text: '> ${titleCheck(TITLE)}',
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                          color: textColorTertiary,
                                        )),
                                  ]),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ListTile(
                                    dense: true,
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Select Source Site',
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
                                    subtitle: selectedSourceSite.id == ''
                                        ? GridView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                              childAspectRatio: 2,
                                              mainAxisSpacing: 8,
                                              crossAxisSpacing: 8,
                                            ),
                                            itemCount:
                                                sourceSitesWarehouse.length,
                                            itemBuilder: (context, index) {
                                              final site =
                                                  sourceSitesWarehouse[index];

                                              var siteSelect = site.select;
                                              final siteID = site.id;
                                              final siteName = site.name;

                                              var cardColor = siteSelect
                                                  ? biruImran4
                                                  : biruImran;
                                              var fontColor = siteSelect
                                                  ? biruImran
                                                  : white;

                                              return InkWell(
                                                splashColor: white,
                                                onTap: () async {
                                                  setState(() {
                                                    siteSelect = !siteSelect;
                                                    site.select = siteSelect;

                                                    if (siteSelect) {
                                                      selectedSourceSite =
                                                          Warehouse.from(site);
                                                      //fetchTransferOuts();
                                                    } else {
                                                      selectedSourceSite
                                                          .clear();
                                                      selectectedTransferOut
                                                          .clear();
                                                    }
                                                  });

                                                  debugPrint(
                                                      'SITE SELECT :: ${siteSelect.toString()}');
                                                  debugPrint(
                                                      'SITE SELECTEDSITE :: ${selectedSourceSite.toString()}');
                                                },
                                                child: Material(
                                                  elevation: 3,
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24),
                                                        border: Border.all(
                                                            color: fontColor,
                                                            width: 1),
                                                        color:
                                                            cardColor), // Set card color
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: AutoSizeText(
                                                              siteID,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        fontColor,
                                                                  ),
                                                              maxLines: 1,
                                                              minFontSize: 1,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: AutoSizeText(
                                                              siteName,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .labelSmall!
                                                                  .copyWith(
                                                                    color:
                                                                        fontColor,
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
                                            })
                                        : InkWell(
                                            splashColor: biruImran,
                                            onTap: () async {
                                              setState(() {
                                                for (var site
                                                    in sourceSitesWarehouse) {
                                                  final siteID = site.id;

                                                  if (siteID ==
                                                      selectedSourceSite.id) {
                                                    site.select = false;
                                                    break;
                                                  }
                                                }

                                                selectedSourceSite.select =
                                                    false;
                                                selectedSourceSite.clear();
                                                selectedReferenceType = '';
                                                transferOuts.clear();
                                                selectectedTransferOut.clear();
                                                brandSku.clear();
                                                transferSkus.clear();
                                              });
                                            },
                                            child: Material(
                                              elevation: 3,
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              color: Colors.transparent,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                    border: Border.all(
                                                        color: biruImran,
                                                        width: 1),
                                                    color:
                                                        biruImran4), // Set card color
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AutoSizeText(
                                                        selectedSourceSite.id,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: biruImran,
                                                            ),
                                                        maxLines: 1,
                                                        minFontSize: 1,
                                                      ),
                                                      AutoSizeText(
                                                        selectedSourceSite.name,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelSmall!
                                                            .copyWith(
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
                                          )),
                                selectedSourceSite.id != ''
                                    ? ListTile(
                                        dense: true,
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Select Reference Type',
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
                                        subtitle: GridView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            childAspectRatio: 2,
                                            mainAxisSpacing: 8,
                                            crossAxisSpacing: 8,
                                          ),
                                          itemCount:
                                              selectedReferenceType.isNotEmpty
                                                  ? 1
                                                  : refrerenceTypes.length,
                                          itemBuilder: (context, index) {
                                            final types =
                                                selectedReferenceType.isNotEmpty
                                                    ? selectedReferenceType
                                                    : refrerenceTypes[index];

                                            final typeSelect = (types ==
                                                selectedReferenceType);
                                            final cardColor = typeSelect
                                                ? biruImran4
                                                : biruImran;
                                            final fontColor =
                                                typeSelect ? biruImran : white;

                                            return InkWell(
                                              splashColor: white,
                                              onTap: () async {
                                                setState(() {
                                                  if (selectedReferenceType ==
                                                      types) {
                                                    // Clear everything when deselecting
                                                    selectedReferenceType = '';
                                                    transferOuts.clear();
                                                    brandSku.clear();
                                                    transferSkus.clear();
                                                    selectectedTransferOut
                                                        .clear();
                                                    controllers
                                                        .clear(); // Clear text controllers
                                                  } else {
                                                    // Clear previous data before setting new type
                                                    transferOuts.clear();
                                                    brandSku.clear();
                                                    transferSkus.clear();
                                                    selectectedTransferOut
                                                        .clear();
                                                    controllers
                                                        .clear(); // Clear text controllers
                                                    selectedReferenceType =
                                                        types;

                                                    // Fetch data immediately based on new type
                                                    if (types == 'Transfer') {
                                                      fetchTransferOuts();
                                                    } else if (types ==
                                                        'Stock Arrival') {
                                                      fetchSkus();
                                                    }
                                                  }
                                                });

                                                debugPrint(
                                                    'types SELECT :: $selectedReferenceType');
                                              },
                                              // onTap: () async {
                                              //   if (selectedReferenceType =='') {
                                              //     transferOuts.clear();
                                              //     brandSku.clear();
                                              //     transferSkus.clear();
                                              //     selectectedTransferOut.clear();
                                              //   }
                                              //   setState(() {
                                              //     if (selectedReferenceType ==
                                              //         types) {
                                              //       selectedReferenceType = '';
                                              //     } else {
                                              //       selectedReferenceType =
                                              //           types;
                                              //     }
                                              //   });

                                              //   debugPrint(
                                              //       'types SELECT :: $selectedReferenceType');
                                              // },
                                              child: Material(
                                                elevation: 3,
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                    border: Border.all(
                                                        color: fontColor,
                                                        width: 1),
                                                    color: cardColor,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            types,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleLarge!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      fontColor,
                                                                ),
                                                            maxLines: 1,
                                                            minFontSize: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ))
                                    : SizedBox.shrink(),
                                buildForm(),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (selectedReferenceType == 'Transfer')
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: biruImran,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                          vertical: 8.0,
                                        ),
                                      ),
                                      child: Text(
                                        isSwapped
                                            ? 'Reset Table'
                                            : 'No All SKU Condition Received',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                          color: white,
                                        ),
                                      ),
                                      onPressed: () {
                                        swapFreshWithUnreceived();
                                      },
                                    )
                                  : SizedBox.shrink(),
                              SizedBox(width: 16),
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
                                  debugPrint('button pressed');
                                  if (selectedReferenceType == 'Stock Arrival') {
                                    debugPrint('the type is stock arrival');
                                    //parse to Stock Arrival Payload)
                                    if (poId.isEmpty) {
                                      errMsg = 'Please enter PO ID';
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DialogNotice(
                                            title: 'Missing Information',
                                            notice: errMsg,
                                          );
                                        },
                                      );
                                    } else if (remark.isEmpty) {
                                      errMsg = 'Please enter remarks';
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DialogNotice(
                                            title: 'Missing Information',
                                            notice: errMsg,
                                          );
                                        },
                                      );
                                    } else {
                                      validatePayload();
                                    }
                                  } else {
                                    //Transfer case
                                    if (selectectedTransferOut.id == '') {
                                      errMsg = 'Please select reference id';
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DialogNotice(
                                            title: 'Missing Information',
                                            notice: errMsg,
                                          );
                                        },
                                      );
                                    } else if (remark.isEmpty) {
                                      errMsg = 'Please enter remarks';
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DialogNotice(
                                            title: 'Missing Information',
                                            notice: errMsg,
                                          );
                                        },
                                      );
                                    } else {
                                      validatePayload();
                                    }
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }

  Widget createSKUTable(List itemList) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildTableHeader(),
          const SizedBox(height: 8),
          ...itemList.map((item) => _buildTableRow(item)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget createSKUTableTransfer(List itemList) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildTableHeader(),
          const SizedBox(height: 8),
          ...itemList.map((item) => _buildTableRowTransfer(item)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey[200],
      child: Row(
        children: const [
          Expanded(
              flex: 1,
              child: Text('PRINCIPAL ID',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 1,
              child: Text('SKU ID',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child: Text('UOM ID',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child:
                  Text('Fresh', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child: Text('Damaged',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child:
                  Text('Old', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child: Text('Recalled',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child: Text('Unreceived',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildTableRowTransfer(StockItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(item.principalName)),
          SizedBox(width: 8),
          Expanded(flex: 1, child: Text(item.skuId)),
          SizedBox(width: 8),
          Expanded(child: Text(item.uomId)),
          SizedBox(width: 8),
          qtyTextFieldTransfer(item, 'fresh', item.quantity[0].toString()),
          SizedBox(width: 8),
          qtyTextFieldTransfer(item, 'damaged', item.quantity[1].toString()),
          SizedBox(width: 8),
          qtyTextFieldTransfer(item, 'old', item.quantity[2].toString()),
          SizedBox(width: 8),
          qtyTextFieldTransfer(item, 'recalled', item.quantity[3].toString()),
          SizedBox(width: 8),
          qtyTextFieldTransfer(
              item, 'unreceived', item.unreceivedQuantity[0].toString()),
        ],
      ),
    );
  }

  Widget _buildTableRow(Sku item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(item.principalName)),
          SizedBox(width: 8),
          Expanded(flex: 1, child: Text(item.skuId)),
          SizedBox(width: 8),
          Expanded(child: Text(item.uomId)),
          SizedBox(width: 8),
          qtyTextField(item, 'fresh'),
          SizedBox(width: 8),
          qtyTextField(item, 'damaged'),
          SizedBox(width: 8),
          qtyTextField(item, 'old'),
          SizedBox(width: 8),
          qtyTextField(item, 'recalled'),
          SizedBox(width: 8),
          qtyTextField(item, 'unreceived'),
        ],
      ),
    );
  }

  Widget qtyTextField(Sku item, String field) {
    return Expanded(
      child: SizedBox(
        height: 40,
        child: TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              int parsedValue = int.tryParse(value) ?? 0;
              switch (field) {
                case 'fresh':
                  item.fresh = parsedValue;
                  break;
                case 'damaged':
                  item.damaged = parsedValue;
                  break;
                case 'old':
                  item.old = parsedValue;
                  break;
                case 'recalled':
                  item.recalled = parsedValue;
                case 'unreceived':
                  item.unreceived = parsedValue;
                  break;
              }
              debugPrint(
                  'SKU ID: ${item.skuId}, $field: ${parsedValue.toString()}');
            });
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: field == 'unreceived' ? Colors.red : Colors.grey,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: field == 'unreceived' ? Colors.red : Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: field == 'unreceived' ? Colors.red : Colors.blue,
                width: 2,
              ),
            ),
            fillColor: field == 'unreceived' ? Colors.red[50] : null,
            filled: field == 'unreceived',
          ),
        ),
      ),
    );
  }

  Widget qtyTextFieldTransfer(StockItem item, String field, String value) {
    // final String key = '${item.skuId}-$field';

    if (!controllers.containsKey(item.skuId)) {
      controllers[item.skuId] = {};
    }
    if (!controllers[item.skuId]!.containsKey(field)) {
      controllers[item.skuId]![field] = TextEditingController(text: value);
    }

    return Expanded(
      child: SizedBox(
        height: 40,
        child: TextFormField(
          controller: controllers[item.skuId]![field],
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              int parsedValue = int.tryParse(value) ?? 0;
              switch (field) {
                case 'fresh':
                  item.quantity[0] = parsedValue;
                  break;
                case 'damaged':
                  item.quantity[1] = parsedValue;
                  break;
                case 'old':
                  item.quantity[2] = parsedValue;
                  break;
                case 'recalled':
                  item.quantity[3] = parsedValue;
                  break;
                case 'unreceived':
                  item.unreceivedQuantity[0] = parsedValue;
                  break;
              }
              debugPrint(
                  'SKU ID: ${item.skuId}, $field: ${parsedValue.toString()}');
            });
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: field == 'unreceived' ? Colors.red : Colors.grey,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: field == 'unreceived' ? Colors.red : Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: field == 'unreceived' ? Colors.red : Colors.blue,
                width: 2,
              ),
            ),
            fillColor: field == 'unreceived' ? Colors.red[50] : null,
            filled: field == 'unreceived',
          ),
        ),
      ),
    );
  }

  Widget StockArrival() {
    //fetchSkus();
    return Column(
      children: [
        ListTile(
          dense: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please enter PO ID',
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
          subtitle: TextField(
            onChanged: (value) {
              setState(() {
                poId = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Enter PO ID',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        ListTile(
          dense: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please enter remarks',
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
          subtitle: TextField(
            onChanged: (value) {
              setState(() {
                remark = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Enter remarks',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        // createSKUTable(skus),
        ExpansionPanelList.radio(
          children: brandSku.entries.map((inventory) {
            final brand = inventory.key;
            final name = inventory.value["name"];
            final items = inventory.value["rows"];

            return principalRows(brand: brand, name: name, items: items);
          }).toList(),
        )
      ],
    );
  }

  Widget StockTransfer() {
    // fetchTransferOutDetails();
    //fetchSkus();
    return Column(
      children: [
        ListTile(
          dense: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                  dense: true,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Reference Id',
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
                  subtitle: selectectedTransferOut.id == ''
                      ? GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                          itemCount: transferOuts.length,
                          itemBuilder: (context, index) {
                            final ref = transferOuts[index];

                            var refSelect = ref.selected;
                            final siteID = ref.id;

                            var cardColor = refSelect ? biruImran4 : biruImran;
                            var fontColor = refSelect ? biruImran : white;

                            return InkWell(
                              splashColor: white,
                              onTap: () async {
                                setState(() {
                                  refSelect = !refSelect;
                                  ref.selected = refSelect;

                                  if (refSelect) {
                                    selectectedTransferOut =
                                        TransferOut.from(ref);
                                    fetchTransferOutDetails();
                                  } else {
                                    selectectedTransferOut.clear();
                                  }
                                });
                              },
                              child: Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                          color: fontColor, width: 1),
                                      color: cardColor), // Set card color
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: AutoSizeText(
                                            siteID,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: fontColor,
                                                ),
                                            maxLines: 1,
                                            minFontSize: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                      : InkWell(
                          splashColor: biruImran,
                          onTap: () async {
                            setState(() {
                              for (var site in transferOuts) {
                                final siteID = site.id;

                                if (siteID == selectectedTransferOut.id) {
                                  site.selected = false;
                                  break;
                                }
                              }

                              selectectedTransferOut.selected = false;
                              selectectedTransferOut.clear();
                              transferSkus.clear();
                              brandSku.clear();
                            });
                          },
                          child: Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border:
                                      Border.all(color: biruImran, width: 1),
                                  color: biruImran4), // Set card color
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      selectectedTransferOut.id,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: biruImran,
                                          ),
                                      maxLines: 1,
                                      minFontSize: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
            ],
          ),
        ),
        ListTile(
          dense: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please enter remarks',
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
          subtitle: TextField(
            onChanged: (value) {
              setState(() {
                remark = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Enter remarks',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        ListTile(
          dense: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sender remarks',
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
          subtitle: TextField(
            enabled: false,
            controller:
                TextEditingController(text: selectectedTransferOut.remark),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white, // Or your desired background color
              disabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.grey[400]!), // Normal border color
              ),
            ),
            style: TextStyle(
              color: Colors.black, // Normal text color instead of grey
            ),
          ),
        ),
        // createSKUTable(skus),
        ExpansionPanelList.radio(
          children: brandSku.entries.map((inventory) {
            final brand = inventory.key;
            final name = inventory.value["name"];
            final items = inventory.value["rows"];

            return principalRowsTransfer(
                brand: brand, name: name, items: items);
          }).toList(),
        ),
      ],
    );
  }

  ExpansionPanelRadio principalRows({
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
      body: createSKUTable(items),
    );
  }

  ExpansionPanelRadio principalRowsTransfer({
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
      body: createSKUTableTransfer(items),
    );
  }

  Widget buildForm() {
    if (selectedSourceSite.id.isEmpty) {
      return SizedBox.shrink();
    }
    switch (selectedReferenceType) {
      case 'Stock Arrival':
        // Fetch SKUs only when Stock Arrival is first selected
        if (skus.isEmpty) {
          fetchSkus();
        }
        return StockArrival();
      case 'Transfer':
        // Fetch SKUs only when Transfer is first selected
        // if (transferOuts.isEmpty) {
        //   debugPrint('transferOuts is empty');
        //   fetchTransferOuts();
        // }
        return StockTransfer();
    }

    return SizedBox.shrink();
  }
}
