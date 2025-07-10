// ignore: file_names
// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart' as http;
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';
import 'package:warehouse/presentation/views/van_stock_take/widget/modal.dart';
import 'package:warehouse/presentation/views/van_stock_take/widget/van_widget.dart';
import 'package:warehouse/presentation/widgets/global_dialog.dart';

class VanStockTake extends StatefulWidget {
  final String siteName;
  final String siteid;
  const VanStockTake({super.key, required this.siteid, required this.siteName});

  @override
  State<VanStockTake> createState() => _VanStockTakeState();
}

class _VanStockTakeState extends State<VanStockTake> {
  final dayTextStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
  final weekendTextStyle =
      TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
  final anniversaryTextStyle = TextStyle(
    color: Colors.red[400],
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
  );

  late CalendarDatePicker2WithActionButtonsConfig config;

  final controller = BoardDateTimeController();
  bool isDateSelected = false;
  List<DateTime?> selectedDate = [DateTime.now().add(Duration(hours: int.parse('8')))];
  List<Map<String, String>> vans = [];
  late String _token;
  List<Map<String, dynamic>> vanDetails = [];
  String? selectedVanId; // Track the ID of the currently selected van
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // selectedDate[0] = DateTime.now();
    fetchToken();
    config = CalendarDatePicker2WithActionButtonsConfig(
      calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.single,
      selectedDayHighlightColor: colorFirst,
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // Call openPicker() after the build is complete
    //   controller.openPicker();
    // });
  }

  fetchToken() async {
    final String token = (await TokenUtil.getToken())!;
    setState(() {
      _token = token;
    });
  }

  Future<void> clearVanDetails() async {
    setState(() {
      vanDetails.clear();
    });
  }

  Future<void> acknowledgeData(
    final DateTime selectedDate,
    final String siteid,
    final List<Map<String, dynamic>> vanDetails,
    final String vanid,
    final TextEditingController commentController,
    final token,
  ) async {
    final formattedDate =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    final String? domainName = await TokenUtil.getDomainName();

    String url =
        '$domainName/api/acknowledgment/wms/van/stock/take/acknowledge';

    try {
      List<Map<String, dynamic>> selectedVanDetails = [];
      for (var detail in vanDetails) {
        // Create a new detail without 'name' and 'brand'
        Map<String, dynamic> selectedDetail = {
          'sku_id': detail['sku_id'],
          'uom_id': detail['uom_id'],
          'init_qty': detail['init_qty'],
          'updated_qty': detail['updated_qty'],
        };
        selectedVanDetails.add(selectedDetail);
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'comment': commentController.text,
          'date': formattedDate,
          'site_id': siteid,
          'van_id': vanid,
          'skus': selectedVanDetails
        }),
      );

      if (response.statusCode == 200) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return SuccessModal(
              buttonText: 'Okay',
              content: 'Van EOD stock take acknowledge.',
              title: 'Success',
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        );
        // Refresh the page after acknowledgment

