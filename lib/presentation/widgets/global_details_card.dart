import 'package:flutter/material.dart';
import 'package:warehouse/utils/utils.dart';

class DetailsCard extends StatelessWidget {
  final Map dataMap;
  final String title;
  final double widthPercentage;
  
  const DetailsCard({
    super.key,
    required this.dataMap,
    this.title = 'Details',
    this.widthPercentage = .7,
  });

  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Table(
                  columnWidths: {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      color: textColorTertiary
                    )
                  ),
                  
                  children: dataMap.entries.map((e) {
                        return TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(e.key.toString().clean(), style: Theme.of(context).textTheme.labelLarge,),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(e.value ?? '-'),
                          ),
                        ]);
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}