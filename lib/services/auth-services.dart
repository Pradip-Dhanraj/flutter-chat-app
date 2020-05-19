import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum BaseAuthStatus {
  SignOut,
  Google,
  EmailAndPassword,
}

String dbTokenid;

BaseAuthStatus authTypeStatus;

abstract class BaseAuth {
  Future<FirebaseUser> signInWithGoogle();

  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
GoogleSignIn googleSignIn;

class Auth implements BaseAuth {
  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result?.user;
    var tokenresult = await user.getIdToken();
    dbTokenid = tokenresult.token;
    if (user != null) authTypeStatus = BaseAuthStatus.EmailAndPassword;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    if (googleSignIn != null && await googleSignIn.isSignedIn())
      signOutGoogle();
    authTypeStatus = BaseAuthStatus.SignOut;
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);
    print('signInWithGoogle succeeded: ${user.displayName}');
    if (user != null) authTypeStatus = BaseAuthStatus.Google;
    return currentUser;
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
    print("User Sign Out");
  }
}
