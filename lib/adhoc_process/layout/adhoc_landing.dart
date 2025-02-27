// // ignore_for_file: avoid_print, use_build_context_synchronously, unused_field, library_private_types_in_public_api
// import 'package:anim_search_bar/anim_search_bar.dart';
// import 'package:floating_snackbar/floating_snackbar.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:nb_utils/nb_utils.dart';
// import 'dart:convert';
// // import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';
// // import 'package:warehouse/provider/auth.dart';
// import 'package:warehouse/routes/routes.dart';
// import 'package:warehouse/shared_preference/token.dart';
// import 'package:warehouse/utils/color.dart';
// class AdhocLandingPage extends StatefulWidget {
//   const AdhocLandingPage({Key? key}) : super(key: key);

//   @override
//   _AdhocLandingPageState createState() => _AdhocLandingPageState();
// }

// class _AdhocLandingPageState extends State<AdhocLandingPage> {
//   List<Map<String, dynamic>> allotments = [];
//   late String _token;
//   final TextEditingController textController = TextEditingController();
//   bool isExpanded = false;
//   bool showUnacknowledgedList = false;

//   @override
//   void initState() {
//     super.initState();
//     _getTokenAndFetchUnacknowledgedData();
//   }

//   Future<void> _getTokenAndFetchUnacknowledgedData() async {
//     final String? token = await TokenUtil.getToken();
//     setState(() {
//       _token = token!;
//       showUnacknowledgedList =
//           true; // Set to true to initially show Pending List
//     });
//     if (token != null) {
//       await fetchUnacknowledgedAPI(token);

//       // Call the additional API for each item in the list
//       for (final allotment in allotments) {
//         await fetchAllotmentDetails(allotment['id'], token);
//       }
//     }
//   }

