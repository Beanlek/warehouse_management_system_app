// // ignore_for_file: avoid_print, use_build_context_synchronously

// import 'dart:convert';
// import 'package:anim_search_bar/anim_search_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:nb_utils/nb_utils.dart';
// import 'package:provider/provider.dart';
// import 'package:warehouse/provider/auth.dart';
// import 'package:warehouse/routes/routes.dart';
// import 'package:warehouse/utils/color.dart';
// import 'package:warehouse/van%20allotment/layout/allotment_detail.dart';

// class APIViewCopy extends StatefulWidget {
//   const APIViewCopy({Key? key}) : super(key: key);

//   @override
//   State<APIViewCopy> createState() => _APIViewCopyState();
// }

// class _APIViewCopyState extends State<APIViewCopy> {
//   List<Map<String, dynamic>> allotments = [];
//   List<Map<String, dynamic>> searchResults = [];
//   List<Map<String, dynamic>> details = [];
//   bool isExpanded = false;
//   int? expandedIndex;
//   bool showUnacknowledgedList = false;
//   TextEditingController textController = TextEditingController();
//   Map<String, String?> vanIds = {};

//   //new update
//   // ignore: unused_field
//   late String? _token;

//   @override
//   void initState() {
//     super.initState();

//     _getTokenAndFetchData();

//     // Future.delayed(Duration.zero, () {
//     //   final token = Provider.of<AuthProvider>(context).token;
//     //   if (token != null) {
//     //     fetchAPI(token);
//     //   }
//     // });
//   }

//   Future<void> _getTokenAndFetchData() async {
//     final token = Provider.of<AuthProvider>(context, listen: false).token;
//     setState(() {
//       _token = token;
//     });
//     if (token != null) {
//       await fetchAPI(token);

//       // Call the additional API for each item in the list
//       for (final allotment in allotments) {
//         await fetchAllotmentDetails(allotment['id'], token);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final token = Provider.of<AuthProvider>(context).token;

//     ThemeData theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           'Van Allotment',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: colorFirst,
//         shape: const ContinuousRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(50.0),
//             bottomRight: Radius.circular(50.0),
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: AnimSearchBar(
//               color: colorFirst,
//               searchIconColor: whiteColor,
//               // closeSearchOnSuffixTap: true,
//               textFieldIconColor: colorFirst,
//               suffixIcon: const Icon(
//                 Icons.search,
//                 color: whiteColor,
//               ),
//               prefixIcon: const Icon(
//                 Icons.search,
//                 color: whiteColor,
//               ),
//               onSubmitted: (query) {
//                 setState(() {
//                   // Filter allotments based on the search query
//                   searchResults = allotments
//                       .where((allotment) =>
//                           allotment['id'].toString().contains(query) ||
//                           allotment['record_type'].toString().contains(query))
//                       .toList();
//                 });

//                 // Show a Snackbar after search with a longer duration
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content:
//                         Text('Search completed. Pull down to refresh data.'),
//                     duration: Duration(
//                         seconds:
//                             3), // Set the duration to 5 seconds (you can adjust as needed)
//                   ),
//                 );
//               },

//               width: 200,
//               textController: textController,
//               helpText: 'Search...',
//               onSuffixTap: () {
//                 setState(() {
//                   textController.clear();
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 20, top: 13.0),
//                   child: Text(
//                     showUnacknowledgedList ? 'Pending List' : 'All Listing',
//                     style: TextStyle(
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey.shade500),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 20, top: 13.0),
//                 child: IconButton(
//                   icon: Icon(Icons.sort, color: Colors.grey.shade500),
//                   onPressed: () {
//                     setState(() {
//                       showUnacknowledgedList = !showUnacknowledgedList;
//                       if (showUnacknowledgedList) {
//                         fetchUnacknowledgedAPI(token);
//                       } else {
//                         fetchAPI(token);
//                       }
//                     });
//                     // Sort the list to show only unacknowledged status
//                   },
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(right: 10, left: 10),
//               child: RefreshIndicator(
//                 color: colorFirst,
//                 onRefresh: () async {
//                   setState(() {
//                     // Reset search results and fetch the API again
//                     searchResults.clear();
//                     if (showUnacknowledgedList) {
//                       fetchUnacknowledgedAPI(token);
//                     } else {
//                       fetchAPI(token);
//                     }
//                   });
//                 },
//                 child: ListView.builder(
//                   itemCount: searchResults.isNotEmpty
//                       ? searchResults.length
//                       : allotments.length,
//                   itemBuilder: (context, index) {
//                     if (searchResults.isNotEmpty &&
//                         index < searchResults.length) {
//                       final allotment = searchResults[index];
//                       final allotmentId = allotment['id'];
//                       final recordType = allotment['record_type'];
//                       final status = allotment['status'];

