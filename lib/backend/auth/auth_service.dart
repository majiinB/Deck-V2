import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// The AuthService class handles authentication-related functionalities
/// for the application, utilizing Firebase Authentication services.
class AuthService {
  // FirebaseAuth instance for managing authentication.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Gets the currently authenticated user.
  ///
  /// Returns the [User] object if a user is signed in, or null if not.
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  /// Signs in a user with email and password.
  ///
  /// Takes the [email] and [password] as parameters.
  ///
  /// Returns a [UserCredential] object if successful.
  ///
  /// Throws an exception if sign-in fails.
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      // Attempt to sign in the user with the provided email and password.
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      // Catch FirebaseAuth specific exceptions and rethrow them as a generic exception.
      throw Exception(e.code);
    }
  }

  /// Signs up a new user with email, password, and display name.
  ///
  /// Takes the [email], [password], and [displayName] as parameters.
  ///
  /// Returns a [UserCredential] object if successful.
  ///
  /// Throws an exception if sign-up fails.
  Future<UserCredential> signUpWithEmail(
      String email, String password, String displayName) async {
    try {
      // Create a new user with the provided email and password.
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Update the display name of the newly created user.
      await user.user?.updateDisplayName(displayName);
      return user;
    } on FirebaseAuthException catch (e) {
      // Catch FirebaseAuth specific exceptions and rethrow them as a generic exception.
      throw Exception(e.code);
    }
  }

  /// Signs in a user using Google Sign-In.
  ///
  /// Returns a [User] object if sign-in is successful, or null if not.
  Future<User?> signUpWithGoogle() async {
    // Initiates Google Sign-In process.
    final googleAccount = await GoogleSignIn().signIn();
    final googleAuth = await googleAccount?.authentication;

    // Creates credentials for the user based on Google Auth data.
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Signs in the user with the created credentials.
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  /// Signs out the currently authenticated user.
  Future<void> signOut() async {
    // Signs out the user from Firebase.
    return await _firebaseAuth.signOut();
  }

  /// Sends a password reset email to the specified email address.
  ///
  /// Takes the [email] as a parameter.
  Future<void> sendResetPass(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// Updates the current user's password with a new password.
  ///
  /// Takes the [newPassword] as a parameter.
  Future<void> resetPass(String newPassword) async {
    return _firebaseAuth.currentUser!.updatePassword(newPassword);
  }
}
