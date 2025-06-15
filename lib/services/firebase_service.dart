// FirebaseService: Firebase Firestore üzerinde kullanıcı verilerini kaydetmek ve almak için servis
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/User.dart';

class FirebaseService {
  // Kullanıcıyı Firestore'a kaydeder (UID ile)
  static Future<void> saveUser(UserModel user) async {
    await FirebaseFirestore.instance
        .collection('kullanicilar')
        .doc(user.uid)
        .set(user.toJson());
  }

  // UID'ye göre Firestore'dan kullanıcıyı getirir
  static Future<UserModel?> getUser(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('kullanicilar')
        .doc(uid)
        .get();

    // Belge varsa UserModel nesnesine çevirip döndürür
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null; // Kullanıcı bulunamazsa null döndürür
  }
}
