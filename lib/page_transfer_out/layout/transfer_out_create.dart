// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/models/warehouse.dart';

import 'package:warehouse/routes/routes.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/stock_recon/widget/dialog_widget.dart';
import 'package:warehouse/utils/utils.dart';


class TransferOutCreate extends StatefulWidget {
  const TransferOutCreate({
    super.key,
  });

  @override
  State<TransferOutCreate> createState() => _TransferOutCreateState();
}

class _TransferOutCreateState extends State<TransferOutCreate> {

  ScrollController mainScrollController = ScrollController();
  TextEditingController remarkController = TextEditingController(text: 'No remarks.');
  FocusNode remarkFocusnode = FocusNode();

  int activeStep = 0;
  bool _isLoading = false;

  List<Warehouse> sourceSitesWarehouse = [];
  List<Warehouse> destinationSitesWarehouse = [];
  Warehouse selectedSourceSite = Warehouse(id: '', name: '');
  Warehouse selectedDestinationSite = Warehouse(id: '', name: '');
  
  String? _token;

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

    final response = await http.get(uri, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      try {
        final json = jsonDecode(response.body);
        final List<Map<String,dynamic>> sitesRaw = List.from(json['sites'] as List);

        sourceSitesWarehouse = sitesRaw.map((sites) => Warehouse.fromJson(sites) ).toList();
        destinationSitesWarehouse = sitesRaw.map((sites) => Warehouse.fromJson(sites) ).toList();

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
  Widget build(BuildContext context) {
    return GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          title: Text(
            'Create Transfer Out',
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
      Stack(
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Breadcrumbs
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
                                    return DialogConfirmation(toHome: true,);
                                  },
                                );
                              },
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              color: textColorTertiary,
                            ),
                            children: [
                              TextSpan(
                                text: '> Transfer Out ',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DialogConfirmation();
                                      },
                                    );
                                  },
                              ),
                              TextSpan(
                                text: '> Create',
                              ),
                            ],
                          ),
                        ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),

                  // Content
                  Expanded(
                    child: RawScrollbar(
                      radius: Radius.circular(10),
                      thickness: 8,
                      thumbColor: biruImran4,
                      thumbVisibility: true,
                      controller: mainScrollController,
                      child: SingleChildScrollView(
                        controller: mainScrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            
                            // SOURCE SITE
                            ListTile(
                              dense: true,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Select Source Site',
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: biruImran
                                    ),
                                  ),
                                  Divider(color: biruImran2, height: 34,)
                                ],
                              ),
                              subtitle:
                              selectedSourceSite.id == '' ?
                                GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  
                                  shrinkWrap: true,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    childAspectRatio: 2,
                                
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                  ),
                                  itemCount: sourceSitesWarehouse.length,
                                  itemBuilder: (context, index) {
                                    final site = sourceSitesWarehouse[index];
                                
                                    var siteSelect = site.select;
                                    final siteID = site.id;
                                    final siteName = site.name;
                                
                                    var cardColor = siteSelect ? biruImran4 : biruImran;
                                    var fontColor = siteSelect ? biruImran : white;
                                    
                                    return InkWell(
                                      splashColor: white,
                                      onTap: () async {
                                        setState(() {
                                          siteSelect = !siteSelect;
                                          site.select = siteSelect;

                                          if (siteSelect) {
                                            selectedSourceSite = Warehouse.from(site);
                                          } else {
                                            selectedDestinationSite.clear();
                                            selectedSourceSite.clear();
                                          }
                                        });

                                        debugPrint('SITE SELECT :: ${siteSelect.toString()}');
                                        debugPrint('SITE SELECTEDSITE :: ${selectedSourceSite.toString()}');
                                      },
                                      child: Material(
                                        elevation: 3,
                                        borderRadius: BorderRadius.circular(24),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(24),
                                            border: Border.all(color: fontColor, width: 1),
                                            color: cardColor
                                          ),// Set card color
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: AutoSizeText(
                                                    siteID,
                                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: fontColor,
                                                    ),
                                                  
                                                    maxLines: 1,
                                                    minFontSize: 1,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: AutoSizeText(
                                                    siteName,
                                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
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
                                  }
                                ) :
                              
                                InkWell(
                                  splashColor: biruImran,
                                  onTap: () async {
                                    
                                    setState(() {
                                      for (var site in sourceSitesWarehouse) {
                                        final siteID = site.id;

                                        if (siteID == selectedSourceSite.id) {
                                          site.select = false;
                                          break;
                                        } 
                                      }

                                      selectedSourceSite.select = false;
                                      selectedSourceSite.clear();

                                      selectedDestinationSite.clear();
                                      for (var site in destinationSitesWarehouse) {
                                        site.select = false;
                                      }

                                    });

                                  },
                                  child: Material(
                                    elevation: 3,
                                    borderRadius: BorderRadius.circular(24),
                                    color: Colors.transparent,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(color: biruImran, width: 1),
                                        color: biruImran4
                                      ),// Set card color
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(
                                              selectedSourceSite.id,
                                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: biruImran,
                                              ),
                                            
                                              maxLines: 1,
                                              minFontSize: 1,
                                            ),
                                            AutoSizeText(
                                              selectedSourceSite.name,
                                              style: Theme.of(context).textTheme.labelSmall!.copyWith(
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
                                )
                            ),


                            // DESTINATION SITE
                            if(selectedSourceSite.isNotEmpty)
                              ListTile(
                                dense: true,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Select Destination Site',
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: biruImran
                                      ),
                                    ),
                                    Divider(color: biruImran2, height: 34,)
                                  ],
                                ),
                                subtitle:
                                selectedDestinationSite.isEmpty ?
                                  GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    
                                    shrinkWrap: true,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 2,
                                  
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                    ),
                                    itemCount: destinationSitesWarehouse.length,
                                    itemBuilder: (context, index) {
                                      final site = destinationSitesWarehouse[index];
                                  
                                      var siteSelect = site.select;
                                      final siteID = site.id;
                                      final siteName = site.name;
                                  
                                      var cardColor = siteSelect ? biruImran4 : biruImran;
                                      var fontColor = siteSelect ? biruImran : white;
                                      
                                      return InkWell(
                                        splashColor: white,
                                        onTap: () async {
                                          setState(() {
                                            siteSelect = !siteSelect;
                                            site.select = siteSelect;

                                            if (siteSelect) {
                                              selectedDestinationSite = Warehouse.from(site);
                                            } else {
                                              selectedDestinationSite.clear();
                                            }
                                          });

                                          debugPrint('SITE SELECT :: ${siteSelect.toString()}');
                                          debugPrint('SITE SELECTEDSITE :: ${selectedDestinationSite.toString()}');
                                        },
                                        child: Material(
                                          elevation: 3,
                                          borderRadius: BorderRadius.circular(24),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(24),
                                              border: Border.all(color: fontColor, width: 1),
                                              color: cardColor
                                            ),// Set card color
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: AutoSizeText(
                                                      siteID,
                                                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color: fontColor,
                                                      ),
                                                    
                                                      maxLines: 1,
                                                      minFontSize: 1,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: AutoSizeText(
                                                      siteName,
                                                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
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
                                    }
                                  ) :
                                
                                  InkWell(
                                    splashColor: biruImran,
                                    onTap: () async {
                                      
                                      setState(() {
                                        for (var site in destinationSitesWarehouse) {
                                          final siteID = site.id;

                                          if (siteID == selectedDestinationSite.id) {
                                            site.select = false;
                                            break;
                                          } 
                                        }

                                        selectedDestinationSite.select = false;
                                        selectedDestinationSite.clear();
                                      });

                                    },
                                    child: Material(
                                      elevation: 3,
                                      borderRadius: BorderRadius.circular(24),
                                      color: Colors.transparent,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(24),
                                          border: Border.all(color: biruImran, width: 1),
                                          color: biruImran4
                                        ),// Set card color
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                selectedDestinationSite.id,
                                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: biruImran,
                                                ),
                                              
                                                maxLines: 1,
                                                minFontSize: 1,
                                              ),
                                              AutoSizeText(
                                                selectedDestinationSite.name,
                                                style: Theme.of(context).textTheme.labelSmall!.copyWith(
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
                                  )
                              ),

                            // DESTINATION SITE
                            if(selectedDestinationSite.isNotEmpty)
                              ListTile(
                                dense: true,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Enter Remark',
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: biruImran
                                      ),
                                    ),
                                    Divider(color: biruImran2, height: 34,)
                                  ],
                                ),
                                subtitle: TextFormField(
                                  focusNode: remarkFocusnode,
                                  controller: remarkController,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 5,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: biruImran,
                                        width: 2
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: biruImran,
                                        width: 1
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                  ),
                                )
                              ),
                          ],
                        ),
                      )
                    )
                  )
                  
                  
                  
                ],
              ),
            ),
          ),
          
          
        
          _isLoading ? Opacity(opacity: 0.5,child: Container(
              color: white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator()),
              ),
            ) : SizedBox()
        ],
      ),

      floatingActionButton: FloatingActionButton(onPressed: () {
        final isSame = destinationSitesWarehouse[0] == sourceSitesWarehouse[0];
        final site1 = destinationSitesWarehouse[0];
        final site2 = sourceSitesWarehouse[0];

        debugPrint("IS THE SAME?? :: ${isSame.toString()}");
        debugPrint("SITE 1?? :: ${site1.toString()}");
        debugPrint("SITE 2?? :: ${site2.toString()}");
      }),
      
      ));
  }

  
}
