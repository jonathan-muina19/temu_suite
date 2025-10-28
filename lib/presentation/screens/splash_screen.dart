import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/splash/splash_cubit.dart';
import '../../bloc/splash/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _authChecked = false; // ✅ pour éviter plusieurs redirections

  @override
  void initState() {
    super.initState();

    // Vérifie si l'utilisateur Firebase est connecté
    Future.microtask(() {
      context.read<AuthBloc>().add(CheckAuthStatus());
    });

    // Vérifie si c'est le premier lancement
    Future.microtask(() {
      context.read<SplashCubit>().checkFirstLaunch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // 🔹 Écoute de l'état du Splash (premier lancement ou non)
        BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state.status == SplashStatus.firstLaunch) {
              Navigator.pushReplacementNamed(context, '/onboarding');
            }
          },
        ),

        // 🔹 Écoute des états d'authentification Firebase
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            // On empêche plusieurs redirections pendant un hot reload
            if (_authChecked) return;
            if (state is AuthLoading) return;

            if (state is AuthSuccess) {
              _authChecked = true;
              Navigator.pushReplacementNamed(context, '/mainwrapper');
            } else if (state is AuthEmailNotVerified) {
              _authChecked = true;
              Navigator.pushReplacementNamed(context, '/email-verify');
            } else if (state is AuthFailure) {
              _authChecked = true;
              Navigator.pushReplacementNamed(context, '/register');
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.deepOrange,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/airbnb.png', height: 110),
              const SizedBox(height: 10),
              const Text(
                'T E M U',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
