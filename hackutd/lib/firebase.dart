import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

/// Handles Firebase Auth + Realtime Database
class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseDatabase _db = FirebaseDatabase.instance;

  /// Initialize Firebase
  static Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (kDebugMode) print('✅ Firebase initialized');
    } catch (e) {
      if (kDebugMode) print('❌ Firebase init error: $e');
    }
  }

  /// Register new user and save to Realtime DB
  static Future<User?> signUp(String email, String password) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCred.user;
      if (user != null) {
        await _db.ref("users/${user.uid}").set({
          "uid": user.uid,
          "email": email,
          "createdAt": DateTime.now().toIso8601String(),
        });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint("⚠️ Sign-Up Error: ${e.code} – ${e.message}");
      rethrow;
    }
  }

  /// Log in existing user and fetch details from DB
  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCred.user;
      if (user != null) {
        final snapshot = await _db.ref("users/${user.uid}").get();
        if (snapshot.exists) {
          return Map<String, dynamic>.from(snapshot.value as Map);
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint("⚠️ Login Error: ${e.code} – ${e.message}");
      rethrow;
    }
  }

  static Future<void> logout() async => _auth.signOut();

  static User? get currentUser => _auth.currentUser;
}
