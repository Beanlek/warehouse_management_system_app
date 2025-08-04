import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/presentation/blocs/warehouse/warehouse_bloc.dart';
import 'package:warehouse/presentation/blocs/warehouse/warehouse_state.dart';
import 'package:warehouse/presentation/widgets/warehouse/cell_inventory.dart';
import 'package:warehouse/utils/utils.dart';


class BrandGroup extends StatelessWidget {
  final String brand;
  final bool isSelected;
  final ExpandableController controller = ExpandableController();

  BrandGroup({
    Key? key,
    required this.brand,
    required Function(bool) callback,
    required this.isSelected,
  }) : super(key: key) {
    controller.expanded = !isSelected;
    controller.addListener(() {
      callback(!controller.expanded);
    });
  }

  static const ExpandableThemeData expandableThemeData = ExpandableThemeData(
    hasIcon: false,
    tapHeaderToExpand: true,
  );

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      controller: controller,
      theme: expandableThemeData,
      header: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              brand,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: black),
            ),
            _buildIcon()
          ],
        ),
      ),
      collapsed: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Container(
            width: 1500, // Total of all column widths
            color: biruImran,
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
                    _header('Category'),
                    _header('Subcategory'),
                    _header('SKU ID'),
                    _header('SKU Name'),
                    _header('Seq'),
                    _header('UOM'),
                    _header('Fresh'),
                    _header('Damage'),
                    _header('Old'),
                    _header('Recalled'),
                    _header('New Order'),
                    _header('Available to Order'),
                    _header('Available to Allocate'),
                  ],
                ),
              ],
            ),
          ),
          BlocBuilder<WarehouseBloc, WarehouseState>(
            builder: (context, state) {
              final products = state.brandInventoryMap[brand];

              if (products == null || products.isEmpty) {
                return const Center(
                  child: Text('No products available for this brand'),
                );
              }

              return Container(
                width: 1500, // Same width to align with the header
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return CellInventory(
                      hasEvenIndex: index.isEven,
                      product: product,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    ),

      expanded: Container(),
    );
  }

  _buildIcon() {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, anim) => RotationTransition(
              turns: child.key == const ValueKey('collapse')
                  ? Tween<double>(begin: 1, end: 0.5).animate(anim)
                  : Tween<double>(begin: 0.5, end: 1).animate(anim),
              child: FadeTransition(opacity: anim, child: child),
            ),
        child: isSelected
            ? const Icon(Icons.keyboard_arrow_up_rounded,
                color: Colors.black, key: ValueKey('expand'))
            : const Icon(
                color: Colors.black,
                Icons.keyboard_arrow_up_rounded,
                key: ValueKey('collapse'),
              ));
  }

  Widget _header(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        style: boldTextStyle(color: white, size: 12),
        textAlign: TextAlign.center,
      ),
    );
  }
}
