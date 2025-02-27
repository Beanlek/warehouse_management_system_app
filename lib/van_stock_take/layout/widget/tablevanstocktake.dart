import 'package:flutter/material.dart';

class VanStockTakeTable extends StatelessWidget {
  final List<Map<String, String>> vans;

  const VanStockTakeTable({super.key, required this.vans});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Van ID',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Status',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: vans.map((van) {
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(van['id'] ?? '')),
            DataCell(Text(van['status'] ?? '')),
          ],
        );
      }).toList(),
    );
  }
}
