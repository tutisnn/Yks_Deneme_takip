import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';


class GirisServisi {
  final kullaniciCollection = FirebaseFirestore.instance.collection("kullanicilar");
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
  Future<User?> googleIleGiris() async {

    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(accessToken: gAuth.accessToken, idToken: gAuth.idToken);


    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    log(userCredential.user!.email.toString());
    return userCredential.user;

  }
  final githubProvider = GithubAuthProvider();

  Future<void> signInWithGitHub() async {
    final clientId = 'Ov23lihlSQEBkPiEoOKH';
    final redirectUri = 'https://yks-deneme-takip.firebaseapp.com/__/auth/handler';

    final url =
        'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=read:user%20user:email';

    final result = await FlutterWebAuth2.authenticate(
      url: url,
      callbackUrlScheme: "https",
    );

    final code = Uri.parse(result).queryParameters['code'];

    final response = await http.post(
      Uri.parse("https://github.com/login/oauth/access_token"),
      headers: {"Accept": "application/json"},
      body: {
        "client_id": clientId,
        "client_secret": "9475dc4b4471da6c6598eec1796cdafd924a67d8",
        "code": code!,
        "redirect_uri": redirectUri,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("GitHub access token request failed with status: ${response.statusCode}");
    }

    final accessToken = json.decode(response.body)["access_token"];
    if (accessToken == null) {
      throw Exception("Failed to obtain GitHub access token.");
    }

    final githubAuthCredential = GithubAuthProvider.credential(accessToken);
    final userCredential = await _auth.signInWithCredential(githubAuthCredential);

    if (userCredential.user == null) {
      throw Exception("GitHub sign-in failed in Firebase.");
    }
  }



  Future<void> signOut() async {
    await _auth.signOut();
  }


}
