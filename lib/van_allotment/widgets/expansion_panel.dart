// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:warehouse/van%20allotment/layout/allotment_detail.dart';

class ExpansionPanelWidget extends StatefulWidget {
  int? index;

  ExpansionPanelWidget({super.key, this.index});

  @override
  _ExpansionPanelWidgetState createState() => _ExpansionPanelWidgetState();
}

class _ExpansionPanelWidgetState extends State<ExpansionPanelWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Card(
      color: whiteSmoke,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Theme(
        data: ThemeData(
            dividerColor: Colors.transparent, textTheme: theme.textTheme),
        child: ExpansionTile(
          leading: const Icon(Icons.info_outline, color: Colors.grey),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          title: Text(
            'Van ${widget.index! + 1}',
            style: TextStyle(
              color: Colors.blue.shade900,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Van allotment ${widget.index! + 1}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13.0,
            ),
          ),
          trailing: isExpanded
              ? Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue.withAlpha(64),
                  ),
                  child: const Icon(Icons.keyboard_arrow_up,
                      color: Colors.blue, size: 30),
                )
              : Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: transparentColor,
                  ),
                  child: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.grey, size: 30),
                ),
          onExpansionChanged: (t) {
            isExpanded = !isExpanded.validate(value: false);
            setState(() {});
          },
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(32),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        'Allotment ID: A00000059263',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  16.height,
                  SettingItemWidget(
                    title: 'Van ID / Van Driver',
                    subTitle: 'V2WV004 / Imran',
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(32),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(Icons.person, color: Colors.blue),
                    ),
                  ),
                  SettingItemWidget(
                    title: 'Status / Tag',
                    subTitle: 'Packed / Balance',
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(32),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(Icons.checklist_rounded,
                          color: Colors.blue),
                    ),
                  ),
                  SettingItemWidget(
                    title: 'Allotment Date',
                    subTitle: '2024-01-12',
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(32),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child:
                          const Icon(Icons.calendar_today, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const AllotmentDetailView(),
                          //   ),
                          // );
                        },
                        color: Colors.blue,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        text: 'View Details',
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        padding: const EdgeInsets.all(12),
                      ),
                      8.width,
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
