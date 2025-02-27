// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/QR_code/layout/qr_code_adhocReturn.dart';
import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/color.dart';

class AdhocReturnDetailsPage extends StatefulWidget {
  const AdhocReturnDetailsPage(
      {super.key, required this.allotmentId, required this.status});
  final String allotmentId;
  final String status;

  @override
  State<AdhocReturnDetailsPage> createState() => _AdhocReturnDetailsPageState();
}

class _AdhocReturnDetailsPageState extends State<AdhocReturnDetailsPage> {
  List<Map<String, dynamic>> allotments = [];
  Map<String, dynamic> adhocDetails = {};
  Map<String, dynamic> acknowledgeDetails = {};
  List<Map<String, dynamic>> itemDetails = [];
  List<Map<String, dynamic>> allotmentDetails = [];
  List<Map<String, dynamic>> dataToBePass = [];
  bool isExpanded = false;
  bool allItemsChecked = false;

  @override
  void initState() {
    super.initState();
    fetchAdhocReturnDetails(widget.allotmentId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Adhoc Return Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorFirst,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: boxDecorationWithShadow(
                  backgroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Adhoc Return Information',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildInfoContainer(
                                'Adhoc Return ID',
                                adhocDetails['id'],
                                Icons.info,
                              ),
                              _buildInfoContainer(
                                'Van ID',
                                adhocDetails['van_id'],
                                Icons.directions_car,
                              ),
                              _buildInfoContainer(
                                'Date',
                                adhocDetails['date'],
                                Icons.calendar_today,
                              ),
                              _buildInfoContainer(
                                'Description',
                                adhocDetails['desc'],
                                Icons.description,
                              ),
                              _buildInfoContainer(
                                'Status',
                                adhocDetails['status'],
                                Icons.assignment_turned_in_outlined,
                              ),
                              _buildInfoContainer(
                                'Time Created',
                                adhocDetails['createdAt'],
                                Icons.access_time,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         const Text(
                      //           'Status History',
                      //           style: TextStyle(
                      //             fontSize: 18.0,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.black,
                      //           ),
                      //         ),
                      //         const SizedBox(height: 8),
                      //         _buildInfoContainer(
                      //           'Created By',
                      //           adhocDetails['created_by'],
                      //           Icons.timer,
                      //         ),
                      //         _buildInfoContainer(
                      //           'Requested',
                      //           choosedAllotment['packed_by'],
                      //           Icons.person,
                      //         ),
                      //         _buildInfoContainer(
                      //           'Added to Picklist At',
                      //           choosedAllotment['packed_at'],
                      //           Icons.access_time,
                      //         ),
                      //         _buildInfoContainer(
                      //           'Sent for Picking At',
                      //           choosedAllotment['created_at'],
                      //           Icons.send,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35),
              const Text(
                'Allotment Items:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildItemTable(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: GestureDetector(
          onTap: () {
            if (allItemsChecked) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QRScannerPageAdhocReturn(
                          vanID: adhocDetails['van_id'],
                          refID: adhocDetails['id'], dataArr: itemDetails,
                        )),
              );
            } else {
              // Show a message or any other indication that all items need to be checked first
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: allItemsChecked ? colorFirst : Colors.grey,
              border: const Border(
                bottom: BorderSide(color: Colors.white),
                left: BorderSide(color: Colors.white),
                top: BorderSide(color: Colors.white),
                right: BorderSide(color: Colors.white),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Scan QR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildItemTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: DataTable(
          dataRowMaxHeight: 60.0,
          dividerThickness: 1.0,
          border: const TableBorder(
            top: BorderSide(color: Colors.grey),
            left: BorderSide(color: Colors.grey),
            right: BorderSide(color: Colors.grey),
            bottom: BorderSide(color: Colors.grey),
          ),
          headingRowColor: WidgetStateProperty.all(colorFirst),
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          columns: [
            const DataColumn(
              label: Text(
                'SKU ID',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              tooltip: 'Stock Keeping Unit',
            ),
            const DataColumn(
              label: Text(
                'UOM ID',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              tooltip: 'Unit of Measure',
            ),
            const DataColumn(
              label: Text(
                'Requested Qty',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              tooltip: 'Requested Quantity',
            ),
            const DataColumn(
              label: Text(
                'Stock Take',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              tooltip: 'Stock Take',
            ),
          ],
          rows: itemDetails.asMap().entries.map((entry) {
            final index = entry.key;
            final details = entry.value;
            final isOddRow = index % 2 == 0;

            return DataRow(
              color: isOddRow ? WidgetStateProperty.all(Colors.white) : null,
              cells: [
                DataCell(Text(details['sku_id'] ?? 'N/A')),
                DataCell(Text(details['uom_id'] ?? 'N/A')),
                DataCell(Text('${details['requested_qty'] ?? 'N/A'}')),
                DataCell(
                  TextField(
                    controller: TextEditingController(
                      text: '${details['quantity'][0] ?? 'N/A'}',
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        details['quantity'][0] = newValue;
                        print(details['quantity'][0]);
                      });
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  bool _areAllItemsChecked() {
    for (final item in itemDetails) {
      if (!(item['checked'] ?? false)) {
        return false;
      }
    }
    return true;
  }

  Future<void> fetchAdhocReturnDetails(String allotmentId) async {
    final String? token = await TokenUtil.getToken();
    final String? domainName = await TokenUtil.getDomainName();

    String allotmentUrl =
        '$domainName/api/van/stock/reduce/adhoc/o/';
    final allotmentUri = Uri.parse('$allotmentUrl$allotmentId');
    print('allotmentId : $allotmentId');

    final allotmentResponse = await http.get(allotmentUri, headers: {'Authorization': 'Bearer $token'});

    if (allotmentResponse.statusCode == 200) {
      try {
        final adhocReturnAPI = jsonDecode(allotmentResponse.body);
        final detailsData = adhocReturnAPI['data'];
        final adhocReturnDetailsData = adhocReturnAPI['details'];
        final acknowledgeDetailsData = adhocReturnAPI['acknowledge_details'];

        setState(() {
          itemDetails = List<Map<String, dynamic>>.from(detailsData);
          adhocDetails = Map<String, dynamic>.from(adhocReturnDetailsData);
          acknowledgeDetails =
              Map<String, dynamic>.from(acknowledgeDetailsData);
          allItemsChecked = _areAllItemsChecked();
        });

        print('Fetch Allotment API completed');
      } catch (e) {
        print('Failed to parse Allotment JSON: $e');
      }
    } else {
      print(
          'Failed to fetch Allotment API. Status code: ${allotmentResponse.statusCode}');
      print('Allotment Error Body: ${allotmentResponse.body}');
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
    }
  }

  Widget _buildInfoContainer(String label, dynamic value, IconData icon) {
    String formattedValue = '';

    if (value is DateTime) {
      formattedValue = DateFormat.yMMMd().add_jm().format(value);
    } else if (value is String && DateTime.tryParse(value) != null) {
      // If the value is a string and can be parsed as DateTime, parse it
      DateTime dateTimeValue = DateTime.parse(value).add(Duration(hours: int.parse('8')));
      formattedValue = DateFormat.yMMMd().add_jm().format(dateTimeValue);
    } else {
      formattedValue = value.toString();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withAlpha(32),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.blue,
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          formattedValue,
          style: TextStyle(color: Colors.grey.shade800),
        ),
      ),
    );
  }
}
