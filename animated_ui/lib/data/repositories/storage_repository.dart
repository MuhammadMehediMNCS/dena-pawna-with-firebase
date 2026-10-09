import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

/// পাওনাদার/দেনাদারের প্রোফাইল ছবি ফায়ারবেজ স্টোরেজে আপলোড ও ডিলিট করার
/// সম্পূর্ণ দায়িত্ব এই রিপোজিটরির — প্রোভাইডার বা UI লেয়ার সরাসরি
/// FirebaseStorage নিয়ে কাজ করবে না (ক্লিন আর্কিটেকচার আলাদাকরণ)।
class StorageRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// [folder] উদাহরণ: 'creditors' অথবা 'debtors'
  /// [id] হলো সংশ্লিষ্ট ডকুমেন্টের আইডি, যাতে ফাইলের নাম অনন্য (unique) থাকে।
  Future<String> uploadImage({
    required File file,
    required String folder,
    required String id,
  }) async {
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final Reference ref = _storage.ref().child('$folder/$id/$fileName');

    final UploadTask uploadTask = ref.putFile(file);
    final TaskSnapshot snapshot = await uploadTask;

    return snapshot.ref.getDownloadURL();
  }

  /// পুরনো ছবি ডিলিট করে — এটি ব্যর্থ হলেও (যেমন ছবি আগে থেকেই না থাকলে)
  /// পুরো অপারেশন থামানো উচিত নয়, তাই এরর সাইলেন্টলি হ্যান্ডেল করা হয়েছে।
  Future<void> deleteImage(String? imageUrl) async {
    if (imageUrl == null || imageUrl.isEmpty) return;

    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (_) {
      // ছবি না থাকলে বা ডিলিট ব্যর্থ হলে সাইলেন্টলি ইগনোর করা হচ্ছে।
    }
  }
}
