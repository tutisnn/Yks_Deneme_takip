import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/User.dart';

class FirebaseService {
  static Future<void> saveUser(UserModel user) async {
    await FirebaseFirestore.instance.collection('kullanicilar').doc(user.uid).set(user.toJson());
  }

  static Future<UserModel?> getUser(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('kullanicilar').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }
}
