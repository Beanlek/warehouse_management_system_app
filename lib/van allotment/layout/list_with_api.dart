// import 'package:flutter/material.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:warehouse/api%20test/api_copy.dart';
// import 'package:warehouse/van%20allotment/layout/allotment_detail.dart';
// import 'package:warehouse/van%20allotment/widget/expansion_panel.dart';
// import 'package:warehouse/utils/color.dart';
// // Import your APIViewCopy class

// class CombinedAllotmentView extends StatefulWidget {
//   const CombinedAllotmentView({Key? key}) : super(key: key);

//   @override
//   CombinedAllotmentViewState createState() => CombinedAllotmentViewState();
// }

// class CombinedAllotmentViewState extends State<CombinedAllotmentView> {
//   bool isExpanded = false;
//   List<Map<String, dynamic>> allotments = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchAPI(); // Call the API when the widget is initialized
//   }

//   @override
//   Widget build(BuildContext context) {
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
//           IconButton(
//             icon: const Icon(
//               Icons.search,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               // Handle search button press
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(12.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [Icon(Icons.sort)],
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: ListView.builder(
//                 itemCount: allotments.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final allotment = allotments[index];
//                   final allotmentId = allotment['id'];

//                   return Container(
//                     margin: const EdgeInsets.symmetric(vertical: 2),
//                     child: Card(
//                       color: whiteSmoke,
//                       elevation: 4,
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 3),
//                       child: Theme(
//                         data: ThemeData(
//                             dividerColor: Colors.transparent,
//                             textTheme: theme.textTheme),
//                         child: ExpansionTile(
//                           leading: const Icon(Icons.info_outline,
//                               color: Colors.grey),
//                           childrenPadding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 8),
//                           title: Text(
//                             'Van ${index + 1}',
//                             style: TextStyle(
//                               color: Colors.blue.shade900,
//                               fontSize: 18.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           subtitle: Text(
//                             'Van allotment ${index + 1}',
//                             style: const TextStyle(
//                               color: Colors.grey,
//                               fontSize: 13.0,
//                             ),
//                           ),
//                           trailing: isExpanded
//                               ? Container(
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(100),
//                                     color: Colors.blue.withAlpha(64),
//                                   ),
//                                   child: const Icon(Icons.keyboard_arrow_up,
//                                       color: Colors.blue, size: 30),
//                                 )
//                               : Container(
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(100),
//                                     color: transparentColor,
//                                   ),
//                                   child: const Icon(Icons.keyboard_arrow_down,
//                                       color: Colors.grey, size: 30),
//                                 ),
//                           onExpansionChanged: (t) {
//                             isExpanded = !isExpanded.validate(value: false);
//                             setState(() {});
//                           },
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.blue.withAlpha(32),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               padding: const EdgeInsets.all(16),
//                               child: Column(
//                                 children: [
//                                   const Row(
//                                     children: [
//                                       Text(
//                                         'Allotment ID: A00000059263',
//                                         style: TextStyle(
//                                           color: Colors.black87,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                   const SizedBox(height: 7),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       ElevatedButton(
//                                         onPressed: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   const AllotmentDetailView(),
//                                             ),
//                                           );
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: Colors.blue,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(8),
//                                           ),
//                                         ),
//                                         child: const Text(
//                                           'View Details',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> fetchAPI() async {
//     await const APIViewCopy().fetchAPI();
//     setState(() {
//       allotments = const APIViewCopy().allotments;
//     });
//   }
// }

