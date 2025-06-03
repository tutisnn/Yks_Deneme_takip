// GirisServisi: Firebase Authentication ve giriş-çıkış işlemlerini yönetir
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer';

class GirisServisi {
  // Firestore'daki 'kullanicilar' koleksiyonunu temsil eder
  final kullaniciCollection = FirebaseFirestore.instance.collection("kullanicilar");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // E-posta ve şifre ile yeni kullanıcı kaydı oluşturur
  Future<void> epostaIleKayit({
    required String email,
    required String sifre,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: sifre,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Kayıt başarısız";
    }
  }

  // E-posta ve şifre ile giriş yapılmasını sağlar
  Future<void> epostaIleGiris({
    required String email,
    required String sifre,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: sifre,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw Exception('E-posta adresi geçersiz biçimde girildi.');
      } else if (e.code == 'invalid-credential') {
        throw Exception('E-posta veya şifre hatalı.');
      } else {
        throw e;
      }
    }
  }

  // Google ile giriş yapılmasını sağlar
  Future<User?> googleIleGiris() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    // Kullanıcı daha önce eklenmemişse, Firestore'a kaydedilir
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('kullanicilar').doc(user.uid).get();

      if (!doc.exists) {
        await FirebaseFirestore.instance.collection('kullanicilar').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email ?? '',
        });
      }
    }

    log(user?.email.toString() ?? 'Email yok');
    return user;
  }

  // GitHub ile giriş yapılmasını sağlar
  Future<User?> signInWithGitHub() async {
    try {
      final GithubAuthProvider githubProvider = GithubAuthProvider();
      final UserCredential userCredential = await _auth.signInWithPopup(githubProvider);

      final User? user = userCredential.user;

      // Kullanıcı daha önce eklenmemişse, Firestore'a kaydedilir
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('kullanicilar').doc(user.uid).get();

        if (!doc.exists) {
          await FirebaseFirestore.instance.collection('kullanicilar').doc(user.uid).set({
            'uid': user.uid,
            'email': user.email ?? '',
          });
        }
      }

      print("Giriş başarılı: ${user?.uid}");
      return user;
    } catch (e, stackTrace) {
      print('GitHub sign-in failed: $e');
      print('StackTrace: $stackTrace');
      return null;
    }
  }

  // Kullanıcıyı sistemden çıkış yaptırır (Google ve Firebase)
  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
    } catch (e) {
      log("Google sign out error: $e");
    }

    await _auth.signOut();
  }
}
