import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFirebase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signupWithEmail(String email, String password) async {
    UserCredential authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = authResult.user;
    return user?.uid;
  }

  Future<String?> loginWithEmail(String email, String password) async {
    try {
      UserCredential authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = authResult.user;
      return user?.uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> getCurrentUser() async {
    User? user = await _firebaseAuth.currentUser;
    return user;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<String?> googleLogin() async {
    //https://medium.flutterdevs.com/google-sign-in-with-flutter-8960580dec96
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

    GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    // UserCredential authResult = await _firebaseAuth.signInWithCredential(credential);

    // User? _user = authResult.user;

    // User? currentUser = await _firebaseAuth.currentUser;

    // print("User Name: ${_user!.displayName}");
    // print("User Email ${_user.email}");
    // return "User Name: ${_user!.displayName}";
    return "1";
  }
}
