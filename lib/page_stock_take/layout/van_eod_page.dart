// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:warehouse/page_stock_take/widget/dialog_widget.dart';
import 'package:warehouse/shared_preference/token.dart';
import 'package:warehouse/utils/utils.dart';
import 'package:warehouse/van_stock_take/widget/modal.dart';
import 'package:warehouse/van_stock_take/widget/van_widget.dart';
import 'package:warehouse/widgets/global_dialog.dart';

class VanEODPage extends StatefulWidget {
  final String siteName;
  final String siteid;
  const VanEODPage({super.key, required this.siteid, required this.siteName});

  @override
  State<VanEODPage> createState() => _VanEODPageState();
}

class _VanEODPageState extends State<VanEODPage> {

  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  final controller = BoardDateTimeController();
  
  late String _token;
  
  List<DateTime?> selectedDate = [DateTime.now().add(Duration(hours: int.parse('8')))];
  List<Map<String, String>> vans = [];
  List<Map<String, dynamic>> vanDetails = [];
  String errMsg = 'No information provided by this van. Please foward this issue to management.';

  String? selectedVanId;
  bool showInactiveSKU = false;
  bool _isLoading = false;
  bool isDateSelected = false;
  bool vanDetailsLoading = false;
  bool showComment = true;

  @override
  void initState() {
    fetchToken();
    super.initState();
  }

  fetchToken() async {
    final String token = (await TokenUtil.getToken())!;
    setState(() {
      _token = token;
    });
  }

  double _responsiveFontSize() {
    final screenWidth = MediaQuery.of(context).size.width;
    const maxResolution = 1200.0;
    const maxSize = 26.0;

    return (screenWidth / maxResolution) * maxSize;
  }

