import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import '../repositories/auth_repository.dart';
// C;est ici qu'on va faire notre code brute
// pas de logique d'auth

class MyAuthProvider implements AuthRepository {
  // On instancie FIREBASE
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // ---------------------------- Auth by Google ----------------------------

  /// Pour s'assurer que tout est bien  charger
  /// et Ouvrir la page pour choisir son compte google
  Future<void> ensureInitialozed() async {
    await GoogleSignInPlatform.instance.init(const InitParameters());
  }

  Future<void> signInWithGoogle() async {
    try {
      // Ouvrir la page pour choisir son compte google
      await ensureInitialozed();

      // Authentification
      final AuthenticationResults result = await GoogleSignInPlatform.instance
          .authenticate(const AuthenticateParameters());
      // recuperer le jeton id du User
      final String? idToken = result.authenticationTokens.idToken;

      // au cas ou idToken ne marche pas
      if (idToken != null) {
        // connecter
        // Recuperer toutes les informations du user
        final OAuthCredential credential = GoogleAuthProvider.credential(
          idToken: idToken,
        );

        UserCredential userCredential = await _firebaseAuth
            .signInWithCredential(credential);
        final firebaseUser = userCredential.user;
        if (firebaseUser != null) {
          print(
            "Connecté avec Google: ${firebaseUser.displayName ?? firebaseUser.email}",
          );
        }
      } else {
        print("Erreur : Erreur lors de la recuperation du token google");
      }
    } on GoogleSignInException catch (e) {
      throw e;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  // Register (Creer un compte)
  Future<User?> signUp(String email, String password, String username) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = credential.user;

      // Creer un document utilisateur dans Firestore
      await _firebaseFirestore.collection("users").doc(user!.uid).set({
        "username": username,
        "email": email,
      });
      return user;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  // Signin (Se connecter )
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  /// Lors de l'inscription on envoie un email de
  /// confirmation a l'utilisateur
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Singout (Se deconnecter)
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  /// Vérifie si l'utilisateur est connecté
  Stream<bool> get isSignedIn =>
      _firebaseAuth.authStateChanges().map((user) => user != null);

  // Obtenir l'utilisateur actuel
  User? get currentUser => _firebaseAuth.currentUser;
}
