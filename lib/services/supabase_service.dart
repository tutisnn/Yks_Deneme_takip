import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/User.dart';

class SupabaseService {
  static Future<void> saveUser(UserModel user) async {
    await Supabase.instance.client.from('kullanicilar').upsert(user.toJson());
  }
}
