import 'dart:io';

import 'package:get/get.dart';

/// পাওনাদার ও দেনাদার — দুই ধরনের ডেটার উপর করা কাজ একদম একই রকম, তাই
/// একটি কমন ইন্টারফেস (abstract class) দিয়ে বাঁধা হয়েছে। এর ফলে
/// [PersonFormScreen], [PersonHistoryPage], [PersonListTile]-এর মতো
/// শেয়ার্ড উইজেট/স্ক্রিনগুলো কনক্রিট কন্ট্রোলার (Creditor/Debtor) না জেনেই
/// শুধু এই ইন্টারফেসের উপর নির্ভর করে কাজ করতে পারে।
abstract class PersonController extends GetxController {
  /// পাওনাদার/দেনাদারের সম্পূর্ণ তালিকা
  RxList<Map<String, dynamic>> get personList;

  /// ডাটা এখনো ফায়ারবেজ থেকে আসছে কিনা।
  ///
  /// আগে শুধু `personList.isEmpty` দেখে শিমার দেখানো হতো — কিন্তু তালিকা
  /// সত্যিকারেই ফাঁকা হলে (ডাটাবেজে কিছু না থাকলে) সেটিও 'isEmpty' হয়,
  /// ফলে শিমার আর কখনো থামত না। এই ফ্ল্যাগটি দিয়ে 'লোড হচ্ছে' আর
  /// 'লোড শেষ, কিন্তু কিছুই নেই' — এই দুই অবস্থা আলাদা করা যায়।
  RxBool get isLoading;

  /// সর্বশেষ যা fetch করা হয়েছে (গ্রহণের ইতিহাস অথবা জমার ইতিহাস) তা এখানে
  /// থাকে — [fetchReceiveHistoryForPerson] অথবা [fetchDepositHistoryForPerson]
  /// যেটি কল করা হবে তার ফলাফল এখানে বসবে।
  RxList<Map<String, dynamic>> get historyList;

  /// সংশ্লিষ্ট তালিকার সর্বমোট টাকা
  RxInt get totalAmount;

  Future<void> fetchPersons();

  Future<void> addPerson(Map<String, dynamic> data, {File? imageFile});

  Future<void> updatePerson(
    String id,
    Map<String, dynamic> data, {
    File? imageFile,
  });

  Future<void> deletePerson(String id);

  /// লিস্টভিউয়ের ছবিতে সরাসরি ট্যাপ করে ছবি যোগ/পরিবর্তনের জন্য —
  /// ফর্ম ওপেন না করেই কাজ করে।
  Future<void> updatePersonImage(String id, File imageFile);

  /// গ্রহণের তথ্য সংশ্লিষ্ট ডকুমেন্টের আন্ডারে `receive_history`
  /// সাব-কালেকশনে সংরক্ষণ করে।
  Future<void> saveReceiveHistory(String personId, Map<String, dynamic> data);

  /// জমার তথ্য সংশ্লিষ্ট ডকুমেন্টের আন্ডারে `diposit_history`
  /// সাব-কালেকশনে সংরক্ষণ করে।
  Future<void> saveDepositHistory(String personId, Map<String, dynamic> data);

  /// `receive_history` সাব-কালেকশন থেকে সব এন্ট্রি এনে [historyList]-এ বসায়।
  Future<void> fetchReceiveHistoryForPerson(String personId);

  /// `diposit_history` সাব-কালেকশন থেকে সব এন্ট্রি এনে [historyList]-এ বসায়।
  Future<void> fetchDepositHistoryForPerson(String personId);
}
