// ignore_for_file: unnecessary_this, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL() async {
  final Uri url = Uri.parse('https://amast.com.my/');
  if (!await launchUrl(url)) {
        throw Exception('Could not launch https://amast.com.my/');
    }
}

const String ALLOT_PLAN = 'allot_plan';
const String ALLOT_BALANCE = 'allot_balance';
const String ALLOT_ADDITIONAL = 'allot_additional';
const String ALLOT_REQUEST = 'adhoc_request';
const String ADHOC_REQUEST = 'van_adhoc_request';
const String ADHOC_RETURN = 'adhoc_return';
const String WAREHOUSE_STOCKTAKE = 'warehouse_stocktake';
const String SALES_ORDER = 'sales_order';
const String VAN_STOCKTAKE = 'van_stocktake';
const String MARKET_RETURN = 'market_return';
const String RETURN_ORDER = 'return_order';
const String TRANSFER_IN = 'transfer_in';
const String TRANSFER_OUT = 'transfer_out';

const String ALL = 'All';
const String ACKNOWLEDGED ='Acknowledged';
const String UNACKNOWLEDGED ='Unacknowledged';
const String RECEIVED ='Received';

const String PENDING_WA_ACK ='Pending_wa_ack';
const String PENDING ='Pending';
const String REJECTED ='Rejected';
const String ALLOTTED ='Allotted';
const String EXPIRED ='Expired';

String titleCheck(String _recordType) {
      switch (_recordType) {
        case ALLOT_PLAN:
          return 'Allotment Plan';
        case ALLOT_BALANCE:
          return 'Allotment Balance';
        case ALLOT_ADDITIONAL:
          return 'Allotment Additional';
        case ALLOT_REQUEST:
          return 'Allotment Request';
        case ADHOC_REQUEST:
          return 'Adhoc Request';
        case ADHOC_RETURN:
          return 'Adhoc Return';
        case WAREHOUSE_STOCKTAKE:
          return 'Warehouse Stocktake';
        case SALES_ORDER:
          return 'Sales Order';
        case VAN_STOCKTAKE:
          return 'Van Stock Take';
        case MARKET_RETURN:
          return 'Market Return';
        case RETURN_ORDER:
          return 'MR Return Order';
        case TRANSFER_IN:
          return 'Transfer In';
        case TRANSFER_OUT:
          return 'Transfer Out';
        default:
          return 'NNN';
      }
    }

extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    }

    String capitalizeCamelCase() {
      String spaced = this.replaceAllMapped(RegExp(r'(?<!^)([A-Z])'), (match) {
        return ' ${match.group(1)}';
      });

      // Capitalize the first letter of each word
      String titleCase = spaced.split(' ').map((word) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join(' ');

      return titleCase;
    }
}

void printLongString(String text) {
  final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((RegExpMatch match) =>   debugPrint(match.group(0)));
}

Widget ERROR_OVERLAY() {
  return const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, color: colorMerah, size: 80,),
            SizedBox(height: 12,),
            Text('Error occured while trying to show page.', style: TextStyle(color: biruImran, fontSize: 20),)
          ],
        ),
      );
}

final primaryColor = Colors.blue.withAlpha(32);
const secondaryColor = darkBlue;
const textColorPrimary = Color(0xFF130925);
const textColorSecondary = Color(0xFF757575);
const textColorTertiary = Color(0xFF8E8E8E);
// const whiteColor = Color(0xFFffffff);
// const blackColor = Color(0xFF000000);
const greyColor = Color(0xFFB9B9B9);
const greyColor2 = Color(0xFFEFEFEF);
const whiteTransparent = Color(0xFFF1F1F1);
const layoutBackgroundWhite = Color(0xFFF6F7FA);
const category1Color = Color(0xFF45c7db);
const category2Color = Color(0xFF510AD7);
const category3Color = Color(0xFFe43649);
const category4Color = Color(0xFFf4b428);
const category5Color = Color(0xFF22ce9a);
const category6Color = Color(0xFF203afb);
const colorPrimaryLight = Color(0x505104D7);

const colorHitamAiman = Color(0xFF1D1D1D);
const colorOrenAiman = Color(0xFFF59115);
const colorCoklatAiman = Color(0xFF46332E);

const hijauImran = Color(0xFF288E3E);
const hijauImran2 = Color(0xFF72A541);
const hijauImran3 = Color(0xFFC6FFAE);
const biruImran = Color(0xFF11205E);
const biruImran2 = Color(0xFF0F75BC);
const biruImran3 = Color.fromARGB(120, 226, 230, 255);
const biruImran4 = Color.fromARGB(255, 226, 230, 255);

const colorFirst = Color(0xFF192bc2);
const colorSecond = Color(0xFF449dd1);
const colorThird = Color(0xFF78c0e0);
const colorMerah = Color(0xFFe63946);

const backgroundColor = Color(0xFFe3edf8);
