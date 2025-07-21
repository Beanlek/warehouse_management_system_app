import 'package:flutter/material.dart';
import 'package:warehouse/domain/entities/packing/packing.dart';
import 'package:warehouse/utils/utils.dart';

class PicklistPackingCard extends StatelessWidget {
  final List<Packing> dataList;
  final double widthPercentage;
  
  const PicklistPackingCard({
    super.key,
    required this.dataList,
    this.widthPercentage = .7,
  });

  @override
  Widget build(BuildContext context) {
    List<String> columnHeadersKey = [
      'van_allot_id',
      'van_id',
      'status'
    ];

    String columnHeaders(String k) {
      switch (k) {
        case 'van_allot_id': return 'Allotment ID';
        case 'van_id': return 'Van ID';
        case 'status': return 'Status';
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), )
                ),
                width: double.infinity,
                child: DataTable(
                  clipBehavior: Clip.antiAlias,
                  border: TableBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), ),
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
                        
                        return DataCell(Text(_value));
                        
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