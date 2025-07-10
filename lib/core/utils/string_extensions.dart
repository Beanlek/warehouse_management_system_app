import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

extension StringExtensions on String? {
  String toShorterDateString() {
    if (this == null) return '';
    DateTime dateTimeObject = DateTime.parse(this!);
    return DateFormat('yyyyMMdd', 'en_MY').format(dateTimeObject);
  }

  String toTimeString() {
    if (this == null) return '';
    DateTime dateTimeObject = DateTime.parse(this!);
    return DateFormat('HHmm', 'en_MY').format(dateTimeObject);
  }

  String toShortDateString() {
    if (this == null) return '';
    DateTime dateTimeObject = DateTime.parse(this!);
    return DateFormat('yyyy-MM-dd', 'en_MY').format(dateTimeObject);
  }

  bool toBool() {
    return this?.toLowerCase() == 'true';
  }

  String toCurrency(BuildContext context) {
    if (this == null || this == "null") return '';
    var locale = Localizations.localeOf(context);
    // debugPrint(locale.toString());
    return NumberFormat.simpleCurrency(locale: locale.toString()).format(double.parse(this!));
  }

  String toCapitalize() {
    if (this == null) return '';

    return this![0].toUpperCase() + this!.substring(1);
  }
}
