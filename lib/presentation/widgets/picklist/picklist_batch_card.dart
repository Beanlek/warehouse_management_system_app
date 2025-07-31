import 'package:flutter/material.dart';
import 'package:warehouse/domain/entities/batch/batch.dart';
import 'package:warehouse/utils/utils.dart';

class PicklistBatchCard extends StatefulWidget {
  final List<Batch> dataList;
  final String title;
  final double widthPercentage;

  const PicklistBatchCard({
    super.key,
    required this.dataList,
    this.title = 'Batch Picklist',
    this.widthPercentage = .7,
  });

  @override
  State<PicklistBatchCard> createState() => _PicklistBatchCardState();

}

class _PicklistBatchCardState extends State<PicklistBatchCard> {

  final ScrollController _scrollController = ScrollController();
  
  @override
    void dispose() {
      _scrollController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    List<String> columnHeadersKey = [
      'sku_id',
      'uom_id',
      'available',
      'reserved',
      'eod_reserved',
      'allotted',
    ];

    String columnHeaders(String k) {
      switch (k) {
        case 'sku_id':
          return 'SKU ID';
        case 'uom_id':
          return 'UOM';
        case 'available':
          return 'Available';
        case 'reserved':
          return 'Reserved';
        case 'eod_reserved':
          return 'EOD Reserved';
        case 'allotted':
          return 'Allotted';
        default:
          return '-';
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * widget.widthPercentage,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  color: biruImran,
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              ClipRect(
                child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      border: TableBorder(
                        horizontalInside: BorderSide(
                          width: 1,
                          color: biruImran3,
                          style: BorderStyle.solid,
                        ),
                        verticalInside: BorderSide(
                          width: 3,
                          color: biruImran3,
                          style: BorderStyle.solid,
                        ),
                      ),
                      headingRowColor: MaterialStateProperty.all(biruImran3),
                      headingTextStyle: Theme.of(context).textTheme.labelMedium,
                      columns: columnHeadersKey
                          .map(
                            (e) => DataColumn(
                              headingRowAlignment: MainAxisAlignment.start,
                              label: Text(columnHeaders(e)),
                            ),
                          )
                          .toList(),
                      rows: widget.dataList.map((batch) {
                        return DataRow(
                          cells: columnHeadersKey.map((key) {
                            String displayText = '-';
                            TextAlign textAlign = TextAlign.start;
                  
                            switch (key) {
                              case 'sku_id':
                                displayText = batch.skuId ?? '-';
                                break;
                              case 'uom_id':
                                displayText = batch.uomId ?? '-';
                                break;
                              case 'available':
                              case 'reserved':
                              case 'eod_reserved':
                              case 'allotted':
                                int index = {
                                  'available': 0,
                                  'reserved': 1,
                                  'eod_reserved': 2,
                                  'allotted': 3,
                                }[key]!;
                                if (batch.quantity.length > index) {
                                  displayText = batch.quantity[index].toString();
                                  textAlign = TextAlign.end;
                                }
                                break;
                            }
                            return DataCell(
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  displayText,
                                  textAlign: textAlign,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
