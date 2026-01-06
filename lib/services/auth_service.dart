import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fungsi Register: Membuat akun & menyimpan data tambahan ke Firestore
  Future<String?> registerUser({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // 1. Buat user di Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Jika berhasil, simpan username ke Firestore menggunakan UID
      if (result.user != null) {
        await _db.collection('users').doc(result.user!.uid).set({
          'uid': result.user!.uid,
          'username': username,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message; // Mengembalikan pesan error dari Firebase
    }
  }

  // Fungsi Login
  Future<String?> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
