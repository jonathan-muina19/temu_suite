import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../data/models/user_model.dart';
import '../screens/notification_page.dart';

class CustomAppBarExample extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select<AuthBloc, UserModel?>((bloc) {
      final state = bloc.state;
      return state is AuthSuccess ? state.user : null;
    });

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 70, // un peu plus haut que la normale
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: CircleAvatar(
          maxRadius: 100,
          minRadius: 100,
          backgroundImage:
              user?.photoUrl != null && user!.photoUrl.isNotEmpty
                  ? NetworkImage(user.photoUrl)
                  : null,
          child:
              (user?.photoUrl == null || user!.photoUrl.isEmpty)
                  ? const Icon(Icons.person)
                  : null,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello 👋',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2),
          Text(
            user != null ? user.username : "Accueil",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NotificationPage()),
            );
          },
          icon: Image.asset("assets/icons/cloche.png", height: 25),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
