/// Formats [amount] with thousands separators, e.g. "PKR 85,000".
String formatPrice(num amount, String currency) {
  final digits = amount.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return '$currency $buffer';
}

/// "6 days, 5 nights" (or "1 day" for day trips).
String formatDuration(int days) {
  if (days <= 1) return '1 day';
  return '$days days, ${days - 1} nights';
}

const List<String> _monthNames = [
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
  'December',
];

/// "August 2027".
String formatMonthYear(DateTime date) =>
    '${_monthNames[date.month - 1]} ${date.year}';