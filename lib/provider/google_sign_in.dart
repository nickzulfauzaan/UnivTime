import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as developer;

class GoogleSignInProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> googleLogin(BuildContext context) async {
    try {
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();

      if (googleUser.email.endsWith("@siswa.um.edu.my")) {
        final GoogleSignInAuthentication googleAuth =
            googleUser.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);

        _user = googleUser;
        notifyListeners();
      } else {
        await GoogleSignIn.instance.disconnect();
        if (context.mounted) {
          showSnackBar(context, "Invalid email domain. Please use your siswamail.");
        }
      }
    } catch (e) {
      developer.log("Error signing in with Google: $e",
          name: 'GoogleSignIn');
      if (context.mounted) {
        showSnackBar(context, "Error signing in with Google. Please try again.");
      }
    }
  }

  Future<void> logout() async {
    await GoogleSignIn.instance.disconnect();
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
