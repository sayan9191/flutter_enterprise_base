import 'package:intl/intl.dart';

abstract final class Formatters {
  static final currency = NumberFormat.currency(symbol: '\$');
  static final compact = NumberFormat.compact();

  static String phone(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    }
    return value;
  }
}
