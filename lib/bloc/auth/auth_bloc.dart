import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    // Connexion
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // Connexion via repository
        await authRepository.signIn(event.email, event.password);
        final user = FirebaseAuth.instance.currentUser;
        // Vérifier si l'utilisateur est connecté et email vérifié
        if (user != null && !user.emailVerified) {
          emit(AuthFailure('email-not-verified'));
          return;
        }

        if (user != null) {
          // 🔥 Récupérer les infos Firestore
          final snapshot =
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.uid)
                  .get();

          if (snapshot.exists) {
            // 🔥 Récupérer les infos Firestore
            // 🔥 Les infos Firestore sont stockées dans un Map
            // 🔥 On peut les convertir en UserModel
            final data = snapshot.data()!;
            // 🔥 Convertir les infos Firestore en UserModel
            final userModel = UserModel.fromMap(data, user.uid);

            // ✅ On envoie AuthSuccess avec toutes les infos
            emit(AuthSuccess(userModel));
          } else {
            emit(AuthFailure("Aucune donnée utilisateur trouvée"));
          }
        } else {
          emit(AuthFailure("Utilisateur introuvable"));
        }
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'Utilisateur non trouvé';
            break;
          case 'wrong-password':
            message = 'Mot de passe incorrect';
            break;
          case 'invalid-email':
            message = 'Email invalide';
            break;
          case 'invalid-credential':
            message = 'Email ou mot de passe incorrect!';
            break;
          default:
            message = 'Pas de connexion internet,\nessayez plus tard';
        }
        emit(AuthFailure(message));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignInWithGoogle>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signInWithGoogle();
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          emit(AuthFailure("Connexion Google annulée."));
          return;
        }

        // ✅ Directement utiliser les infos FirebaseAuth
        final userModel = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          username: user.displayName ?? 'Utilisateur',
          photoUrl: user.photoURL ?? "",
        );

        emit(AuthSuccess(userModel));
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'account-exists-with-different-credential':
            message =
                "Un compte existe déjà avec une autre méthode de connexion.";
          case 'invalid-credential':
            message = "Les identifiants Google sont invalides.";
          case 'user-disabled':
            message = "Ce compte a été désactivé.";
          case 'operation-not-allowed':
            message = "La connexion avec Google n’est pas autorisée.";
          default:
            message = "Erreur de connexion \n: ${e.message}";
        }
        emit(AuthFailure(message));
      } catch (e) {
        print("Erreur : $e");
        emit(AuthFailure("Erreur inattendue $e"));
      }
    });

    // Inscription
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // Inscription avec le repository
        await authRepository.signUp(
          event.email,
          event.password,
          event.username,
        );
        // Envoyer l'email de vérification
        await authRepository.sendEmailVerification();
        emit(EmailVerificationSent());
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'email-already-in-use':
            message = 'Cet email est déjà utilisé.';
            break;
          case 'invalid-email':
            message = 'Email invalide.';
            break;
          case 'weak-password':
            message = 'Mot de passe trop faible.';
            break;
          default:
            message = 'Pas de connexion internet,\nessayez plus tard';
        }
        emit(AuthFailure(message));
      } catch (e) {
        emit(AuthFailure("Une erreur s'est produite\nRessayez plus tard"));
      }
    });

    // Déconnexion
    on<SignOutRequested>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 5));
      await authRepository.signOut();
      emit(AuthInitial());
    });

    // Vérifier statut
    on<CheckAuthStatus>((event, emit) async {
      emit(AuthLoading()); // ⏳ Ajout utile pour indiquer qu'on vérifie
      await Future.delayed(const Duration(seconds: 2));
      try {
        final isLoggedIn = await authRepository.isSignedIn.first;
        final user = FirebaseAuth.instance.currentUser;

        if (isLoggedIn && user != null) {
          if (!user.emailVerified) {
            emit(AuthEmailNotVerified());
            return;
          }

          // Récupérer le document Firestore
          final snapshot =
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.uid)
                  .get();

          if (snapshot.exists) {
            final userModel = UserModel.fromMap(snapshot.data()!, user.uid);
            emit(AuthSuccess(userModel));
          } else {
            emit(AuthFailure("Utilisateur introuvable dans Firestore"));
          }
        } else {
          emit(AuthFailure("Aucun utilisateur connecté"));
        }
      } catch (e) {
        emit(AuthFailure("Erreur : $e"));
      }
    });

    //
    on<CheckEmailVerified>((event, emit) async {
      // Emettre l'état de chargement
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 2));
      try {
        // Vérifier si l'email est vérifié
        final user = FirebaseAuth.instance.currentUser;
        await user?.reload(); // Recharger l'utilisateur
        // Si oui, emiter l'état d'email vérifié
        final refreshedUser = FirebaseAuth.instance.currentUser;
        if (refreshedUser != null && refreshedUser.emailVerified) {
          emit(AuthEmailVerified());
        } else {
          emit(AuthEmailNotVerified());
        }
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'Utilisateur non trouvé';
            break;
          case 'invalid-email':
            message = 'Email invalide';
            break;
          default:
            message = 'Pas de connexion internet,\nessayez plus tard';
        }
        emit(AuthFailure(message));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
