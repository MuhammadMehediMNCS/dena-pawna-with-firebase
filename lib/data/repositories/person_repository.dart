import 'package:cloud_firestore/cloud_firestore.dart';

/// পাওনাদার (creditors) ও দেনাদার (debtors) — দুটি কালেকশনের গঠন হুবহু এক,
/// তাই একটিমাত্র জেনেরিক রিপোজিটরি দিয়ে দুটোই সার্ভ করা হচ্ছে।
/// [collectionName] দিয়ে বলে দেওয়া হয় এটি কোন প্যারেন্ট কালেকশনের সাথে
/// কাজ করবে ('creditors' অথবা 'debtors')।
///
/// প্রতিটি পাওনাদার/দেনাদার ডকুমেন্টের আন্ডারে সবসময় দুটি ফিক্সড
/// সাব-কালেকশন থাকে:
/// - `receive_history` — যতবার গ্রহণ করা হয়েছে তার প্রতিটি এন্ট্রি
/// - `diposit_history` — যতবার জমা করা হয়েছে তার প্রতিটি এন্ট্রি
class PersonRepository {
  PersonRepository({required this.collectionName});

  final String collectionName;

  static const String receiveHistoryCollection = 'receive_history';
  static const String depositHistoryCollection = 'diposit_history';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(collectionName);

  /// নতুন পাওনাদার/দেনাদার যোগ করে এবং তৈরি হওয়া ডকুমেন্টের আইডি রিটার্ন করে
  /// (ছবি আপলোডের সময় এই আইডি ফাইলের পাথ হিসেবে ব্যবহার করা হয়)।
  Future<String> addPerson(Map<String, dynamic> data) async {
    final doc = await _collection.add(data);
    return doc.id;
  }

  Future<List<Map<String, dynamic>>> fetchPersons() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  Future<void> updatePerson(String id, Map<String, dynamic> data) async {
    await _collection.doc(id).update(data);
  }

  Future<void> deletePerson(String id) async {
    await _deleteSubCollection(id, receiveHistoryCollection);
    await _deleteSubCollection(id, depositHistoryCollection);
    await _collection.doc(id).delete();
  }

  Future<void> _deleteSubCollection(String id, String subCollectionName) async {
    final docs = await _collection.doc(id).collection(subCollectionName).get();
    for (final doc in docs.docs) {
      await doc.reference.delete();
    }
  }

  /// এডিট ফর্মে 'গ্রহণের পরিমাণ' ফিল্ডে তথ্য দিলে সংশ্লিষ্ট ডকুমেন্টের
  /// আন্ডারে `receive_history` সাব-কালেকশনে একটি নতুন এন্ট্রি যোগ হয়।
  Future<void> addReceiveHistory(String personId, Map<String, dynamic> data) async {
    await _collection
        .doc(personId)
        .collection(receiveHistoryCollection)
        .add({...data, 'createdAt': FieldValue.serverTimestamp()});
  }

  Future<List<Map<String, dynamic>>> fetchReceiveHistory(String personId) async {
    final snapshot = await _collection
        .doc(personId)
        .collection(receiveHistoryCollection)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  /// এডিট ফর্মে 'জমার পরিমাণ' ফিল্ডে তথ্য দিলে সংশ্লিষ্ট ডকুমেন্টের আন্ডারে
  /// `diposit_history` সাব-কালেকশনে একটি নতুন এন্ট্রি যোগ হয়।
  Future<void> addDepositHistory(String personId, Map<String, dynamic> data) async {
    await _collection
        .doc(personId)
        .collection(depositHistoryCollection)
        .add({...data, 'createdAt': FieldValue.serverTimestamp()});
  }

  Future<List<Map<String, dynamic>>> fetchDepositHistory(String personId) async {
    final snapshot = await _collection
        .doc(personId)
        .collection(depositHistoryCollection)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }
}
