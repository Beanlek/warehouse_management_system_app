// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables, deprecated_member_use, unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/data/models/sku.dart';
import 'package:warehouse/page_homepage/widget/dialog_Widget.dart';
import 'package:warehouse/routes/routes.dart';

import 'package:http/http.dart' as http;

import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';

import '../data/models/warehouse.dart';

const String TYPE = TRANSFER_IN;
const String TITLE = TRANSFER_IN_CREATE;

class TransferInCreateView extends StatefulWidget {
  const TransferInCreateView({
    super.key,
  });

  @override
  State<TransferInCreateView> createState() => _TransferInCreateViewState();
}

class _TransferInCreateViewState extends State<TransferInCreateView> {
  List<Warehouse> sourceSitesWarehouse = [];

  List<String> refrerenceTypes = ['Stock Arrival', 'Transfer'];
  Warehouse selectedSourceSite = Warehouse(id: '', name: '');

  String selectedReferenceType = '';
  String poId = '';
  String remark = '';

  List<Sku> skus = [];

  bool isExpanded = false;
  bool _isLoading = true;

  String? _token;

  @override
  void initState() {
    super.initState();
    _getToken().whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
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
      await fetchSites(_token);
    }
  }

  Future<void> fetchSites(String? token) async {
    final String? domainName = await TokenUtil.getDomainName();

    String url = '$domainName/api/dataLookup/sites/list';
    final uri = Uri.parse(url);

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

  Future<void> fetchSkus() async {
    if (_token == null) return;

    final String? domainName = await TokenUtil.getDomainName();
    if (domainName == null) return;

    String url =
        '$domainName/api/tin_tout/transfer_in/tablelist?without_base_uom=yes';
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
            skus = skusRaw.take(10).map((sku) => Sku.fromJson(sku)).toList();
          });
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

  String printSkus(List<Sku> skus) {
    StringBuffer sb = StringBuffer();
    for (var sku in skus) {
      sb.writeln(
          '[${sku.skuId}] fresh: ${sku.fresh}, damaged: ${sku.damaged}, old: ${sku.old}, recalled: ${sku.recalled}');
    }
    return sb.toString();
  }

  bool validatePayload() {
    List<Sku> receivingSkusList =
        skus.where((sku) => sku.hasValidReceivedValues()).toList();
    List<Sku> nonReceivingSkusList =
        skus.where((sku) => sku.hasValidUnreceivedValues()).toList();

    if (receivingSkusList.isNotEmpty || nonReceivingSkusList.isNotEmpty) {
      StockArrivalPayload(receivingSkusList, nonReceivingSkusList);
      return true;
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please make sure to fill at least one SKU.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
     return false; 
    }
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

    debugPrint('Payload: $payload');
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
            floatingActionButton: FloatingActionButton(onPressed: () {
              debugPrint('SKUs: ${printSkus(skus)}');
              if (selectedReferenceType == 'Stock Arrival') {
                //parse to Stock Arrival Payload)
                if(poId.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please enter PO ID.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                else{
                  validatePayload();
                }
              } else {
                //parse to Transfer Payload
                // TransferPayload();
                debugPrint('Transfer Payload BOOM!');
              }
            }),
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
                    );
                    return willPop;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
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
                          ListTile(
                              dense: true,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        childAspectRatio: 2,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                      ),
                                      itemCount: sourceSitesWarehouse.length,
                                      itemBuilder: (context, index) {
                                        final site =
                                            sourceSitesWarehouse[index];

                                        var siteSelect = site.select;
                                        final siteID = site.id;
                                        final siteName = site.name;

                                        var cardColor =
                                            siteSelect ? biruImran4 : biruImran;
                                        var fontColor =
                                            siteSelect ? biruImran : white;

                                        return InkWell(
                                          splashColor: white,
                                          onTap: () async {
                                            setState(() {
                                              siteSelect = !siteSelect;
                                              site.select = siteSelect;

                                              if (siteSelect) {
                                                selectedSourceSite =
                                                    Warehouse.from(site);
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
                                                      BorderRadius.circular(24),
                                                  border: Border.all(
                                                      color: fontColor,
                                                      width: 1),
                                                  color:
                                                      cardColor), // Set card color
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: fontColor,
                                                            ),
                                                        maxLines: 1,
                                                        minFontSize: 1,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        siteName,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelSmall!
                                                            .copyWith(
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

                                          selectedSourceSite.select = false;
                                          selectedSourceSite.clear();
                                        });
                                      },
                                      child: Material(
                                        elevation: 3,
                                        borderRadius: BorderRadius.circular(24),
                                        color: Colors.transparent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              border: Border.all(
                                                  color: biruImran, width: 1),
                                              color:
                                                  biruImran4), // Set card color
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  selectedSourceSite.id,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 2,
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                    ),
                                    itemCount: selectedReferenceType.isNotEmpty
                                        ? 1
                                        : refrerenceTypes.length,
                                    itemBuilder: (context, index) {
                                      final types =
                                          selectedReferenceType.isNotEmpty
                                              ? selectedReferenceType
                                              : refrerenceTypes[index];

                                      final typeSelect =
                                          (types == selectedReferenceType);
                                      final cardColor =
                                          typeSelect ? biruImran4 : biruImran;
                                      final fontColor =
                                          typeSelect ? biruImran : white;

                                      return InkWell(
                                        splashColor: white,
                                        onTap: () async {
                                          setState(() {
                                            if (selectedReferenceType ==
                                                types) {
                                              selectedReferenceType = '';
                                            } else {
                                              selectedReferenceType = types;
                                            }
                                          });

                                          debugPrint(
                                              'types SELECT :: $selectedReferenceType');
                                        },
                                        child: Material(
                                          elevation: 3,
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              border: Border.all(
                                                  color: fontColor, width: 1),
                                              color: cardColor,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: AutoSizeText(
                                                      types,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                    },
                                  ))
                              : SizedBox.shrink(),
                          buildForm(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  Widget createSKUTable(List itemList) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTableHeader(),
              const SizedBox(height: 8),
              ...itemList.map((item) => _buildTableRow(item)),
              const SizedBox(height: 8),
            ],
          ),
        ),
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
        createSKUTable(skus),
      ],
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
        return Text('Transfer selected');
    }

    return SizedBox.shrink();
  }
}
