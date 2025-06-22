import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CreditorController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> creditorList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> singleDipositList = <Map<String, dynamic>>[].obs;
  RxInt totalAmount = 0.obs;

  @override
  void onInit() {
    fetchCreditors();
    super.onInit();
  }

  // Create
  Future<void> addCreditor(Map<String, dynamic> data) async {
  await firestore.collection('creditors').add(data);
  await fetchCreditors();
}

  // Read (This is a Common Function for CRUD operation)
  Future<void> fetchCreditors() async {
    final snapshot = await firestore.collection('creditors').get();

    creditorList.value = snapshot.docs.map((doc) => {...doc.data(), 'id' : doc.id}).toList();

    // Calculate all total
    int sum = 0; // This is for "Double Value : double sum = 0.0;"

    for (var doc in snapshot.docs) {
      final total = doc.data()['total'];

      if (total != null && total is num) {
        sum += total.toInt(); // This is for "Double Value : sum += total.toDouble();"
      }
    }

    totalAmount.value = sum;
  }

  // Update
  Future<void> updateCreditor(String id, Map<String, dynamic> data) async {
    await firestore.collection('creditors').doc(id).update(data);

    fetchCreditors();
  }

  // Delete
  Future<void> deleteCreditor(String id) async {
    final historyCollection = firestore
      .collection('creditors')
      .doc(id)
      .collection('creditors_history');

    final historyDocs = await historyCollection.get();
    for (final doc in historyDocs.docs) {
      await doc.reference.delete();
    }

    await firestore.collection('creditors').doc(id).delete();
    await fetchCreditors();
  }
  
  // Create Diposit History a new collection
  Future<void> saveDipositHistory(String creditorId, Map<String, dynamic> data) async {
    await firestore.collection('creditors')
      .doc(creditorId)
      .collection('creditors_history')
      .add(data);
  }

  // Read Diposit History
  Future<void> fetchDipositHistoryForCreditor(String creditorId) async {
    final snapshot = await firestore
      .collection('creditors')
      .doc(creditorId)
      .collection('creditors_history')
      .get();

    singleDipositList.value = snapshot.docs.map((doc) => {
      ...doc.data(),
      'id': doc.id,
    }).toList();
  }
}