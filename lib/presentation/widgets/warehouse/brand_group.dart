import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/presentation/blocs/warehouse/warehouse_bloc.dart';
import 'package:warehouse/presentation/blocs/warehouse/warehouse_state.dart';
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
                  color: biruImran),
            ),
            _buildIcon()
          ],
        ),
      ),
      collapsed: Column(
        children: [
          Container(
            height: 50,
            alignment: Alignment.centerLeft,
            color: lightBlue,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Name',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: black),
              ),
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

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Text(product.name ?? '');
                },
              );

            },
          ),
        ],
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
}
