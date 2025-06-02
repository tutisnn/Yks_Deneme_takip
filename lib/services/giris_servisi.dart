import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:github_oauth/github_oauth.dart';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter/material.dart';



class GirisServisi {
  final kullaniciCollection = FirebaseFirestore.instance.collection(
      "kullanicilar");
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

    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);


    final UserCredential userCredential = await _auth.signInWithCredential(
        credential);
    log(userCredential.user!.email.toString());
    return userCredential.user;
  }

  Future<User?> signInWithGitHub() async {
    try {
      final GithubAuthProvider githubProvider = GithubAuthProvider();
      final UserCredential userCredential = await _auth.signInWithPopup(githubProvider);

      print("Giriş başarılı: ${userCredential.user?.uid}");
      return userCredential.user;
    } catch (e, stackTrace) {
      print('GitHub sign-in failed: $e');
      print('StackTrace: $stackTrace');
      return null;
    }
  }



}