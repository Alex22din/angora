import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;
  AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<String?> ensureAdminAccount() async {
    try {
      final currentEmail = 'angora@gmail.com';
      final currentPassword = 'islam2214++33';

      try {
        await _auth.signInWithEmailAndPassword(
          email: currentEmail,
          password: currentPassword,
        );
        await _auth.signOut();
        return null;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
          try {
            await _auth.createUserWithEmailAndPassword(
              email: currentEmail,
              password: currentPassword,
            );
            await _auth.signOut();
            return null;
          } catch (createError) {
            return createError.toString();
          }
        }
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }
}
