import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DebtorController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList <Map<String, dynamic>> debtorList = <Map<String, dynamic>>[].obs;
  RxInt totalAmount = 0.obs;

  @override
  void onInit() {
    fetchDebtors();

    super.onInit();
  }

  // Create
  Future<void> addDebtor(Map<String, dynamic> data) async {
    await firestore.collection('debtors').add(data);

    fetchDebtors();
  }

  // Read (This is a Common Function for CRUD operation)
  Future<void> fetchDebtors() async {
    final snapshot = await firestore.collection('debtors').get();

    debtorList.value = snapshot.docs.map((doc) => {...doc.data(), 'id' : doc.id}).toList();

    // Calculate all total
    int sum = 0;
    for(var doc in snapshot.docs) {
      final total = doc.data()['total'];

      if (total != null && total is num) {
        sum += total.toInt();
      }
    }

    totalAmount.value += sum;
  }

  // Update
  Future<void> updateDebtor(String id, Map<String, dynamic> data) async {
    await firestore.collection('debtors').doc(id).update(data);

    fetchDebtors();
  }

  // Delete
  Future<void> deleteDebtor(String id) async {
    final historyCollection = firestore
      .collection('debtors')
      .doc(id)
      .collection('debtors_history');

    final historyDocs = await historyCollection.get();
    for (var doc in historyDocs.docs) {
      await doc.reference.delete();
    }

    await firestore.collection('debtors').doc(id).delete();
    await fetchDebtors();
  }
}