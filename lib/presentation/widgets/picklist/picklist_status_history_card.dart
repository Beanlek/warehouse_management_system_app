import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/utils/utils.dart';

class PicklistStatusHistoryCard extends StatelessWidget {
  final Map dataMap;
  final String title;
  final double widthPercentage;
  
  const PicklistStatusHistoryCard({
    super.key,
    required this.dataMap,
    this.title = 'Status History',
    this.widthPercentage = .7,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, String> _renameKeys = {
      "created_date": "opened_at",
    };

    Map renamedDataMap = Map.fromEntries(
      dataMap.entries.map((e) => MapEntry(_renameKeys[e.key] ?? e.key, e.value ?? '-'))
    );

    final List<String> statusFlow = [
      'done_packing_at',
      'sent_for_picking_at',
      'started_packing_at',
      'opened_at'
    ];

    List<String> currentStatusFlow = [];

    for (var i = 0; i < statusFlow.length; i++) {
      for (var _key in renamedDataMap.keys) {
        if (statusFlow[i] == _key) {
          currentStatusFlow.add(_key);
        }
      }
    }

    Map newDataMap = LinkedHashMap.fromIterable(
      currentStatusFlow,
      key: (k) => k,
      value:(v) => renamedDataMap[v] ?? '',
    );
    
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
                  columnWidths: {0: FlexColumnWidth(1), 1: FlexColumnWidth(3)},
                  
                  children: newDataMap.entries.map((e) {
                      Icon _icon() {
                        if(newDataMap.entries.first.key == e.key) {
                          return Icon(Icons.circle, color: Colors.green,);
                        } else {
                          return Icon(Icons.circle_outlined, color: textColorTertiary, size: 20,);
                        }
                      }
                    
                      return TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: _icon(),
                        ),
                
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.key.toString().clean(), style: Theme.of(context).textTheme.labelLarge,),
                              Text(e.value.toString().formatDateTime('yyyy-MM-dd (EEE) hh:mm a') ?? '-'),
                            ],
                          ),
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