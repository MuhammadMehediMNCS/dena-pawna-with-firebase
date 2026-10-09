/// ইংরেজি সংখ্যাকে বাংলা সংখ্যায় রূপান্তর করে।
///
/// উদাহরণ: `toBengaliDigits(50)` -> `'৫০'`
String toBengaliDigits(dynamic number) {
  const List<String> englishDigits = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
  ];
  const List<String> bengaliDigits = [
    '০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯',
  ];

  String result = number.toString();
  for (int i = 0; i < englishDigits.length; i++) {
    result = result.replaceAll(englishDigits[i], bengaliDigits[i]);
  }
  return result;
}