//                       return Card(
//                         color: whiteSmoke,
//                         elevation: 4,
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 5, vertical: 5),
//                         child: Theme(
//                           data: ThemeData(
//                               dividerColor: Colors.transparent,
//                               textTheme: theme.textTheme),
//                           child: ExpansionTile(
//                             leading: CircleAvatar(
//                               backgroundColor: transparentColor,
//                               child: Text(
//                                 '${index + 1}',
//                                 style: const TextStyle(color: colorFirst),
//                               ),
//                             ),
//                             title: Text(
//                               'ID: $allotmentId',
//                               style: TextStyle(
//                                 color: Colors.blue.shade900,
//                                 fontSize: 18.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             subtitle: Text(
//                               'Type : $recordType',
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 13.0,
//                               ),
//                             ),
//                             onExpansionChanged: (t) {
//                               setState(() {
//                                 if (t) {
//                                   if (expandedIndex != null &&
//                                       expandedIndex != index) {
//                                     isExpanded = false;
//                                   }
//                                   expandedIndex = index;
//                                   isExpanded = true;
//                                   // fetchAllotmentDetails(token, allotmentId);
//                                 } else {
//                                   isExpanded = false;
//                                 }
//                               });
//                             },
//                             children: [
//                               InkWell(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             AllotmentDetailView(
//                                           allotmentId: allotmentId,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.blue.withAlpha(32),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     padding: const EdgeInsets.all(3),
//                                     margin: const EdgeInsets.all(5),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: [
//                                         Expanded(
//                                           child: SettingItemWidget(
//                                             title: 'Van ID',
//                                             subTitle: '${allotment['van_id']}',
//                                             subTitleTextStyle: const TextStyle(
//                                               fontSize: 10,
//                                             ),
//                                             leading: Container(
//                                               padding: const EdgeInsets.all(8),
//                                               decoration: BoxDecoration(
//                                                 color:
//                                                     Colors.blue.withAlpha(32),
//                                                 borderRadius:
//                                                     BorderRadius.circular(100),
//                                               ),
//                                               child: const Icon(
//                                                 Icons.person,
//                                                 color: Colors.blue,
//                                                 size: 15,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: SettingItemWidget(
//                                             title: 'Status',
//                                             subTitle: '$status',
//                                             subTitleTextStyle: const TextStyle(
//                                               fontSize: 10,
//                                             ),
//                                             leading: Container(
//                                               padding: const EdgeInsets.all(8),
//                                               decoration: BoxDecoration(
//                                                 color:
//                                                     Colors.blue.withAlpha(32),
//                                                 borderRadius:
//                                                     BorderRadius.circular(100),
//                                               ),
//                                               child: const Icon(
//                                                 Icons.checklist_rounded,
//                                                 color: Colors.blue,
//                                                 size: 15,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       );
//                     } else if (index < allotments.length) {
//                       final allotment = allotments[index];
//                       final allotmentId = allotment['id'];
//                       final recordType = allotment['record_type'];
//                       final status = allotment['status'];