//   Future<void> fetchAPI(String? token) async {
//     if (token == null) {
//       debugPrint('Token is not available. Redirecting to login screen.');
//       Navigator.pushNamed(context, AppRoutes.login);
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   const SnackBar(
//       //     content: Text(
//       //       'Token Expired. Please login back to the system.',
//       //       style: TextStyle(color: Colors.white),
//       //     ),
//       //     backgroundColor: colorFirst
//       //   ),
//       // );
//       FloatingSnackBar(
//           message: 'Token Expired. Please login back to the system.',
//           context: context);

//       return;
//     }

//     debugPrint('fetch API');
//     const url =
//         'https://tnvsales.amastsales-sandbox.com/api/wms/android-list?limit_rows=60';
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
//                   allotment['record_type'] == 'adhoc_request' ||
//                   allotment['record_type'] == 'adhoc_return')
//               .toList();
//         });

//         for (final allotment in allotments) {
//           await fetchAllotmentDetails(allotment['id'], token);
//         }

//         debugPrint('fetch API completed');
//       } catch (e) {
//         debugPrint('Failed to parse JSON: $e');
//       }
//     } else {
//       debugPrint('Failed to fetch API. Status code: ${response.statusCode}');
//       debugPrint('Error Body: ${response.body}');
//       Navigator.pushNamed(context, AppRoutes.login);
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   const SnackBar(
//       //     content: Text('Token Expired. Please login back to the system.'),
//       //   ),
//       // );
//       FloatingSnackBar(
//           message: 'Token Expired. Please login back to the system.',
//           context: context);
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
//         debugPrint('Second API Data fetch completed');

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
//         debugPrint(
//             'Failed to fetch another API. Status code: ${apiResponse.statusCode}');
//         debugPrint('Error Body: ${apiResponse.body}');
//       }
//     } catch (e) {
//       // Handle exceptions
//       debugPrint('Error during second API call: $e');
//     }
//   }

//   Future<void> fetchUnacknowledgedAPI(String? token) async {
//     if (token == null) {
//       debugPrint('Token is not available. Redirecting to login screen.');
//       Navigator.pushNamed(context, AppRoutes.login);
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   const SnackBar(
//       //     content: Text('Token Expired. Please login back to the system.'),
//       //   ),
//       // );
//       FloatingSnackBar(
//           message: 'Token Expired. Please login back to the system.',
//           context: context);
//       return;
//     }

//     debugPrint('fetch Unacknowledged API');
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
//                   allotment['record_type'] == 'adhoc_request' ||
//                   allotment['record_type'] == 'adhoc_return')
//               .toList();
//         });

//         // Call fetchAllotmentDetails for each item in the list
//         for (final allotment in allotments) {
//           await fetchAllotmentDetails(allotment['id'], token);
//         }

//         debugPrint('fetch Unacknowledged API completed');
//       } catch (e) {
//         debugPrint('Failed to parse JSON: $e');
//       }
//     } else {
//       debugPrint(
//           'Failed to fetch Unacknowledged API. Status code: ${response.statusCode}');
//       debugPrint('Error Body: ${response.body}');
//       Navigator.pushNamed(context, AppRoutes.login);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Token Expired. Please login back to the system.'),
//         ),
//       );
//     }
//   }

//   Future<void> _refreshData() async {
//     // Show shimmer while data is being refreshed
//     setState(() {
//       allotments.clear(); // Clear the existing data
//       showUnacknowledgedList = true; // Set to true to show Pending List
//     });

//     await Future.delayed(const Duration(
//         seconds:
//             2)); // Simulate a delay (replace with your actual data fetching logic)

//     if (showUnacknowledgedList) {
//       await fetchUnacknowledgedAPI(_token);
//     } else {
//       await _getTokenAndFetchUnacknowledgedData();
//     }
//   }

//   void _onSearchSubmitted(String query) {
//     setState(() {
//       textController.text = query;

//       // Filter allotments based on search text
//       allotments = allotments.where((allotment) {
//         final vanId = allotment['van_id']?.toString().toLowerCase() ?? '';
//         final allotmentID = allotment['id'].toString().toLowerCase();
//         final searchText = textController.text.toLowerCase();

//         return vanId.contains(searchText) || allotmentID.contains(searchText);
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppbarWidget(
//         textController: textController,
//         onSearchSubmitted: _onSearchSubmitted,
//         onClearSearch: () {
//           setState(() {
//             textController.clear();
//           });
//         },
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
//                         fetchUnacknowledgedAPI(_token);
//                       } else {
//                         fetchAPI(_token);
//                         for (final allotment in allotments) {
//                           fetchAllotmentDetails(allotment['id'], _token);
//                         }
//                       }
//                     });
//                     // Sort the list to show only unacknowledged status
//                   },
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: RefreshIndicator(
//               color: colorFirst,
//               backgroundColor: whiteColor,
//               onRefresh: _refreshData,
//               child: _buildListView(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Builds the ListView to display allotment data
//   Widget _buildListView() {
//     // Show shimmer if data is empty
//     if (allotments.isEmpty) {
//       return FutureBuilder<void>(
//         future: Future.delayed(const Duration(seconds: 3)),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return showEmptyList();
//           } else {
//             return shimmerList(); // Display shimmer while waiting
//           }
//         },
//       );
//     }

//     // Filter allotments based on search text
//     List<Map<String, dynamic>> filteredAllotments =
//         allotments.where((allotment) {
//       final vanId = allotment['van_id']?.toString().toLowerCase() ?? '';
//       final allotmentID = allotment['id'].toString().toLowerCase();
//       final searchText = textController.text.toLowerCase();

//       return vanId.contains(searchText) || allotmentID.contains(searchText);
//     }).toList();

//     return ListView.builder(
//       itemCount: filteredAllotments.length,
//       itemBuilder: (context, index) {
//         final allotment = filteredAllotments[index];
//         final vanId = allotment['van_id'] ?? '';
//         final allotmentID = allotment['id'];
//         final status = allotment['status'];
//         final recordType = allotment['record_type'];

//         return _buildListTile(
//           index,
//           allotmentID,
//           vanId,
//           allotment,
//           status,
//           recordType,
//         );
//       },
//       physics: const AlwaysScrollableScrollPhysics(),
//     );
//   }

//   Widget showEmptyList() {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         // crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Add your Lottie animation widget here
//           // Lottie.asset('assets/lottie/no_pending_list.json', width: 200, height: 400),
//           Text(
//             'No pending list for now',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget shimmerList() {
//     return ListView.builder(
//       itemCount: 5,
//       itemBuilder: (context, index) {
//         return Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           period: const Duration(milliseconds: 800),
//           child: Container(
//             margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey[200]!,
//                   blurRadius: 5,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 120,
//                     height: 16.0,
//                     color: Colors.white,
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     width: 200,
//                     height: 12.0,
//                     color: Colors.white,
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     width: 80,
//                     height: 12.0,
//                     color: Colors.white,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Builds an individual ListTile
//   Widget _buildListTile(int index, String allotmentID, String vanId,
//       Map<String, dynamic> allotment, String status, String recordType) {
//     ThemeData theme = Theme.of(context);
//     return Padding(
//       padding: const EdgeInsets.only(right: 10, left: 10),
//       child: Card(
//         color: whiteSmoke,
//         elevation: 4,
//         margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//         child: Theme(
//           data: ThemeData(
//             dividerColor: Colors.transparent,
//             textTheme: theme.textTheme,
//           ),
//           child: ExpansionTile(
//             leading: CircleAvatar(
//               maxRadius: 10,
//               backgroundColor: colorFirst,
//               child: Text(
//                 '${index + 1}',
//                 style: const TextStyle(color: whiteColor, fontSize: 12),
//               ),
//             ),
//             title: Text(
//               allotmentID,
//               style: TextStyle(
//                 color: Colors.blue.shade900,
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             subtitle: Text(
//               allotment['record_type'] == 'adhoc_request'
//                   ? 'Adhoc Request'
//                   : allotment['record_type'] == 'adhoc_return'
//                       ? 'Adhoc Return'
//                       : 'Unknown Record Type',
//               style: const TextStyle(
//                 color: Colors.grey,
//                 fontSize: 13.0,
//               ),
//             ),
//             onExpansionChanged: (bool expanding) {
//               setState(() {
//                 isExpanded = expanding;
//               });
//             },
//             children: [
//               InkWell(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withAlpha(32),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   padding: const EdgeInsets.all(3),
//                   margin: const EdgeInsets.all(5),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Expanded(
//                         child: SettingItemWidget(
//                           title: 'Van ID',
//                           subTitle: vanId,
//                           subTitleTextStyle: const TextStyle(
//                             fontSize: 10,
//                           ),
//                           leading: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.blue.withAlpha(32),
//                               borderRadius: BorderRadius.circular(100),
//                             ),
//                             child: const Icon(
//                               Icons.person,
//                               color: Colors.blue,
//                               size: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: SettingItemWidget(
//                           title: 'Status',
//                           subTitle: status,
//                           subTitleTextStyle: const TextStyle(
//                             fontSize: 10,
//                           ),
//                           leading: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.blue.withAlpha(32),
//                               borderRadius: BorderRadius.circular(100),
//                             ),
//                             child: const Icon(
//                               Icons.checklist_rounded,
//                               color: Colors.blue,
//                               size: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
//   const AppbarWidget({
//     Key? key,
//     required this.textController,
//     required this.onSearchSubmitted,
//     required this.onClearSearch,
//   }) : super(key: key);

//   final TextEditingController textController;
//   final Function(String) onSearchSubmitted;
//   final Function onClearSearch;

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       centerTitle: true,
//       title: const Text(
//         'Ad-Hoc Listing',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 20.0,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       backgroundColor: colorFirst,
//       shape: const ContinuousRectangleBorder(
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(50.0),
//           bottomRight: Radius.circular(50.0),
//         ),
//       ),
//       iconTheme: const IconThemeData(color: Colors.white),
//       actions: [
//         AnimSearchBar(
//           width: 200,
//           textController: textController,
//           helpText: 'Search...',
//           color: colorFirst,
//           searchIconColor: whiteColor,
//           textFieldIconColor: colorFirst,
//           suffixIcon: const Icon(
//             Icons.search,
//             color: whiteColor,
//           ),
//           prefixIcon: const Icon(
//             Icons.search,
//             color: whiteColor,
//           ),
//           onSuffixTap: onClearSearch,
//           onSubmitted: (query) {
//             onSearchSubmitted(query);

//             // Optionally, you can clear the search text after submission
//             textController.clear();
//           },
//         )
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