  Future<void> clearVanDetails() async {
    setState(() {
      vanDetailsLoading = true;
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
        FloatingSnackBar(message: 'Van EOD Stock Take is acknowledged.', context: context);
        setState(() {
          isDateSelected = false;
          _commentFocusNode.unfocus();
        });
        // await showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return SuccessModal(
        //       buttonText: 'Okay',
        //       content: 'Van EOD stock take acknowledge.',
        //       title: 'Success',
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //     );
        //   },
        // );
        // Refresh the page after acknowledgment

        await fetchData(selectedDate, siteid);
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

    debugPrint('URL : ${url.toString()}');

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
              return DialogNotice(
                title: 'No Vans Found',
                notice: 'No vans were found for EOD return on the selected date.',
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
    if (siteId == 'null' && vanId == 'null') {
      setState(() {
        errMsg = 'This van has already been acknowledged.';
        vanDetailsLoading = false;
      });

      return;
    }
    final formattedDate =
        '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
    final String? domainName = await TokenUtil.getDomainName();

    String url =
        '$domainName/api/van/stock/take/wms/eod/sku/list/$siteId/$vanId/$formattedDate?inactive_bat=$showInactiveSKU';

    debugPrint('VANID : ${url.toString()}');

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
          _commentController.clear();
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
            const int skuUpdatedQuantity = 0;

            setState(() {
              vanDetails.add({
                'short_code': shortCode,
                'name': skuName,
                'brand': skuBrand,
                'sku_id': skuId,
                'uom_id': skuUom,
                'init_qty': skuQuantity,
                'updated_qty': skuUpdatedQuantity,
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

    setState(() {
      errMsg = !showInactiveSKU? 
              'No information provided by this van. Please foward this issue to management.':
              'No inactive SKU found'; //if showInactiveSKU is true and the list is empty
      vanDetailsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final dayTextStyle = TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: 16,);
    final weekendTextStyle = TextStyle(color: biruImran3, fontWeight: FontWeight.normal, fontSize: 14,);

    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),

      dayTextStyle: dayTextStyle,

      selectedDayHighlightColor: biruImran4,
      nextMonthIcon: Icon(Icons.navigate_next, color: white,),
      lastMonthIcon: Icon(Icons.navigate_before, color: white,),

      calendarType: CalendarDatePicker2Type.single,
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,

      weekdayLabelTextStyle: const TextStyle(
        color: white,
        fontSize: 12,
        fontWeight: FontWeight.w300,
      ),

      controlsTextStyle: const TextStyle(
        color: white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),

      centerAlignModePicker: true,
      selectedDayTextStyle: dayTextStyle.copyWith(color: biruImran),

      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        // if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
        //   textStyle = anniversaryTextStyle;
        // }
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
        return dayWidget;
      },

      monthBuilder: ({
        required month,
        decoration,
        isCurrentMonth,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        bool _isSelected = isSelected ?? false;
        List <String> months = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December'
        ];
        return Center(
          child: Container(
            height: 32,
            //width: 100,
            decoration: !_isSelected ? null :
            BoxDecoration(
              color: biruImran4,
              borderRadius: BorderRadius.all(radiusCircular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  months[month - 1],
                  style: _isSelected ? dayTextStyle.copyWith(color: biruImran) :
                  dayTextStyle,
                ),
                if (isCurrentMonth == true)
                  SizedBox(width: 10,),
                if (isCurrentMonth == true)
                  Icon(Icons.circle_rounded, color: _isSelected ? biruImran : white, size: 10,),
              ],
            ),
          ),
        );
      },
      
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        bool _isSelected = isSelected ?? false;

        return Center(
          child: Container(
            height: 32,
            width: 90,
            decoration: !_isSelected ? null :
            BoxDecoration(
              color: biruImran4,
              borderRadius: BorderRadius.all(radiusCircular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  year.toString(),
                  style: _isSelected ? dayTextStyle.copyWith(color: biruImran) :
                  dayTextStyle,
                ),
                if (isCurrentYear == true)
                  SizedBox(width: 10,),
                if (isCurrentYear == true)
                  Icon(Icons.circle_rounded, color: _isSelected ? biruImran : white, size: 10,),
              ],
            ),
          ),
        );
      },
    );

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        if (isKeyboardVisible == false) {
          _commentFocusNode.unfocus();
        }
        return GestureDetector( onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
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
            child:
            
            Stack(
              children: [
                Padding(
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
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(24.0),
                                child: Container(
                                  // elevation: 4,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: const [biruImran3, layoutBackgroundWhite],
                                    ),
                                    borderRadius: BorderRadius.circular(24)
                                  ),
                                  child: ListTile(
                                    leading: Icon(Icons.calendar_today, color: biruImran, size: _responsiveFontSize(),),
                                    title: Text(
                                      isDateSelected
                                          ? 'Selected Date: ${BoardDateFormat('dd MMMM yyyy').format(selectedDate[0]!)}'
                                          : 'Choose Date',
                                      style: TextStyle(
                                        color: !isDateSelected ? biruImran2 : biruImran
                                      )
                                    ),
                                    trailing:
                                    !isDateSelected ? null :
                                    IconButton(onPressed: () {
                                      setState(() {
                                        isDateSelected = false;
                                        selectedVanId = '';
                                      });
                                    }, icon: Icon(Icons.close, color: biruImran,)),
                                    onTap: () async {
                                      final values = await showCalendarDatePicker2Dialog(
                                        context: context,
                                        config: config,
                                        dialogSize: Size(screenWidth * 0.6, screenHeight * 0.2),
                                        borderRadius: BorderRadius.circular(15),
                                        value: selectedDate,
                                        dialogBackgroundColor: biruImran,
                                      );
                                      if (values != null) {
                                        debugPrint(values.toString());
                                        setState(() {
                                          selectedVanId = '';
                                          vanDetails.clear();
                                          isDateSelected = true;
                                          selectedDate[0] = values[0];
                                        });
                                        fetchData(selectedDate[0]!, widget.siteid);
                                      }
                                                
                                    },
                                  ),
                                ),
                              ),
                            ),
                        
                            if (vans.isNotEmpty && isDateSelected)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: vans
                                          .map((van) => Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: VanWidget(
                                                  vanId: van['id'] ?? 'N/A',
                                                  status: van['status'] ?? 'N/A',
                                                  siteId: widget.siteid,
                                                  selectedDate: selectedDate[0]!,
                                                  token: _token,
                                                  fetchDataForVan: fetchDataForVan,
                                                  onCloseCalendar: () {
                                                    controller.close();
                                                  },
                                                  clearVanDetails: () async {
                                                    await clearVanDetails();
                                                  },
                                                  
                                                  isSelected: van['id'] == selectedVanId,
                                                  // isSelected: false,
                                                  
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
                                  Row(
                                    children: [
                                      Checkbox(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        activeColor: biruImran,
                                        value: showInactiveSKU, 
                                        onChanged: (value){
                                          setState(() {
                                            showInactiveSKU = value!;
                                            //refresh the van details
                                            vanDetails.clear();
                                            fetchDataForVan(
                                              widget.siteid,
                                              selectedVanId!,
                                              selectedDate[0]!,
                                              _token);
                                            debugPrint('Show Inactive SKU : $showInactiveSKU');
                                          });
                                        }
                                      ),
                                      Text('Show Inactive BAT SKU', style: TextStyle(color: biruImran),),
                                    ],
                                  )
                                ],
                              ),
                        
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child:
                                  !(vans.isNotEmpty && isDateSelected) ?
                                  Center(child: Text('Please choose date for van stock take', style: TextStyle(color: biruImran),)) :
                                  vanDetailsLoading ?
                                  Center(child: CircularProgressIndicator()) :
                                  (vanDetails.isEmpty && selectedVanId != '') ?
                                  Center(child: Text(errMsg, style: TextStyle(color: biruImran),)) :
                                  (vanDetails.isEmpty && selectedVanId == '') ?
                                  Center(child: Text('Select a van to view details.', style: TextStyle(color: biruImran),)) :
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GroupedListView<dynamic, String>(
                                      elements: vanDetails,
                                      groupBy: (element) => element['short_code'],
                                      
                                      groupSeparatorBuilder: (String value) =>
                                      
                                      Card(
                                        color: biruImran,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            value,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: _responsiveFontSize(),
                                              color: white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      itemBuilder: (context, element) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                          child: ListTile(
                                            title: Text(
                                              '${element['name']}',
                                              style: TextStyle(
                                                fontSize: _responsiveFontSize(),
                                                fontWeight: FontWeight.bold,
                                                color: biruImran
                                              ),
                                            ),
                                            subtitle: RichText(
                                              overflow: TextOverflow.visible,
                                              text: TextSpan(
                                                  text: 'SKU ID   ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    color: biruImran,
                                                    fontSize: _responsiveFontSize() * 0.8,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: '${element['sku_id']}',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.normal,
                                                        fontSize: _responsiveFontSize() * 0.8,
                                                        color: biruImran,
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                            trailing:
                                            
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.2,
                                              child: TextFormField(
                                                initialValue: '${element['updated_qty']}',
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(color: biruImran2),
                                                decoration: InputDecoration(
                                                  labelText: 'Quantity',
                                                  suffixIcon: Icon(Icons.edit, size: _responsiveFontSize() * 0.8, color: biruImran,),
                                                ),
                                                onChanged: (value) {
                                                  if (value.isEmpty) {
                                                    value = '0';
                                                  }
                                                  
                                                  final int inputQty = int.parse(value);
                                                  value = inputQty.toString();

                                                  setState(() {
                                                    element['updated_qty'] = value;
                                                  });
                                                  // debugPrint(vanDetails.toString());
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                
                
                              ),
                            ),
                        
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 32,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              showComment = !showComment;
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Comment',
                                                style: TextStyle(
                                                  fontSize: _responsiveFontSize(),
                                                  fontWeight: FontWeight.bold,
                                                  color: biruImran,
                                                ),
                                              ),
                                              Icon(
                                                showComment ?
                                                  Icons.keyboard_arrow_down :
                                                  Icons.keyboard_arrow_up,
                                                color: biruImran,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      !showComment ? SizedBox() :
                                      const SizedBox(height: 12,),
                                      !showComment ? SizedBox() :
                                      TextFormField(
                                        focusNode: _commentFocusNode,
                                        controller: _commentController,
                                        keyboardType: TextInputType.multiline,
                                        minLines: 5,
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: biruImran,
                                              width: 2
                                            ),
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(15.0)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: biruImran,
                                              width: 1
                                            ),
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(15.0)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        height: 50,
                                        child: TextButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DialogExitConfirmation();
                                              },
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            elevation: 10,
                                            backgroundColor: biruImran4,
                                          ),
                                          child: const Text(
                                            "Back",
                                            style: TextStyle(
                                              color: biruImran,
                                              fontSize: 16
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 300,
                                        height: 50,
                                        child: TextButton(
                                          // onPressed: () {
                                          //   debugPrint('HA : ${vanDetails.toString()}');
                                          // },
                                          onPressed: _commentController.text.isNotEmpty ? () async {
                                            bool _confirmSave = false;
                                            
                                            _confirmSave = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DialogSaveConfirmation();
                                              },
                                            );
                                            
                                            if (_confirmSave) {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                            
                                              await acknowledgeData(
                                                    selectedDate[0]!,
                                                    widget.siteid,
                                                    vanDetails,
                                                    selectedVanId!,
                                                    _commentController,
                                                    _token).whenComplete(() {
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              });
                                            }
                                            
                                          } :
                                          () {
                                            FloatingSnackBar(
                                              message: 'Please enter comment before saving.',
                                              context: context,
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor: _commentController.text.isNotEmpty ? hijauImran : Colors.transparent,
                                            side: BorderSide(
                                              color: _commentController.text.isNotEmpty ? Colors.transparent : greyColor
                                            )
                                          ),
                                          child: Text(
                                            "Acknowledge",
                                            style: TextStyle(
                                              color: _commentController.text.isNotEmpty ? white : greyColor,
                                              fontSize: 16
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                ],
                              ),
                            ),
                        
                        
                        
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       color: Colors.grey[200],
                            //       borderRadius: BorderRadius.circular(8.0),
                            //     ),
                            //     child: TextField(
                            //       controller: commentController,
                            //       maxLines: 3,
                            //       // controller: _commentController,
                            //       decoration: const InputDecoration(
                            //         hintText: 'Enter your comment...',
                            //         contentPadding: EdgeInsets.all(12.0),
                            //         border: InputBorder.none,
                            //       ),
                            //       // controller: _commentController,
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(height: 20.0),
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            //   child: ElevatedButton(
                            //     onPressed: selectedVanId != null
                            //         ? () {
                            //             showDialog(
                            //               context: context,
                            //               builder: (BuildContext context) {
                            //                 return ConfirmationModal(
                            //                   title: 'Confirmation',
                            //                   content: 'Are you sure you want to proceed?',
                            //                   confirmText: 'Yes',
                            //                   cancelText: 'Cancel',
                            //                   onConfirm: () {
                            //                     acknowledgeData(
                            //                         selectedDate[0]!,
                            //                         widget.siteid,
                            //                         vanDetails,
                            //                         selectedVanId!,
                            //                         commentController,
                            //                         _token);
                            //                     Navigator.of(context).pop(); // Close the dialog
                            //                   },
                            //                   onCancel: () {
                            //                     // Handle cancel action
                            //                     Navigator.of(context).pop(); // Close the dialog
                            //                   },
                            //                 );
                            //               },
                            //             );
                            //           }
                            //         : null,
                            //     style: ElevatedButton.styleFrom(
                            //       backgroundColor: colorFirst,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(10.0),
                            //       ),
                            //       padding: EdgeInsets.symmetric(
                            //           vertical: 15.0,
                            //           horizontal: MediaQuery.of(context).size.width * 0.25),
                            //       elevation: 3.0,
                            //     ),
                            //     child: const Text(
                            //       'Save',
                            //       style: TextStyle(color: Colors.white),
                            //     ),
                            //   ),
                            // ),
                        
                        
                        
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        
                _isLoading ? Opacity(opacity: 0.5,child: Container(
                    color: white,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: CircularProgressIndicator()),
                    ),
                  ) : SizedBox()
              ],
            ),
          ),
        ));
      }
    );
  }
}
