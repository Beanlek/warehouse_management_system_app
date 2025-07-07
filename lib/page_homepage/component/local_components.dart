import 'package:flutter/material.dart';

mixin HomepageComponents {
  
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final ScrollController drawerScrollController = ScrollController();

  late Future<bool> tokenFuture;
  late double widthScreen;
  late double heightScreen;

  int allotPlanCount = 0;
  int allotBalanceCount = 0;
  int allotAdditionalCount = 0;
  int allotRequestCount = 0;
  int adhocReturnCount = 0;
  int adhocRequestCount = 0;
  int marketReturnCount = 0;
  int mrReturnOrderCount = 0;
  int reconCount = 0;

  int transferInCount = 0;
  int transferOutCount = 0;
  int tInCount = 0;
  int tOutCount = 0;
  
  int pendingCount = 0;
  int totalListing = 0;
  int acknowledgedCount = 0;

  int picklistCount = 0;
  int salesOrderCount = 0;
  int returnOrderCount = 0;

  Map<String, dynamic> userDetails = {};
  String realUsername = 'null';

  bool launchLoading = true;
  bool showActionSummary = true;
  bool showStockMovement = true;
  bool showInventoryStockTake = true;
  bool showPresalesOrder = true;
  bool showAccountProfile = true;
  bool showAllowedSites = true;

  SliverGridDelegateWithFixedCrossAxisCount gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3, // row
    childAspectRatio: 1,
    // mainAxisSpacing: 20,
    // crossAxisSpacing: 20,
  );

  String? token;
  String? username;
  String? appVersion;

}