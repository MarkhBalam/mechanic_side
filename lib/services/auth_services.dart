import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google sign in
  Future<UserCredential?> signInWithGoogle() async {
    // Begin interactive sign in process
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? gUser = await googleSignIn.signIn();

    // Obtain auth details from the request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // Create a new credential for the user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Finally lets sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
