import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.black), // Set text color to black
      ),
      backgroundColor: Colors.white, // Set the background color to white
      behavior: SnackBarBehavior.floating, // Optional: Use floating behavior
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future googleLogin(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        await _googleSignIn
            .signOut(); // Explicitly sign out to allow user to choose an account again
        showSnackBar(context, "Sign-in process canceled.");
        return;
      }

      // // Check if the email domain is valid
      // if (!googleUser.email!.endsWith("@siswa.um.edu.my")) {
      //   // Show an error message or handle the case where the email is not allowed
      //   await _googleSignIn
      //       .signOut(); // Explicitly sign out to allow user to choose an account again
      //   showSnackBar(
      //       context, "Invalid email domain. Please use your siswamail.");
      //   return;
      // }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      _user = googleUser;

      notifyListeners();
    } catch (e) {
      print("Error signing in with Google: $e");
      showSnackBar(context, "Error signing in with Google. Please try again.");
    }
  }

  Future logout() async {
    await _googleSignIn.disconnect();
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
