// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables, deprecated_member_use, unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';

import '../../data/models/stock_item.dart';
import '../../data/models/transfer_in.dart';
import '../../page_transfer_inout/layout/transfer_inout_detail.dart';

const String TYPE = TRANSFER_IN;

class TransferInDetailView extends StatefulWidget {
  const TransferInDetailView({
    super.key,
    required this.tid,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.transferInId,
  });

  final String tid;
  final String type;
  final String status;
  final String createdAt;
  final String transferInId;

  @override
  State<TransferInDetailView> createState() => _TransferInDetailViewState();
}

class _TransferInDetailViewState extends State<TransferInDetailView> {
  TransferIn? transferInData;
  List<StockItem> receivedList = [];
  List<StockItem> unreceivedList = [];

  bool isExpanded = false;

  String? _token;

  @override
  void initState() {
    super.initState();
    getToken().then((_) {
      fetchAPI(_token);
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
                  'You can acknowledge this transfer in Transfer In/Out Acknowledgement screen.\n Do you want to proceed?'),
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
                                type: widget.type,
                                createdAt: widget.createdAt,
                                status: widget.status,
                                transferId: widget.tid,
                              )),
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
    final String? token = await TokenUtil.getToken();
    setState(() {
      _token = token!;
    });
  }

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
    String url =
        '${_domainName}/api/tin_tout/transfer_in/o/${widget.transferInId}';
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
          .timeout(Duration(seconds: 3));

      statusCode = response.statusCode!;

      if (statusCode == 200 || statusCode == 201) {
        //if status ok, update the data
        final jsonData = response.data;

        setState(() {
          transferInData = TransferIn.fromJson(
              jsonData['transfer_in']); //occupy the transfer in data
          receivedList =
              (jsonData['received'] as List) //occupy the received list data
                  .map((e) => StockItem.fromJson(e))
                  .toList();
          unreceivedList =
              (jsonData['unreceived'] as List) //occupy the unreceived list data
                  .map((e) => StockItem.fromJson(e))
                  .toList();
        });

        try {
          debugPrint("RESPONSE JSON :: ${json.toString()}");
        } catch (e) {
          debugPrint('Failed to parse JSON: $e');
        }
      } else {
        debugPrint(
            'Failed to fetch Unacknowledged API. Status code: ${response.statusCode}');
        debugPrint('Error Body: ${json}');

        Navigator.pushNamed(context, AppRoutes.login);
        FloatingSnackBar(
            message: 'Token Expired. Please login back to the system.',
            context: context);
      }
    } on TimeoutException {
      const errMsg = 'This may due to server hickups. Please wait for a while.';

      FloatingSnackBar(
          message: 'Encountered an error. $errMsg', context: context);

      Navigator.of(context).pop();
    } on DioException catch (e) {
      debugPrint("ERROR :: ${e.toString()}");
      const errMsg = 'This may due to server hickups. Please wait for a while.';

      FloatingSnackBar(
          message: 'Encountered an error. $errMsg', context: context);

      Navigator.of(context).pop();
    } catch (e) {
      debugPrint("ERROR :: ${e.toString()}");
      const errMsg = 'This may due to server hickups. Please wait for a while.';

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
                  'Transfer In Detail',
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
                                TextSpan(text: '> ${widget.transferInId}'),
                              ]),
                        ),
                      ),
                    ),
                    createDetailsTable(
                      transferInData?.id ?? '',
                      transferInData?.siteId ?? '',
                      transferInData?.type ?? '',
                      transferInData?.refId ?? '',
                      transferInData?.date ?? '',
                      transferInData?.status ?? '',
                      transferInData?.remark ?? '',
                      transferInData?.createdBy ?? '',
                    ),
                    createSKUTable('Received', receivedList),
                    createSKUTable('Unreceived', unreceivedList),
                  ],
                ),
              ),
            )));
  }

  Widget createDetailsTable(
    String transferInId,
    String siteId,
    String type,
    String referenceId,
    String date,
    String status,
    String remark,
    String transferBy,
  ) {
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
        detailsRow('Transfer In ID', transferInId),
        detailsRow('Site ID', siteId),
        detailsRow('Type', type),
        detailsRow('Reference ID', referenceId),
        detailsRow('Date', date),
        detailsRow('Status', status),
        detailsRow('Remark', remark),
        detailsRow('Transfer By', transferBy),
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
