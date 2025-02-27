// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/utils/color.dart'; 

class ListAllotmentView extends StatefulWidget {
  const ListAllotmentView({super.key});

  @override
  ListAllotmentViewState createState() => ListAllotmentViewState();
}

class ListAllotmentViewState extends State<ListAllotmentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Van Allotment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorFirst,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle search button press
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Icon(Icons.sort)],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    child: ExpansionPanelWidget(index: index),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpansionPanelWidget extends StatefulWidget {
  int? index;

  ExpansionPanelWidget({super.key, this.index});

  @override
  ExpansionPanelWidgetState createState() => ExpansionPanelWidgetState();
}

class ExpansionPanelWidgetState extends State<ExpansionPanelWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Card(
      color: whiteSmoke,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
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
