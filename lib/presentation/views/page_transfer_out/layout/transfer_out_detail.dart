// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables, deprecated_member_use, unnecessary_brace_in_string_interps

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/data/models/transfer_out.dart';

import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';

import '../../../../data/models/stock_item.dart';
import '../../page_transfer_inout/layout/transfer_inout_detail.dart';

const String TYPE = TRANSFER_OUT;

class TransferOutDetailView extends StatefulWidget {
  const TransferOutDetailView({
    super.key,
    required this.status,
    required this.id,
    required this.createdAt,
  });

  final String status;
  final String id;
  final String createdAt;

  @override
  State<TransferOutDetailView> createState() => _TransferOutDetailViewState();
}

class _TransferOutDetailViewState extends State<TransferOutDetailView> {
  TransferOut toDetails = TransferOut(
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

  List<StockItem> toSkus = [];

  bool isExpanded = false;

  String? token;
  String errMsg = "Unknown error";

  @override
  void initState() {
    super.initState();
    getToken().then((_) {
      fetchAPI();
    });
    checkStatus(widget.status);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkStatus(String status) {
    if (status == 'pending_wa_ack') {
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Pending Acknowledgement'),
              content: Text(
                  'You can acknowledge ${widget.id} Transfer In/Out Acknowledgement screen.\n Do you want to proceed?'),
              actions: [
                TextButton(
                  child: Text('No', style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Yes', style: TextStyle(color: biruImran)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransferInOutDetailView(
                          transferId: widget.id,
                          type: TYPE,
                          
                          status: widget.status,
                          createdAt: widget.createdAt,
                          
                          doublePop: true
                        )
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  Future<void> getToken() async {
    await TokenUtil.getToken().then((v) {
      setState(() {
        token = v;
      });
    });
  }

  Future<void> fetchAPI() async {
    if (token == null) {
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
      return;
    }

    int statusCode = 505;

    final String? _domainName = await TokenUtil.getDomainName();
    String url = '${_domainName}/api/tin_tout/transfer_out/o/${widget.id}';
    final Dio dio = Dio();

    try {
      debugPrint("URL :: $url");
      final response = await dio
          .get(
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            }),
            url,
          )
          .timeout(Duration(seconds: 5));

      statusCode = response.statusCode!;

      if (statusCode == 200 || statusCode == 201) {
        final jsonData = response.data;

        setState(() {
          toDetails = TransferOut.fromJson( jsonData['transfer_out'] );
          toSkus = (jsonData['details'] as List)
            .map((e) => StockItem.fromJson(e))
            .toList();
        });

      } else {
        debugPrint('Failed to fetch API. Status code: ${response.statusCode}');
        debugPrint('Error Body: ${response.data}');
        
        FloatingSnackBar(
            message: 'Token Expired. Please login back to the system.',
            context: context);

        Navigator.pushNamed(context, AppRoutes.login);
      }
    } on TimeoutException {
      debugPrint("ERROR TIMEOUT :: Action took a long time to run (5 seconds).");
      errMsg = 'This may due to server hickups. Please wait for a while.';

      FloatingSnackBar(
          message: 'Encountered an error. $errMsg', context: context);

      Navigator.of(context).pop();

    } on DioException catch (e) {
      debugPrint("ERROR DIO STATUSCODE :: ${statusCode.toString()}");
      debugPrint("ERROR DIO :: ${e.toString()}");

      errMsg = 'This may due to server hickups. Please wait for a while.';

      FloatingSnackBar(
          message: 'Encountered an error. $errMsg', context: context);

      Navigator.of(context).pop();
    

    } catch (e) {
      debugPrint("ERROR CATCH :: ${e.toString()}");
      errMsg = 'This may due to server hickups. Please wait for a while.';

      FloatingSnackBar(
          message: 'Encountered an error. $errMsg', context: context);

      Navigator.of(context).pop();
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
                  'Transfer Out Detail',
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
                                TextSpan(text: '> ${widget.id}'),
                              ]),
                        ),
                      ),
                    ),

                    if(widget.status == TIO_PENDING_APPROVAL)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: colorOrenAiman, borderRadius: BorderRadius.circular(24)),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Icon(
                                  FontAwesomeIcons.warning,
                                  color: whiteColor,
                                )),
                                Expanded(
                                  flex: 5,
                                  child: AutoSizeText(
                                    "Please request approval from HQAdmin",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: whiteColor),
                                    minFontSize: 1,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    if(widget.status == TIO_PENDING_WA_ACK)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
                        child: InkWell(
                          onTap:() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransferInOutDetailView(
                                  transferId: widget.id,
                                  type: TYPE,
                                  
                                  status: widget.status,
                                  createdAt: widget.createdAt,
                          
                                  doublePop: true
                                )
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                            color: biruImran2, borderRadius: BorderRadius.circular(24)),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Icon(
                                      FontAwesomeIcons.info,
                                      color: whiteColor,
                                    )
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: AutoSizeText(
                                      "Acknowledge ${widget.id} Transfer In/Out Acknowledgement screen.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: whiteColor),
                                      minFontSize: 1,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Expanded(
                                    child: Icon(
                                      FontAwesomeIcons.arrowRight,
                                      color: whiteColor,
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    createDetailsTable(
                      id : toDetails.id,
                      date : toDetails.date,

                      fromSiteId : toDetails.fromSiteId,
                      toSiteId : toDetails.toSiteId,

                      status : toDetails.status,
                      remark : toDetails.remark,

                      createdBy : toDetails.createdBy,
                      createdAt : toDetails.createdAt,
                    ),

                    createSKUTable('SKU List', toSkus),
                  ],
                ),
              ),
            )));
  }

  Widget createDetailsTable({
    required String id,
    required String date,
    
    required String fromSiteId,
    required String toSiteId,

    required String status,
    required String remark,

    required String createdBy,
    required String createdAt,
  }) {
    Column detailsRow(String title, String value) {
      return Column(
        children: [
          Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: biruImran,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: black,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }

    return ExpansionTile(
      showTrailingIcon: false,
      tilePadding: EdgeInsets.all(0),
      onExpansionChanged: (bool expanded) {
        setState(() {
          isExpanded = expanded;
        });
      },
      initiallyExpanded: true,
      title: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: biruImran,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Details',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Changed to white for better contrast
              ),
            ),
            Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.white, // Changed to white for better contrast
            )
          ],
        ),
      ),
      children: [
        detailsRow('Transfer Out ID', id),
        detailsRow('Date', date),
        detailsRow('From', fromSiteId),
        detailsRow('To', toSiteId),

        detailsRow('Status', status),
        detailsRow('Remark', remark),
        detailsRow('Transfer Out By', createdBy),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey[200],
      child: Row(
        children: const [
          Expanded(
              flex: 2,
              child: Text('SKU ID',
                style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child: Text('UOM ID',
                style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child: Text('Fresh',
                style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child: Text('Damaged',
                style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child: Text('Old',
                style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child: Text('Recalled',
                style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildTableRow(StockItem item) {
    List quantities = item.quantity;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(item.skuId)),
          Expanded(child: Text(item.uomId)),
          Expanded(child: Text('${quantities[0]}')),
          Expanded(child: Text('${quantities[1]}')),
          Expanded(child: Text('${quantities[2]}')),
          Expanded(child: Text('${quantities[3]}')),
        ],
      ),
    );
  }

  Widget createSKUTable(String title, List itemList) {
    return ExpansionTile(
      showTrailingIcon: false,
      tilePadding: EdgeInsets.all(0),
      onExpansionChanged: (bool expanded) {
        setState(() {
          isExpanded = expanded;
        });
      },
      initiallyExpanded: true,
      title: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: biruImran,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.white,
            )
          ],
        ),
      ),
      children: [
        Padding(
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