//                       return Card(
//                         color: whiteSmoke,
//                         elevation: 4,
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 5, vertical: 5),
//                         child: Theme(
//                           data: ThemeData(
//                               dividerColor: Colors.transparent,
//                               textTheme: theme.textTheme),
//                           child: ExpansionTile(
//                             leading: CircleAvatar(
//                               backgroundColor: transparentColor,
//                               child: Text(
//                                 '${index + 1}',
//                                 style: const TextStyle(color: colorFirst),
//                               ),
//                             ),
//                             title: Text(
//                               'ID: $allotmentId',
//                               style: TextStyle(
//                                 color: Colors.blue.shade900,
//                                 fontSize: 18.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             subtitle: Text(
//                               'Type : $recordType',
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 13.0,
//                               ),
//                             ),
//                             onExpansionChanged: (t) {
//                               setState(() {
//                                 if (t) {
//                                   if (expandedIndex != null &&
//                                       expandedIndex != index) {
//                                     isExpanded = false;
//                                   }
//                                   expandedIndex = index;
//                                   isExpanded = true;
//                                   // fetchAllotmentDetails(token, allotmentId);
//                                 } else {
//                                   isExpanded = false;
//                                 }
//                               });
//                             },
//                             children: [
//                               InkWell(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             AllotmentDetailView(
//                                           allotmentId: allotmentId,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.blue.withAlpha(32),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     padding: const EdgeInsets.all(3),
//                                     margin: const EdgeInsets.all(5),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: [
//                                         Expanded(
//                                           child: SettingItemWidget(
//                                             title: 'Van ID',
//                                             subTitle: '',
//                                             subTitleTextStyle: const TextStyle(
//                                               fontSize: 10,
//                                             ),
//                                             leading: Container(
//                                               padding: const EdgeInsets.all(8),
//                                               decoration: BoxDecoration(
//                                                 color:
//                                                     Colors.blue.withAlpha(32),
//                                                 borderRadius:
//                                                     BorderRadius.circular(100),
//                                               ),
//                                               child: const Icon(
//                                                 Icons.person,
//                                                 color: Colors.blue,
//                                                 size: 15,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: SettingItemWidget(
//                                             title: 'Status',
//                                             subTitle: '$status',
//                                             subTitleTextStyle: const TextStyle(
//                                               fontSize: 10,
//                                             ),
//                                             leading: Container(
//                                               padding: const EdgeInsets.all(8),
//                                               decoration: BoxDecoration(
//                                                 color:
//                                                     Colors.blue.withAlpha(32),
//                                                 borderRadius:
//                                                     BorderRadius.circular(100),
//                                               ),
//                                               child: const Icon(
//                                                 Icons.checklist_rounded,
//                                                 color: Colors.blue,
//                                                 size: 15,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       );
//                     }
//                     return const SizedBox
//                         .shrink(); // Placeholder, you can replace it with your widget.
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {
//       //     fetchAPI(token);
//       //   },
//       //   child: const Icon(Icons.refresh),
//       // ),
//     );
//   }

//   Future<void> fetchAPI(String? token) async {
//     if (token == null) {
//       print('Token is not available. Redirecting to login screen.');
//       Navigator.pushNamed(context, AppRoutes.login);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Token Expired. Please login back to the system.'),
//         ),
//       );
//       return;
//     }

//     print('fetch API');
//     const url = 'https://tnvsales.amastsales-sandbox.com/api/wms/android-list';
//     final uri = Uri.parse(url);

//     final response =
//         await http.get(uri, headers: {'Authorization': 'Bearer $token'});

//     if (response.statusCode == 200) {
//       try {
//         final json = jsonDecode(response.body);
//         final wmsAcknowledgment = json['wms_acknowledgment'];
//         final rows = wmsAcknowledgment['rows'];

//         setState(() {
//           allotments = List<Map<String, dynamic>>.from(rows)
//               .where((allotment) =>
//                   allotment['record_type'] == 'allot_plan' ||
//                   allotment['record_type'] == 'allot_balance')
//               .toList();
//         });

//         print('fetch API completed');

//         // Call the additional API for each item in the list
//         for (final allotment in allotments) {
//           await fetchAllotmentDetails(allotment['id'], token);
//         }
//       } catch (e) {
//         print('Failed to parse JSON: $e');
//       }
//     } else {
//       print('Failed to fetch API. Status code: ${response.statusCode}');
//       print('Error Body: ${response.body}');
//       Navigator.pushNamed(context, AppRoutes.login);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Token Expired. Please login back to the system.'),
//         ),
//       );
//     }
//   }

//   Future<void> fetchAllotmentDetails(String id, String? token) async {
//     final apiSecondURL =
//         'https://tnvsales.amastsales-sandbox.com/api/allotment/o/$id';
//     final apiAllotmentDetail = Uri.parse(apiSecondURL);

//     final apiResponse = await http
//         .get(apiAllotmentDetail, headers: {'Authorization': 'Bearer $token'});
//     try {
//       if (apiResponse.statusCode == 200) {
//         final Map<String, dynamic> secondApiData = jsonDecode(apiResponse.body);
//         final allotmentDetail = secondApiData['allotment'];

//         // Process the data from the second API as needed
//         print('Second API Data fetch completed');

//         // Extracting van_id and updating the allotments list
//         final vanId = allotmentDetail['van_id'];
//         final index =
//             allotments.indexWhere((allotment) => allotment['id'] == id);
//         if (index != -1) {
//           setState(() {
//             allotments[index]['van_id'] = vanId;
//           });
//         }
//       } else {
//         // Handle the error
//         print(
//             'Failed to fetch another API. Status code: ${apiResponse.statusCode}');
//         print('Error Body: ${apiResponse.body}');
//       }
//     } catch (e) {
//       // Handle exceptions
//       print('Error during second API call: $e');
//     }
//   }

//   Future<void> fetchUnacknowledgedAPI(String? token) async {
//     if (token == null) {
//       print('Token is not available. Redirecting to login screen.');
//       Navigator.pushNamed(context, AppRoutes.login);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Token Expired. Please login back to the system.'),
//         ),
//       );
//       return;
//     }

//     print('fetch Unacknowledged API');
//     const url =
//         'https://tnvsales.amastsales-sandbox.com/api/wms/android-list?status=unacknowledged';
//     final uri = Uri.parse(url);

//     final response =
//         await http.get(uri, headers: {'Authorization': 'Bearer $token'});

//     if (response.statusCode == 200) {
//       try {
//         final json = jsonDecode(response.body);
//         final wmsAcknowledgment = json['wms_acknowledgment'];
//         final rows = wmsAcknowledgment['rows'];

//         setState(() {
//           allotments = List<Map<String, dynamic>>.from(rows)
//               .where((allotment) =>
//                   allotment['record_type'] == 'allot_plan' ||
//                   allotment['record_type'] == 'allot_balance')
//               .toList();
//         });

//         print('fetch Unacknowledged API completed');
//       } catch (e) {
//         print('Failed to parse JSON: $e');
//       }
//     } else {
//       print(
//           'Failed to fetch Unacknowledged API. Status code: ${response.statusCode}');
//       print('Error Body: ${response.body}');
//       Navigator.pushNamed(context, AppRoutes.login);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Token Expired. Please login back to the system.'),
//         ),
//       );
//     }
//   }
// }
