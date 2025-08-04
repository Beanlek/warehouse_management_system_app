import 'package:flutter/material.dart';
import 'package:warehouse/domain/entities/warehouse_inventory/warehouse_inventory.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/utils/utils.dart';

class CellInventory extends StatelessWidget {
  final bool? hasEvenIndex;
  final WarehouseInventory product;

  const CellInventory({
    Key? key,
    this.hasEvenIndex,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qty = product.quantity ?? [];

    return Container(
      color: hasEvenIndex == true ? white : greyColor2,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(100),  // Category
          1: FixedColumnWidth(120),  // Subcategory
          2: FixedColumnWidth(80),   // SKU ID
          3: FixedColumnWidth(140),  // SKU Name
          4: FixedColumnWidth(60),   // Seq
          5: FixedColumnWidth(70),   // UOM
          6: FixedColumnWidth(80),   // Fresh
          7: FixedColumnWidth(90),   // Damaged
          8: FixedColumnWidth(70),   // Old
          9: FixedColumnWidth(90),   // Recalled
          10: FixedColumnWidth(100), // New Order
          11: FixedColumnWidth(150), // Available to Order
          12: FixedColumnWidth(160), // Available to Allocate
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: [
              _cell(product.category),
              _cell(product.subCategory),
              _cell(product.skuId),
              _cell(product.skuName),
              _cell(product.sequence?.toString()),
              _cell(product.uomId),
              _cell((qty.isNotEmpty) ? qty[0].toString() : '0'),
              _cell((qty.length > 1) ? qty[1].toString() : '0'),
              _cell((qty.length > 2) ? qty[2].toString() : '0'),
              _cell((qty.length > 3) ? qty[3].toString() : '0'),
              _cell((qty.length > 4) ? qty[4].toString() : '0'),
              _cell((qty.length > 5) ? qty[5].toString() : '0'),
              _cell((qty.length > 6) ? qty[6].toString() : '0'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cell(String? text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text ?? '-',
        style: primaryTextStyle(size: 12),
        textAlign: TextAlign.center,
      ),
    );
  }
}
