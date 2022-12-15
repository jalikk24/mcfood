import 'package:intl/intl.dart';

class FormatCurrency {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: decimalDigit,
    );
    return "Rp " + currencyFormatter.format(number);
  }
}