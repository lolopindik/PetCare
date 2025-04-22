import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';

class GoogleAuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
    
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final DatabaseReference dbRef = FirebaseDatabase.instance.ref('userDetails/${user.uid}');
        await dbRef.set({
          "name": user.displayName ?? "Unknown",
          "email": user.email,
          "verify": true,
        });

        DebugLogger.print('\x1B[32mGoogle Sign-In successful: ${user.displayName}');
      }

      return user;
    } catch (e) {
      DebugLogger.print('\x1B[31mError during Google Sign-In: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      DebugLogger.print('\x1B[32mUser signed out successfully');
    } catch (e) {
      DebugLogger.print('\x1B[31mError during sign out: $e');
    }
  }
}