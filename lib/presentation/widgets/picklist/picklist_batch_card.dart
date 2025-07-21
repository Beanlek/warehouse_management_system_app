import 'package:flutter/material.dart';
import 'package:warehouse/domain/entities/batch/batch.dart';
import 'package:warehouse/utils/utils.dart';

class PicklistBatchCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    List<String> columnHeadersKey = [
      'sku_id',
      'uom_id',
      'quantity'
    ];

    String columnHeaders(String k) {
      switch (k) {
        case 'sku_id': return 'SKU ID';
        case 'uom_id': return 'UOM';
        case 'quantity': return 'Alloted Qty';
        default: return '-';
      }
    } 
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * widthPercentage,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), ),
                  color: biruImran,
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(title, style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white),),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: DataTable(
                  border: TableBorder(
                    horizontalInside: BorderSide(
                        width: 1, color: biruImran3, style: BorderStyle.solid),
                    verticalInside: BorderSide(
                        width: 3, color: biruImran3, style: BorderStyle.solid),
                  ),
                  headingRowColor: MaterialStateProperty.all(biruImran3),
                  headingTextStyle: Theme.of(context).textTheme.labelMedium,

                  columns: columnHeadersKey.map((e) {
                      return DataColumn(
                        headingRowAlignment: MainAxisAlignment.start,
                        label: Text(
                          columnHeaders(e),
                        ),
                      );
                    }).toList(),
                  rows: dataList.map((e) {
                    return DataRow(cells:
                      columnHeadersKey.map((v) {
                        final _value = e.toJson()[v];

                        TextAlign _textAlign = TextAlign.start;
                        String _valueToShow = '-';

                        if (_value is List) {
                          _valueToShow = _value[0].toString();
                          _textAlign = TextAlign.end;
                        } else {
                          _valueToShow = _value.toString();
                        }
                        
                        return DataCell(
                          SizedBox(
                            width: double.infinity,
                            child: Text(_valueToShow, textAlign: _textAlign,)
                          )
                        );

                      }).toList()
                    );
                  }).toList()
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}