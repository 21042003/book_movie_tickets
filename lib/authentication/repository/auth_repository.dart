import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._auth, this._firestore);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // Kiểm tra tên hiển thị có trùng lặp không
  Future<bool> isFullNameTaken(String fullName) async {
    final result = await _firestore
        .collection('users')
        .where('fullName', isEqualTo: fullName)
        .get();
    return result.docs.isNotEmpty;
  }

  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential> signUp(String email, String password, String fullName) async {
    try {
      // 1. Kiểm tra tên trùng lặp trước khi tạo tài khoản
      if (await isFullNameTaken(fullName)) {
        throw 'Tên này đã được sử dụng. Vui lòng chọn tên khác.';
      }

      // 2. Tạo tài khoản trên Firebase Auth (Firebase tự kiểm tra email trùng)
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // 3. Cập nhật thông tin profile
      await credential.user?.updateDisplayName(fullName);

      // 4. Lưu thông tin vào Firestore để quản lý và kiểm tra trùng lặp sau này
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email,
        'fullName': fullName,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      if (e is String) throw e;
      throw 'Không thể kết nối với máy chủ Firebase. Hãy kiểm tra cấu hình hoặc internet.';
    }
  }

  Future<void> recoverPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Email không tồn tại trong hệ thống';
      case 'wrong-password':
        return 'Mật khẩu không chính xác';
      case 'email-already-in-use':
        return 'Email này đã được sử dụng bởi tài khoản khác';
      case 'invalid-email':
        return 'Định dạng Email không hợp lệ';
      case 'weak-password':
        return 'Mật khẩu quá yếu';
      case 'network-request-failed':
        return 'Lỗi kết nối mạng';
      default:
        return e.message ?? 'Đã có lỗi xảy ra, vui lòng thử lại';
    }
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository(
  FirebaseAuth.instance, 
  FirebaseFirestore.instance
));

final authStateProvider = StreamProvider((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
