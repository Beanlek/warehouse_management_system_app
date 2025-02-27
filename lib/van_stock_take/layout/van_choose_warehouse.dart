// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:warehouse/van_stock_take/layout/van%20_stock_take_page.dart';

class VanStockTakeChooseWarehouse extends StatefulWidget {
  const VanStockTakeChooseWarehouse({super.key});

  @override
  State<VanStockTakeChooseWarehouse> createState() =>
      _VanStockTakeChooseWarehouseState();
}

class _VanStockTakeChooseWarehouseState
    extends State<VanStockTakeChooseWarehouse> {
  List<Map<String, dynamic>> sitesWarehouse = [];
  late String? _token;

  @override
  void initState() {
    super.initState();
    _getTokenAndFetchData();
  }

  Future<void> _getTokenAndFetchData() async {
    final String? token = await TokenUtil.getToken();
    setState(() {
      _token = token;
    });

    // Call fetchAPI only if the token is available
    if (_token != null) {
      fetchAPI(_token);
    } else {
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
    }
  }

  Future<void> fetchAPI(String? token) async {
    debugPrint('fetch API');
    final String? domainName = await TokenUtil.getDomainName();

    String url = '$domainName/api/dataLookup/sites/list';
    final uri = Uri.parse(url);

    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body);
        final sites = json['sites'];

        setState(() {
          sitesWarehouse = List<Map<String, dynamic>>.from(sites);
        });

        debugPrint('fetch API completed');
      } catch (e) {
        debugPrint('Failed to parse JSON: $e');
      }
    } else {
      debugPrint('Failed to fetch API. Status code: ${response.statusCode}');
      debugPrint('Error Body: ${response.body}');
      Navigator.pushNamed(context, AppRoutes.login);
      FloatingSnackBar(
          message: 'Token Expired. Please login back to the system.',
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            'Van Stock Take',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _buildGridView(),
      ),
    );
  }

  Widget _buildGridView() {
    if (sitesWarehouse.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0, // Adjust the aspect ratio as needed
            ),
            itemCount: 12, // Show shimmer for a fixed number of items
            itemBuilder: (context, index) {
              return _buildShimmerCard();
            },
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0, // Adjust the aspect ratio as needed
          ),
          itemCount: sitesWarehouse.length,
          itemBuilder: (context, index) {
            return _buildCard(sitesWarehouse[index]);
          },
        ),
      );
    }
  }

  Widget _buildShimmerCard() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 30.0,
              color: Colors.white,
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: 20.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> site) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VanStockTake(
                      siteid: site['id'],
                      siteName: site['name'],
                    )),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: Text(
                  site['id'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: colorFirst,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: SizedBox(
                  child: AutoSizeText(
                    site['name'],
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
