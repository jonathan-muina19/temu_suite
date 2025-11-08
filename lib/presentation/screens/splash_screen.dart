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
  bool _authChecked = false;

  @override
  void initState() {
    super.initState();

    // Vérifie l'état auth et premier lancement
    Future.microtask(() {
      context.read<AuthBloc>().add(CheckAuthStatus());
      context.read<SplashCubit>().checkFirstLaunch();
    });
  }

  // ✅ Précharge les images de ta HomePage pour éviter le freeze
  Future<void> _precacheHomeAssets() async {
    await precacheImage(const AssetImage('assets/images/airbnb.png'), context);

    // Ajoute ici toutes les images de ta HomePage :
    // await precacheImage(AssetImage('assets/images/home_bg.png'), context);
    // await precacheImage(AssetImage('assets/images/categories.png'), context);
  }

  // ✅ Navigation fluide sans freeze
  Future<void> _navigate(String route) async {
    await _precacheHomeAssets();
    await Future.delayed(
      const Duration(milliseconds: 150),
    ); // stabilise le build

    if (mounted) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // ✅ Premier lancement → onboarding
        BlocListener<SplashCubit, SplashState>(
          listener: (context, state) async {
            if (_authChecked) return;
            if (state.status == SplashStatus.firstLaunch) {
              _authChecked = true;
              await _navigate('/onboarding');
            }
          },
        ),

        // ✅ Authentification Firebase
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (_authChecked) return;
            if (state is AuthLoading) return;

            if (state is AuthSuccess) {
              _authChecked = true;
              await _navigate('/mainwrapper');
            } else if (state is AuthEmailNotVerified) {
              _authChecked = true;
              await _navigate('/email-verify');
            } else if (state is AuthFailure) {
              _authChecked = true;
              await _navigate('/register');
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
              // ✅ Splash statique (pas d’animation = pas de lag)
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
