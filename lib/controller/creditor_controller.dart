import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';

class CreditorController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> creditorList = <Map<String, dynamic>>[].obs;
  RxInt totalAmount = 0.obs;

  @override
  void onInit() {
    fetchCreditors();
    super.onInit();
  }

  // Create
  Future<void> addCreditor(Map<String, dynamic> data) async {
    await firestore.collection('creditors').add(data);

    fetchCreditors();
  }

  // Read (This is a Common Function for Create Data, Show data, Upadate Data and Delete Data)
  Future<void> fetchCreditors() async {
    final snapshot = await firestore.collection('creditors').get();

    creditorList.value = snapshot.docs.map((doc) => {...doc.data(), 'id' : doc.id}).toList();

    // Calculate all total
    int sum = 0; // This is for Double Value : double sum = 0.0;

    for (var doc in snapshot.docs) {
      final total = doc.data()['total'];

      if (total != null && total is num) {
        sum += total.toInt(); // This is for Double Value : sum += total.toDouble();
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
    await firestore.collection('creditors').doc(id).delete();

    fetchCreditors();
  }
}