// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/color.dart';

class AdhocRequestDetailView extends StatefulWidget {
  const AdhocRequestDetailView(
      {super.key, required this.allotmentId, required this.status});
  final String allotmentId;
  final String status;

  @override
  State<AdhocRequestDetailView> createState() => _AdhocRequestDetailViewState();
}

class _AdhocRequestDetailViewState extends State<AdhocRequestDetailView> {
  List<Map<String, dynamic>> allotments = [];
  Map<String, dynamic> choosedAllotment = {};
  List<Map<String, dynamic>> details = [];
  List<Map<String, dynamic>> allotmentDetails = [];
  bool isExpanded = false;
  bool allItemsChecked = false;

  @override
  void initState() {
    super.initState();
    fetchAllotmentDetails(widget.allotmentId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Adhoc Request Details',
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
                                'Adhoc Request Information',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildInfoContainer(
                                'Adhoc Request ID',
                                choosedAllotment['id'],
                                Icons.info,
                              ),
                              _buildInfoContainer(
                                'Van ID',
                                choosedAllotment['van_id'],
                                Icons.directions_car,
                              ),
                              _buildInfoContainer(
                                'Date',
                                choosedAllotment['date'],
                                Icons.calendar_today,
                              ),
                              _buildInfoContainer(
                                'Status',
                                choosedAllotment['status'],
                                Icons.assignment_turned_in_outlined,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Status History',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildInfoContainer(
                                'Packed At',
                                choosedAllotment['packed_at'],
                                Icons.timer,
                              ),
                              _buildInfoContainer(
                                'Added to Picklist By',
                                choosedAllotment['packed_by'],
                                Icons.person,
                              ),
                              _buildInfoContainer(
                                'Added to Picklist At',
                                choosedAllotment['packed_at'],
                                Icons.access_time,
                              ),
                              _buildInfoContainer(
                                'Sent for Picking At',
                                choosedAllotment['created_at'],
                                Icons.send,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Allotment Items:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildItemTable(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        // color: transparentColor,
        child: GestureDetector(
          onTap: () {
            if (allItemsChecked) {
              FloatingSnackBar(message: 'WIP', context: context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => QRScannerPageAllotment(
              //             vanID: choosedAllotment['van_id'],
              //             refID: choosedAllotment['id'],
              //           )),
              // );
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
        width: MediaQuery.of(context).size.width * 0.93,
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
                'Qty',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              tooltip: 'Quantity',
            ),
            if (widget.status == 'unacknowledged')
              DataColumn(
                label: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Transform.scale(
                        scale: 1.5,
                        child: Theme(
                          data: ThemeData(
                            unselectedWidgetColor: Colors
                                .white, // set the color of the checkbox border
                          ),
                          child: Checkbox(
                            checkColor: Colors.blue,
                            value: allItemsChecked,
                            onChanged: (value) {
                              setState(() {
                                allItemsChecked = value!;
                                for (final item in details) {
                                  item['checked'] = value;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                      child: Text(
                        '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          rows: details.asMap().entries.map((entry) {
            final index = entry.key;
            final details = entry.value;
            final isOddRow = index % 2 == 0;

            return DataRow(
              color: isOddRow ? WidgetStateProperty.all(Colors.white) : null,
              cells: [
                DataCell(Text(details['sku_id'] ?? 'N/A')),
                DataCell(Text(details['uom_id'] ?? 'N/A')),
                DataCell(Text('${details['quantity'][0] ?? 'N/A'}')),
                if (widget.status == 'unacknowledged')
                  DataCell(
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          checkColor: Colors.blue,
                          fillColor:
                              const WidgetStatePropertyAll(Colors.white),
                          value: details['checked'] ?? false,
                          onChanged: (value) {
                            setState(() {
                              details['checked'] = value;
                              allItemsChecked = _areAllItemsChecked();
                            });
                          },
                        ),
                      ),
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
    for (final item in details) {
      if (!(item['checked'] ?? false)) {
        return false;
      }
    }
    return true;
  }

  Future<void> fetchAllotmentDetails(String allotmentId) async {
    final String? token = await TokenUtil.getToken();
    final String? domainName = await TokenUtil.getDomainName();

    String allotmentUrl =
        '$domainName/api/allotment/o/';
    final allotmentUri = Uri.parse('$allotmentUrl$allotmentId');

    final allotmentResponse = await http.get(allotmentUri, headers: {'Authorization': 'Bearer $token'});

    if (allotmentResponse.statusCode == 200) {
      try {
        final allotmentJson = jsonDecode(allotmentResponse.body);
        final allotmentData = allotmentJson['allotment'];
        final detailsData = allotmentJson['details'];

        setState(() {
          choosedAllotment = allotmentData;
          details = List<Map<String, dynamic>>.from(detailsData);
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
