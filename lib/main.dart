import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temu_recipe/presentation/router/app_router.dart';
import 'package:temu_recipe/presentation/screens/splash_screen.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/navigation/navigation_cubit.dart';
import 'bloc/splash/splash_cubit.dart';
import 'bloc/users/user_bloc.dart';
import 'data/dataproviders/firebase_auth_provider.dart';
import 'data/repositories/auth_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final AuthRepository authRepository = MyAuthProvider();
  final firestore = FirebaseFirestore.instance;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc(authRepository)),
        /// ✅ Ajout du SplashCubit ici
        BlocProvider<SplashCubit>(create: (context) => SplashCubit()),
        /// ✅ Ajout du UserBloc ici
        BlocProvider<UserBloc>(create: (context) => UserBloc(firestore)),
        /// ✅ Ajout du NavigationCubit ici
        BlocProvider<NavigationCubit>(create: (context) => NavigationCubit()),
      ],
      child: MyApp(authRepository: authRepository),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  MyApp({super.key, required this.authRepository});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      onGenerateRoute: _appRouter.onGenerateRoute,
    );
  }
}
