import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/page_stock_take/layout/van_eod_page.dart';
import 'package:warehouse/page_stock_take/layout/warehouse_page.dart';

import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';
import 'package:warehouse/widgets/global_dialog.dart';

class StockTake extends StatefulWidget {
  const StockTake({
    super.key,
    required this.type
  });

  final String type;

  @override
  State<StockTake> createState() => _StockTakeState();
}

class _StockTakeState extends State<StockTake> {
  List<Map<String, dynamic>> sitesWarehouse = [];
  late String? _token;
  
  bool _showErrorOverlay = false;

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
      await fetchAPI(_token);
    } else {
      setState(() {
        _showErrorOverlay = true;
      });
      debugPrint('Token not available');
    }
  }

  Future<void> fetchAPI(String? token) async {
    debugPrint('fetchAPI initiated');
    final String? domainName = await TokenUtil.getDomainName();

    String url = '$domainName/api/dataLookup/sites/list';
    final uri = Uri.parse(url);

    final response = await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body);
        final sites = json['sites'];

        setState(() {
          sitesWarehouse = List<Map<String, dynamic>>.from(sites);
        });

        debugPrint('fetch API completed');
      } catch (e) {
        setState(() {
          _showErrorOverlay = true;
        });
        debugPrint('Failed to parse JSON: $e');
      }
    } else {
      setState(() {
        _showErrorOverlay = true;
      });
      debugPrint('Failed to fetch API. Status code: ${response.statusCode}');
      debugPrint('Error Body: ${response.body}');
      Navigator.pushNamed(context, AppRoutes.login);
    }
  }

  Future<void> checksites(String siteId, String warehouseName) async {
    
    if (_token != null) {
    final String? domainName = await TokenUtil.getDomainName();

    String apiUrl = '$domainName/api/wms/allotment_validation?site_id=$siteId';

      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $_token',
      });

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final status = json['allowWarehouseStockTake'];

        setState(() {
          if (status) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return WarehousePage(
                    id: siteId,
                    warehouseName: warehouseName,
                  );
                },
              ),
            );
          } else {
            showDialog(
              context: context, builder: (BuildContext context) {
                return DialogNotice(
                  title: 'Access denied',
                  notice: 'There are pending allotments that are not in the \'packed\' status.\nThe Warehouse Stock Take is not permitted for Site ID.',
                );
              },
            );
          }
        });
        // Handle the response data as needed
        debugPrint(status);
      } else {
        debugPrint('Failed to call API. Status code: ${response.statusCode}');
        debugPrint('Error Body: ${response.body}');
      }
    } else {
      // Handle token not available scenario
      debugPrint('Token not available');
    }
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
            '${widget.type} Stock Take',
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                          Navigator.of(context).pop();
                        },
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: textColorTertiary,
                      ),
                      children: [TextSpan(text: '> ${widget.type} Stock Take')]),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            _showErrorOverlay ?
            ERROR_OVERLAY() :
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: 
                sitesWarehouse.isEmpty ?
                Center(child: CircularProgressIndicator()) :
                _buildGridView(),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildGridView() {
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

  Widget _buildCard(Map<String, dynamic> site) {
    return InkWell(
      onTap: () {
        if (widget.type == 'Warehouse') {
          checksites(
            site['id'],
            site['name'],
          );
        }
        else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VanEODPage(siteid: site['id'],siteName: site['name'],)
            ),
          );
        }
      },
      child: Material(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                biruImran,
                colorFirst
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: Text(
                    site['id'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: white,
                    ),
                  ),
                ),
                Divider(color: biruImran4,),
                Expanded(
                  child: SizedBox(
                    child: AutoSizeText(
                      site['name'],
                      maxLines: 3,
                      style: const TextStyle(
                        color: white,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
