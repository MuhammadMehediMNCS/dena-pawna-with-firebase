import 'dart:io';

import 'package:animated_ui/data/repositories/person_repository.dart';
import 'package:animated_ui/data/repositories/storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// GetX-এর RxList/RxInt/RxBool-গুলোর জায়গায় এখন একটিমাত্র ইমিউটেবল
/// স্টেট ক্লাস — [isLoading] সবসময় `personList.isEmpty`-র থেকে আলাদাভাবে
/// ট্র্যাক করা হয়, যাতে "তথ্য লোড হচ্ছে" আর "তথ্য আসলেই নেই" এই দুই
/// অবস্থা গুলিয়ে না যায় (এটি আগে একটি বাগের কারণ ছিল — শিমার কখনো
/// থামত না যখন তালিকা সত্যিই খালি থাকত)।
class PersonState {
  const PersonState({
    this.personList = const [],
    this.historyList = const [],
    this.totalAmount = 0,
    this.isLoading = true,
    this.isHistoryLoading = false,
  });

  final List<Map<String, dynamic>> personList;
  final List<Map<String, dynamic>> historyList;
  final int totalAmount;
  final bool isLoading;
  final bool isHistoryLoading;

  PersonState copyWith({
    List<Map<String, dynamic>>? personList,
    List<Map<String, dynamic>>? historyList,
    int? totalAmount,
    bool? isLoading,
    bool? isHistoryLoading,
  }) {
    return PersonState(
      personList: personList ?? this.personList,
      historyList: historyList ?? this.historyList,
      totalAmount: totalAmount ?? this.totalAmount,
      isLoading: isLoading ?? this.isLoading,
      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
    );
  }
}

/// পাওনাদার ও দেনাদার — দুইটির লজিক হুবহু এক, শুধু কালেকশনের নাম আলাদা।
/// আগে GetX-এ এর জন্য দুটো আলাদা সাবক্লাস (CreditorController/
/// DebtorController) দরকার হতো; Riverpod-এ একটি জেনেরিক নোটিফায়ার
/// কনস্ট্রাক্টর-প্যারামিটার দিয়ে প্যারামিটারাইজ করাই যথেষ্ট।
class PersonNotifier extends StateNotifier<PersonState> {
  PersonNotifier({required String collectionName, required String imageFolder})
      : _repository = PersonRepository(collectionName: collectionName),
        _imageFolder = imageFolder,
        super(const PersonState()) {
    fetchPersons();
  }

  final PersonRepository _repository;
  final String _imageFolder;
  final StorageRepository _storageRepository = StorageRepository();

  Future<void> fetchPersons() async {
    state = state.copyWith(isLoading: true);
    try {
      final list = await _repository.fetchPersons();

      int sum = 0;
      for (final item in list) {
        final total = item['total'];
        if (total != null && total is num) {
          sum += total.toInt();
        }
      }

      state = state.copyWith(personList: list, totalAmount: sum, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

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

  Future<void> deletePerson(String id) async {
    await _repository.deletePerson(id);
    await fetchPersons();
  }

  Future<void> updatePersonImage(String id, File imageFile) async {
    final String url = await _storageRepository.uploadImage(
      file: imageFile,
      folder: _imageFolder,
      id: id,
    );
    await _repository.updatePerson(id, {'image': url});
    await fetchPersons();
  }

  Future<void> saveReceiveHistory(String personId, Map<String, dynamic> data) async {
    await _repository.addReceiveHistory(personId, data);
  }

  Future<void> saveDepositHistory(String personId, Map<String, dynamic> data) async {
    await _repository.addDepositHistory(personId, data);
  }

  Future<void> fetchReceiveHistoryForPerson(String personId) async {
    state = state.copyWith(isHistoryLoading: true);
    final history = await _repository.fetchReceiveHistory(personId);
    state = state.copyWith(historyList: history, isHistoryLoading: false);
  }

  Future<void> fetchDepositHistoryForPerson(String personId) async {
    state = state.copyWith(isHistoryLoading: true);
    final history = await _repository.fetchDepositHistory(personId);
    state = state.copyWith(historyList: history, isHistoryLoading: false);
  }
}

typedef PersonProvider = StateNotifierProvider<PersonNotifier, PersonState>;

final PersonProvider creditorProvider = StateNotifierProvider<PersonNotifier, PersonState>(
  (ref) => PersonNotifier(collectionName: 'creditors', imageFolder: 'creditors'),
);

final PersonProvider debtorProvider = StateNotifierProvider<PersonNotifier, PersonState>(
  (ref) => PersonNotifier(collectionName: 'debtors', imageFolder: 'debtors'),
);
