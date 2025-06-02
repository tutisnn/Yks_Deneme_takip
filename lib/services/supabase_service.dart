import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/User.dart';

class SupabaseService {
  static Future<void> saveUser(UserModel user) async {
    await Supabase.instance.client.from('kullanicilar').upsert(user.toJson());
  }


  static Future<void> saveExam({
  required String examName,
  required double toplamNet,
  required int toplamDogru,
  required int toplamYanlis,
  required String userId,
  }) async {
  await Supabase.instance.client.from('netler').insert({
  'user_id': userId,
  'sinav_adi': examName,
  'toplam_net': toplamNet,
  'toplam_dogru': toplamDogru,
  'toplam_yanlis': toplamYanlis,
  });
  }


}
