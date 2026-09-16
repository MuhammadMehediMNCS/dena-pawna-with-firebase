import 'dart:io';

import 'package:dena_pawna/controller/person_controller.dart';
import 'package:dena_pawna/data/repositories/person_repository.dart';
import 'package:dena_pawna/data/repositories/storage_repository.dart';
import 'package:get/get.dart';

class CreditorController extends PersonController {
  final PersonRepository _repository = PersonRepository(collectionName: 'creditors');
  final StorageRepository _storageRepository = StorageRepository();

  static const String _imageFolder = 'creditors';

  @override
  final RxList<Map<String, dynamic>> personList = <Map<String, dynamic>>[].obs;

  @override
  final RxList<Map<String, dynamic>> historyList = <Map<String, dynamic>>[].obs;

  @override
  final RxInt totalAmount = 0.obs;

  /// শুরুতে true — কারণ onInit()-এ সাথে সাথেই fetch শুরু হয়, তাই প্রথম
  /// ফ্রেমেই যেন শিমার দেখা যায়।
  @override
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    fetchPersons();
    super.onInit();
  }

  @override
  Future<void> fetchPersons() async {
    isLoading.value = true;

    try {
      final list = await _repository.fetchPersons();
      personList.value = list;

      int sum = 0;
      for (final item in list) {
        final total = item['total'];
        if (total != null && total is num) {
          sum += total.toInt();
        }
      }
      totalAmount.value = sum;
    } finally {
      // ফেচ সফল হোক বা এরর হোক — লোডিং অবস্থা অবশ্যই শেষ হবে, নাহলে
      // শিমার চিরকাল ঘুরতেই থাকবে।
      isLoading.value = false;
    }
  }

  @override
  Future<void> addPerson(Map<String, dynamic> data, {File? imageFile}) async {
    final String id = await _repository.addPerson(data);

    if (imageFile != null) {
      final String url = await _storageRepository.uploadImage(
        file: imageFile,
        folder: _imageFolder,
        id: id,
      );
      await _repository.updatePerson(id, {'image': url});
    }

    await fetchPersons();
  }

  @override
  Future<void> updatePerson(
    String id,
    Map<String, dynamic> data, {
    File? imageFile,
  }) async {
    if (imageFile != null) {
      final String url = await _storageRepository.uploadImage(
        file: imageFile,
        folder: _imageFolder,
        id: id,
      );
      data['image'] = url;
    }

    await _repository.updatePerson(id, data);
    await fetchPersons();
  }

  @override
  Future<void> deletePerson(String id) async {
    await _repository.deletePerson(id);
    await fetchPersons();
  }

  @override
  Future<void> updatePersonImage(String id, File imageFile) async {
    final String url = await _storageRepository.uploadImage(
      file: imageFile,
      folder: _imageFolder,
      id: id,
    );
    await _repository.updatePerson(id, {'image': url});
    await fetchPersons();
  }

  @override
  Future<void> saveReceiveHistory(String personId, Map<String, dynamic> data) async {
    await _repository.addReceiveHistory(personId, data);
  }

  @override
  Future<void> saveDepositHistory(String personId, Map<String, dynamic> data) async {
    await _repository.addDepositHistory(personId, data);
  }

  @override
  Future<void> fetchReceiveHistoryForPerson(String personId) async {
    historyList.value = await _repository.fetchReceiveHistory(personId);
  }

  @override
  Future<void> fetchDepositHistoryForPerson(String personId) async {
    historyList.value = await _repository.fetchDepositHistory(personId);
  }
}
