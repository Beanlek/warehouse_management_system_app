// import 'package:flutter/material.dart';

// class CellVanStockProducts extends StatelessWidget {
//   final bool? hasEvenIndex;
//   final ProductVanStock productVanStock;
//   final String quantityDisplay;

//   const CellVanStockProducts(
//       {super.key, 
//       this.hasEvenIndex,
//       required this.productVanStock,
//       this.quantityDisplay = '',
//       });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color:
//           hasEvenIndex == true ? AppColors.pureWhite : AppColors.esXLightGrey,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 32, top: 8, right: 32, bottom: 8),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 1,
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(productVanStock.product.name,
//                         style: TextStyle(
//                         color: AppColors.esBlack,
//                         fontWeight: FontWeight.normal,
//                         fontSize: 12)),
//                     Text(productVanStock.product.productId,
//                         style: TextStyle(
//                         color:AppColors.esBlack,
//                         fontWeight:  FontWeight.normal,
//                         fontSize: 12)),
//                   ]),
//             ),
//             Expanded(
//                 flex: 1,
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: Text(quantityDisplay,
//                       textAlign: TextAlign.end,
//                       style: TextStyle(
//                         color:AppColors.esBlack,
//                         fontWeight: FontWeight.normal,
//                         fontSize: 12)),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }
