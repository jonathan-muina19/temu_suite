import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_event.dart';
import '../../../bloc/auth/auth_state.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    /// Firebase Authentification
    final user = FirebaseAuth.instance.currentUser;

    /// Email de l'utilisateur
    final email = user?.email ?? 'Compte ou Email non disponible';

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure || state is AuthInitial) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/register',
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ' Veuillez patientez...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CircularProgressIndicator(color: Colors.orangeAccent),
                ],
              ),
            ),
          );
        }
        if (state is AuthSuccess) {
          final user = state.user;
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile', style: TextStyle(fontFamily: 'Poppins')),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: SafeArea(
              child: Center(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 50,
                      backgroundImage: AssetImage(
                        'assets/images/utilisateur.png',
                      ),
                    ),
                    Text(
                      '${state.user.username}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${state.user.email}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30),
                    buildMenuItem(
                      context,
                      color: Colors.blue,
                      icon: Icons.person,
                      title: "Edit Profile",
                      onTap: () {},
                    ),
                    buildMenuItem(
                      context,
                      color: Colors.green,
                      icon: Icons.settings,
                      title: "Settings",
                      onTap: () {},
                    ),
                    buildMenuItem(
                      context,
                      color: Colors.orangeAccent,
                      icon: Icons.lock,
                      title: "Privacy Policy",
                      onTap: () {},
                    ),
                    buildMenuItem(
                      context,
                      color: Colors.red,
                      icon: Icons.power_settings_new,
                      title: "Logout",
                      onTap: () {
                        context.read<AuthBloc>().add(SignOutRequested());
                      },
                    ),
                    const SizedBox(height: 20),
                    if (currentUser != null && currentUser!.photoURL != null)
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(currentUser!.photoURL!),
                      ),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: const CircularProgressIndicator(color: Colors.orangeAccent),
          ),
        );
      },
    );
  }
}

Widget buildMenuItem(
  BuildContext context, {
  required Color color,
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    onTap: onTap,
    leading: Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        //shape: BoxShape.circle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color),
    ),
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),
    trailing: Image.asset('assets/icons/angle-right.png', height: 16),
  );
}
