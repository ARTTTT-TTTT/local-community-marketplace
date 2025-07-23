import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  static Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      print('🔥 FirebaseAuthService: Creating user with email: $email');
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      print(
        '✅ FirebaseAuthService: User created with UID: ${userCredential.user?.uid}',
      );

      // Send email verification
      print('📧 FirebaseAuthService: Sending email verification...');
      await userCredential.user?.sendEmailVerification();
      print('📧 FirebaseAuthService: Email verification sent');

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuthService: Auth error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ FirebaseAuthService: Unknown error: $e');
      throw 'เกิดข้อผิดพลาดที่ไม่คาดคิด: ${e.toString()}';
    }
  }

  // Sign in with email and password
  static Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'เกิดข้อผิดพลาดที่ไม่คาดคิด: ${e.toString()}';
    }
  }

  // Check if email exists by attempting to create account with temporary password
  // This is the recommended approach after fetchSignInMethodsForEmail deprecation
  static Future<bool> checkEmailExists(String email) async {
    try {
      // Try to create account with a temporary password
      // If email exists, this will throw 'email-already-in-use' error
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password:
            'temporary_password_123!@#', // This won't be used if email exists
      );

      // If we reach here, email doesn't exist and account was created
      // Delete the temporary account immediately
      await _auth.currentUser?.delete();
      return false; // Email doesn't exist
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return true; // Email exists
      } else if (e.code == 'invalid-email') {
        throw 'รูปแบบอีเมลไม่ถูกต้อง';
      } else if (e.code == 'weak-password') {
        // This shouldn't happen with our temp password, but just in case
        return false;
      }
      throw _handleAuthException(e);
    } catch (e) {
      throw 'เกิดข้อผิดพลาดที่ไม่คาดคิด: ${e.toString()}';
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'ไม่สามารถออกจากระบบได้: ${e.toString()}';
    }
  }

  // Send password reset email
  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'ไม่สามารถส่งอีเมลรีเซ็ตรหัสผ่านได้: ${e.toString()}';
    }
  }

  // Resend email verification
  static Future<void> resendEmailVerification() async {
    try {
      await currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'ไม่สามารถส่งอีเมลยืนยันได้: ${e.toString()}';
    }
  }

  // Delete user account
  static Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'ไม่สามารถลบบัญชีได้: ${e.toString()}';
    }
  }

  // Handle Firebase Auth exceptions
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'รหัสผ่านไม่ปลอดภัย กรุณาใช้รหัสผ่านที่แข็งแกร่งกว่านี้';
      case 'email-already-in-use':
        return 'อีเมลนี้ถูกใช้งานแล้ว กรุณาใช้อีเมลอื่น';
      case 'invalid-email':
        return 'รูปแบบอีเมลไม่ถูกต้อง';
      case 'operation-not-allowed':
        return 'การดำเนินการนี้ไม่ได้รับอนุญาต';
      case 'user-disabled':
        return 'บัญชีผู้ใช้นี้ถูกปิดใช้งาน';
      case 'user-not-found':
        return 'ไม่พบบัญชีผู้ใช้นี้';
      case 'wrong-password':
        return 'รหัสผ่านไม่ถูกต้อง';
      case 'invalid-credential':
        return 'ข้อมูลการเข้าสู่ระบบไม่ถูกต้อง';
      case 'too-many-requests':
        return 'มีการพยายามเข้าสู่ระบบมากเกินไป กรุณาลองใหม่อีกครั้งในภายหลัง';
      case 'network-request-failed':
        return 'ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ';
      case 'requires-recent-login':
        return 'กรุณาเข้าสู่ระบบใหม่เพื่อดำเนินการต่อ';
      default:
        return 'เกิดข้อผิดพลาด: ${e.message ?? e.code}';
    }
  }
}
