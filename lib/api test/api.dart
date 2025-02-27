

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:warehouse/provider/auth.dart';
import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';

class APIView extends StatefulWidget {
  const APIView({super.key});

  @override
  State<APIView> createState() => _APIViewState();
}

class _APIViewState extends State<APIView> {
  Map<String, dynamic> allotment = {};
  List<Map<String, dynamic>> details = [];

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<AuthProvider>(context).token;

    debugPrint('Token: $token'); // Print the token to the console

    return Scaffold(
      appBar: AppBar(
        title: const Text('API Testing'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Allotment ID: ${allotment['id']}'),
            subtitle: Text('Date: ${allotment['date']}'),
          ),
          ListTile(
            title: Text('Van ID: ${allotment['van_id']}'),
            subtitle: Text('Status: ${allotment['status']}'),
          ),
          // Add more ListTile widgets to display other allotment details

          // Display details
          Expanded(
            child: ListView.builder(
              itemCount: details.length,
              itemBuilder: (context, index) {
                final detail = details[index];
                final sequence = detail['sequence'];
                final skuId = detail['sku_id'];
                final uomId = detail['uom_id'];
                final quantity = detail['quantity'][0];

                return ListTile(
                  title: Text('Sequence: $sequence'),
                  subtitle: Text(
                      'SKU ID: $skuId\nUOM ID: $uomId\nQuantity: $quantity'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: () => fetchAPI(token)),
    );
  }

  Future<void> fetchAPI(String? token) async {
    if (token == null) {
      // Handle case where token is not available
      debugPrint('Token is not available. Redirecting to login screen.');
      Navigator.pushNamed(context, AppRoutes.login);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token Expired. Please login back to system.'),
        ),
      );
      return;
    }

    debugPrint('fetch API');
    final String? domainName = await TokenUtil.getDomainName();

    String url =
        '$domainName/api/allotment/o/A0000059258';
    final uri = Uri.parse(url);
    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final allotmentData = json['allotment'];
      final detailsData = json['details'];

      setState(() {
        allotment = allotmentData;
        details = List<Map<String, dynamic>>.from(detailsData);
      });

      debugPrint('fetch API completed');
    } else {
      debugPrint('Failed to fetch API. Status code: ${response.statusCode}');
    }
  }
}
