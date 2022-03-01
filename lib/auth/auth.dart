import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jazia/screens/signin.dart';
import 'package:jazia/trydart/landpage.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
handleAuth(){
  return StreamBuilder(
    stream: _auth.authStateChanges(),
      builder: (context, snapshot){
      if(snapshot.hasData){
        return LandExisting();
      } else {
        return SignInScreen();
      }
      }
  );
}
signOut(){
  _auth.signOut();
}
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}