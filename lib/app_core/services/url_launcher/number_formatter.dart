import 'package:intl/intl.dart' as intl;

class NumberFormatter {
  /// leadingZeroFormat
  static String leadingZeroFormat(int number) {
    return intl.NumberFormat('00').format(number);
  }
}
