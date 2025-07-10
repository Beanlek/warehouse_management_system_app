// ignore_for_file: avoid_print, use_build_context_synchronously, unused_field, library_private_types_in_public_api, prefer_const_constructors, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps, non_constant_identifier_names, constant_identifier_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:warehouse/utils/utils.dart';
import 'package:warehouse/presentation/views/van_allotment/components/allotment_components.dart';

class AllotmentListsLookup extends StatefulWidget {
  const AllotmentListsLookup({
    super.key,
    required this.allotmentType
  });

  final String allotmentType;

  @override
  _AllotmentListsLookupState createState() => _AllotmentListsLookupState();
}

class _AllotmentListsLookupState extends State<AllotmentListsLookup> with AllotmentComponents {

  @override
  void initState() {
    super.initState();
    setState(() {
      myFormat = DateFormat('dd-MM-yyyy').add_Hms();
      allotment_type = widget.allotmentType;
      getToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          title: Text(
            '${titleCheck(allotment_type)} Lists',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: biruImran,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 24.0, right: 20),
                child: RichText(
                  text: TextSpan(
                      text: 'Home ',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pop();
                        },
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: textColorTertiary,
                      ),
                      children: [TextSpan(text: '> ${titleCheck(allotment_type)}')]),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: onSearchSubmitted,
                          controller: searchFieldController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'Search ...',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: greyColor, width: 2))),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: greyColor, width: 2)),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: DropdownButton<String>(
                            padding: EdgeInsets.only(right: 12, left: 12),
                            isExpanded: true,
                            value: selectedFilter,
                            items: filters
                                .map(
                                  (filter) => DropdownMenuItem<String>(
                                    alignment: AlignmentDirectional.centerEnd,
                                    value: filter,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: SizedBox(
                                        child: Text(
                                          filter,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (filter) async {
                              setState(
                                () {
                                  selectedFilter = filter!;
                                  currentPage = 0;
                                  paginatorController.currentPage = 0;
                                  allotments.clear();
                                },
                              );
                              await fetchAPI(tokenComponent);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: numPages == 1 ? 12 : 24,
            ),
            numPages == 1 ?
            SizedBox() :
            SizedBox(
              width: (MediaQuery.of(context).size.width / 7) * 4,
              child: NumberPaginator(
                controller: paginatorController,
                numberPages: numPages,
                onPageChange: (index) async {
                  setState(() {
                    allotments.clear();
                    currentPage = index;
                  });
                  await fetchAPI(tokenComponent);
                },
                config: NumberPaginatorUIConfig(
                  buttonSelectedForegroundColor: white,
                  buttonUnselectedForegroundColor: textColorTertiary,
                  buttonSelectedBackgroundColor: biruImran,
                ),
                showNextButton: numPages == 1 ? false : true,
                showPrevButton: numPages == 1 ? false : true,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: RefreshIndicator(
                color: colorFirst,
                backgroundColor: whiteColor,
                onRefresh: refreshData,
                child: buildListView(selectedFilter),
              ),
            ),
          ],
        ),
      ),
    ));
  }

}