        fetchData(selectedDate, siteid);
        selectedVanDetails.clear();
        commentController.clear();
        debugPrint("Acknowledgement successful!");
      } else {
        // Handle other error responses
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorModal(
              buttonText: 'Okay',
              content: 'Error: ${response.statusCode}',
              title: 'Error',
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    } catch (e) {
      // Handle any exceptions
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorModal(
            buttonText: 'Okay',
            content: 'Exception: $e',
            title: 'Error',
            onPressed: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  Future<void> fetchData(DateTime selectedDate, String siteid) async {
    final formattedDate =
        '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
    final String? domainName = await TokenUtil.getDomainName();

    String url =
        '$domainName/api/van/stock/take/wms/list/vanStatus/$siteid/$formattedDate';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> vansJson = json['vans'];

        setState(() {
          vans = vansJson.map<Map<String, String>>((van) {
            return {
              'id': van['id'],
              'status': van['status'],
            };
          }).toList();
        });

        if (vans.isEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ErrorModal(
                buttonText: 'Okay',
                content:
                    'No vans were found for EOD return on the selected date.',
                title: ' No Vans Found',
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          );
        }
      } else {
        debugPrint('Failed to fetch API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      debugPrint(formattedDate);
      debugPrint(url);
    } finally {}
  }

  void fetchDataForVan(String siteId, vanId, selectedDate, token) async {
    final formattedDate =
        '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
    final String? domainName = await TokenUtil.getDomainName();

    String url =
        '$domainName/api/van/stock/take/wms/eod/sku/list/$siteId/$vanId/$formattedDate';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> skuList = jsonData['skuList'];

        setState(() {
          vanDetails.clear();
          commentController.clear();
        });

        for (var skuEntry in skuList) {
          final shortCode = skuEntry['short_code'];
          final List<dynamic> skus = skuEntry['skus'];

          for (var sku in skus) {
            final skuName = sku['name'];
            final skuBrand = sku['brand'];
            final skuId = sku['sku_id'];
            final skuUom = sku['uom_id'];
            final skuQuantity = sku['quantity'][0];

            setState(() {
              vanDetails.add({
                'short_code': shortCode,
                'name': skuName,
                'brand': skuBrand,
                'sku_id': skuId,
                'uom_id': skuUom,
                'init_qty': skuQuantity,
                'updated_qty': skuQuantity,
              });
            });
          }
        }
      } else {
        debugPrint('Failed to fetch API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      debugPrint('Formatted Date: $formattedDate');
      debugPrint('URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          title: Text(
            'Van EOD Stock Take',
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
      body:
      WillPopScope(
        onWillPop: () async {
          bool willPop = false;
          willPop = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogExitConfirmation();
            },
          );

          return willPop;
        },
        child: Padding(
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DialogExitConfirmation(toHome: true);
                              },
                            );
                          },
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          color: textColorTertiary,
                        ),
                        children: [
                          TextSpan(
                            text: '> Van EOD Stock Take ',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogExitConfirmation();
                                  },
                                );
                              },
                          ),
                          TextSpan(
                            text: '> ${widget.siteName}',
                          ),
                        ],
                      ),
                    ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 4,
                      child: ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text(
                          isDateSelected
                              ? 'Selected Date: ${BoardDateFormat('dd MMMM yyyy').format(selectedDate[0]!)}'
                              : 'Choose Date',
                        ),
                        trailing: const Text('Date'),
                        onTap: () async {
                          // controller.openPicker();
                          // _buildCalendarDialogButton();
                          final values = await showCalendarDatePicker2Dialog(
                            context: context,
                            config: config,
                            dialogSize: const Size(325, 400),
                            borderRadius: BorderRadius.circular(15),
                            value: selectedDate,
                            dialogBackgroundColor: Colors.white,
                          );
                          if (values != null) {
                            debugPrint(values.toString());
                            // debugPrint(_getValueText(
                            //   config.calendarType,
                            //   values,
                            // ));
                            setState(() {
                              isDateSelected = true;
                              selectedDate[0] = values[0];
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isDateSelected
                        ? () => fetchData(selectedDate[0]!, widget.siteid)
                        : null,
                    style: ButtonStyle(
                      backgroundColor: isDateSelected
                          ? MaterialStateProperty.all<Color>(colorFirst)
                          : MaterialStateProperty.all<Color>(Colors.grey.shade300),
                      elevation: MaterialStateProperty.all<double>(4),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      child: Text(
                        'Check Date',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (vans.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: vans
                            .map((van) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: VanWidget(
                                    vanId: van['id'] ?? '',
                                    status: van['status'] ?? '',
                                    siteId: widget.siteid,
                                    selectedDate: selectedDate[0]!,
                                    token: _token,
                                    fetchDataForVan: fetchDataForVan,
                                    onCloseCalendar: () {
                                      controller.close();
                                    },
                                    clearVanDetails: () async =>
                                        await clearVanDetails(),
                                    // Pass whether this van is selected or not
                                    isSelected: van['id'] == selectedVanId,
                                    onVanSelected: (vanId) {
                                      setState(() {
                                        selectedVanId = vanId;
                                      });
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: isDateSelected
                        ? Container(
                          height: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GroupedListView<dynamic, String>(
                                elements: vanDetails,
                                groupBy: (element) => element['short_code'],
                                groupSeparatorBuilder: (String value) => Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    title: Text(
                                      'Brand: $value',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                ),
                                itemBuilder: (context, element) {
                                  return Card(
                                    elevation: 2.0,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        'SKU Name: ${element['name']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'SKU ID: ${element['sku_id']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      trailing: SizedBox(
                                        width: 100,
                                        child: TextFormField(
                                          initialValue: '${element['init_qty']}',
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              // Update the 'updated_qty' value of the element
                                              element['updated_qty'] = value;
                                            });
                                            debugPrint(vanDetails.toString());
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : Text('Please choose date for van stock take'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: commentController,
                        maxLines: 3,
                        // controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your comment...',
                          contentPadding: EdgeInsets.all(12.0),
                          border: InputBorder.none,
                        ),
                        // controller: _commentController,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: ElevatedButton(
                      onPressed: selectedVanId != null
                          ? () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmationModal(
                                    title: 'Confirmation',
                                    content: 'Are you sure you want to proceed?',
                                    confirmText: 'Yes',
                                    cancelText: 'Cancel',
                                    onConfirm: () {
                                      acknowledgeData(
                                          selectedDate[0]!,
                                          widget.siteid,
                                          vanDetails,
                                          selectedVanId!,
                                          commentController,
                                          _token);
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    onCancel: () {
                                      // Handle cancel action
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                  );
                                },
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorFirst,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: MediaQuery.of(context).size.width * 0.25),
                        elevation: 3.0,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
