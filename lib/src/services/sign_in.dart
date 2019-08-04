import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken
  );

  final FirebaseUser user = await _auth.signInWithCredential(credential) as FirebaseUser;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currenUser = await _auth.currentUser();
  assert(user.uid == currenUser.uid);

  return 'signInWithGoogle succeded: $user';
}

Future<String> signInWithTestMethod() async {

  FirebaseUser user = await Future.delayed(Duration(seconds: 2));
  user.updateEmail('test@testmail.de');
  user.updatePassword('test');
  user.isEmailVerified;
   
  return 'signInWithGoogle succeded: $user';
}

void signOutGoogle() async{
  await googleSignIn.signOut();
  print('User sign out');
}