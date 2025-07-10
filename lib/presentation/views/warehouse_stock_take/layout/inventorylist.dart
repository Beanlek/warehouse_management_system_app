// ignore_for_file: avoid_print, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';
import 'package:warehouse/presentation/views/van_stock_take/widget/modal.dart';
import 'package:warehouse/presentation/widgets/global_dialog.dart';

import '../widget/shimmer_list.dart';

class InventoryList extends StatefulWidget {
  final String id;
  final String warehouseName;

  const InventoryList({super.key, required this.id, required this.warehouseName});

  @override
  _InventoryListState createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  final Map<String, Map<String, List<Map<String, dynamic>>>> _groupedItems = {};
  late TextEditingController _commentController;
  late List<Map<String, dynamic>> _inventoryData = [];
  late String? refID;

  @override
  void initState() {
    super.initState();
    fetchInventoryData(); // Call fetchInventoryData instead of _inventoryFuture
    _commentController = TextEditingController(); // Initialize the controller
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      WillPopScope(
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: null, // Pass null since we're not using a future
                    builder: (context, snapshot) {
                      if (_inventoryData.isEmpty) {
                        // Check if _inventoryData is empty
                        return shimmerList();
                      } else {
                        _groupItems(_inventoryData); // Group items based on inventory data
                        return _buildInventoryList(); // Build the inventory list
                      }
                    },
                  ),
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

    String apiUrl = '$domainName/api/inventory/list/${widget.id}';
      final uri = Uri.parse(apiUrl);

      final response =
          await http.get(uri, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final inventoryData =
            List<Map<String, dynamic>>.from(data['inventory']);

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
      final List<Map<String, dynamic>> inventoryData =
          _inventoryData.map((item) {
        return {
          'brand': item['brand'], // Adding brand field
          'category': item['category'], // Adding category field
          'name': item['name'], // Adding name field
          'quantity': [
            item['quantity'][0]
          ], // Assuming quantity is a list and we need the first element
          'sequence': item['sequence'], // Adding sequence field
          'short_code': item['short_code'], // Adding short_code field
          'sku_id': item['sku_id'],
          'sku_name': item['sku_name'], // Adding sku_name field
          'sub_category': item['sub_category'], // Adding sub_category field
          'uom_id': item['uom_id'],
        };
      }).toList();

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
        throw Exception(
            'Failed to save stocktake. Status code: ${response.statusCode}');
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
          'quantity': [item['quantity'][0]],
          'uom_id': item['uom_id'],
        };
      }).toList();

      final payload = {
        'comment': _commentController
            .text, // Use text property to get the text from TextEditingController
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
      debugPrint(apiUrl);
      debugPrint(jsonEncode(payload));

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SuccessModal(
              buttonText: 'Okay',
              content: 'Successfully acknowledged into WMS log',
              title: 'Success',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            );
          },
        );
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
      String category = item['category'] ?? 'Uncategorized';
      String shortCode = item['short_code'] ?? 'N/A';

      _groupedItems.putIfAbsent(category, () => {});
      _groupedItems[category]!.putIfAbsent(shortCode, () => []);
      _groupedItems[category]![shortCode]!.add(item);
    }
  }

  Widget _buildInventoryList() {
    if (_groupedItems.isEmpty) {
      return const Center(
        child: Text('No inventory data available.'),
      );
    }

    return SingleChildScrollView(
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
                final Map<String, List<Map<String, dynamic>>> shortCodeGroup =
                    _groupedItems[category]!;

                return ExpansionTile(
                  shape: RoundedRectangleBorder(),
                  title: Text(
                    category,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                  children: shortCodeGroup.entries
                      .map((entry) => InventoryGroup(
                            shortCode: entry.key,
                            items: entry.value,
                            onChanged: () {
                              setState(() {});
                            },
                          ))
                      .toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    maxLines: 3,
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your comment...',
                      contentPadding: EdgeInsets.all(12.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmationModal(
                            content: 'Are you sure you want to proceed?',
                            title: 'Acknowledge',
                            confirmText: 'Yes',
                            onConfirm: () {
                              acknowledgeData();
                            },
                            cancelText: 'Cancel',
                            onCancel: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                      // Comment is filled, proceed with saving
                    } else {
                      // Comment is empty, display error message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorModal(
                            buttonText: 'Okay',
                            content: 'Please fill in the comment field.',
                            title: 'Error',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: colorFirst,
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InventoryGroup extends StatefulWidget {
  final String shortCode;
  final List<Map<String, dynamic>> items;
  final VoidCallback? onChanged;

  const InventoryGroup({
    super.key,
    required this.shortCode,
    required this.items,
    this.onChanged,
  });

  @override
  _InventoryGroupState createState() => _InventoryGroupState();
}

class _InventoryGroupState extends State<InventoryGroup> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              widget.shortCode,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: colorFirst,
              ),
            ),
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            trailing: _expanded
                ? const Icon(Icons.keyboard_arrow_up)
                : const Icon(Icons.keyboard_arrow_down),
          ),
          if (_expanded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.items.map((item) {
                return Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha(32),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: SettingItemWidget(
                            title: 'SKU ID',
                            subTitle: item['sku_id'] ?? 'N/A',
                            subTitleTextStyle: const TextStyle(
                              fontSize: 12,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withAlpha(32),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(
                                Icons.list_alt,
                                color: Colors.blue,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SettingItemWidget(
                            title: 'SKU Name',
                            subTitle: item['sku_name'] ?? 'N/A',
                            subTitleTextStyle: const TextStyle(
                              fontSize: 12,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withAlpha(32),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(
                                Icons.description,
                                color: Colors.blue,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SettingItemWidget(
                            title: 'UOM ID',
                            subTitle: item['uom_id'] ?? 'N/A',
                            subTitleTextStyle: const TextStyle(
                              fontSize: 12,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withAlpha(32),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(
                                Icons.category,
                                color: Colors.blue,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: item['quantity'][0].toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                item['quantity'][0] = int.parse(value);
                              });
                              debugPrint(item['quantity']);
                              if (widget.onChanged != null) {
                                widget.onChanged!();
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Quantity',
                              contentPadding: const EdgeInsets.all(8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.blue.withAlpha(32),
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

class SettingItemWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final TextStyle? subTitleTextStyle;
  final Widget? leading;

  const SettingItemWidget({
    super.key,
    required this.title,
    required this.subTitle,
    this.subTitleTextStyle,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: leading,
      title: Text(title),
      subtitle: Text(
        subTitle,
        style: subTitleTextStyle,
      ),
    );
  }
}
