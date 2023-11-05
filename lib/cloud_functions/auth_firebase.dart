import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFirebase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signupWithEmail(String email, String password) async {
    UserCredential authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = authResult.user;
    return user;
  }

  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = authResult.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> loginWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    UserCredential authResult = await _firebaseAuth.signInWithCredential(credential);
    User? user = authResult.user;

    return user;
  }

  Future<User?> getCurrentUser() async {
    User? user = await _firebaseAuth.currentUser;
    return user;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
