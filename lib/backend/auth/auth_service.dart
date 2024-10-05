import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<UserCredential> signInWithEmail(String email, password) async {
    try{
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithEmail(String email, password, displayName) async {
    try{
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await user.user?.updateDisplayName(displayName);
      return user;
    } on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }

  Future<User?> signUpWithGoogle() async {
    final googleAccount = await GoogleSignIn().signIn();
    final googleAuth = await googleAccount?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<void> sendResetPass(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> resetPass(String newPassword) async {
    return _firebaseAuth.currentUser!.updatePassword(newPassword);
  }

}