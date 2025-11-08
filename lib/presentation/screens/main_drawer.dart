import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/navigation/navigation_cubit.dart';
import '../../bloc/navigation/navigation_state.dart';
import 'home_screen.dart';
import 'navigationBarScreens/categories.dart';
import 'navigationBarScreens/favoris.dart';
import 'navigationBarScreens/home.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomePage(),
      CategoriesPage(),
      FavoritesPage(),
      HomeScreen(),
    ];

    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: screens[state.selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: state.selectedIndex,
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                backgroundColor: Colors.white,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                onTap:
                    (index) =>
                        context.read<NavigationCubit>().updateIndex(index),
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/icons/maison.png", height: 20),
                    label: 'Accueil',
                    activeIcon: Image.asset(
                      "assets/icons/maison (1).png",
                      height: 20,
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/icons/categorie.png", height: 20),
                    label: 'Catégories',
                    activeIcon: Image.asset(
                      "assets/icons/categorie (1).png",
                      height: 20,
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/icons/coeur (1).png", height: 20),
                    label: 'Favoris',
                    activeIcon: Image.asset(
                      "assets/icons/coeur (2).png",
                      height: 20,
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      "assets/icons/utilisateur.png",
                      height: 20,
                    ),
                    label: 'Profil',
                    activeIcon: Image.asset(
                      "assets/icons/utilisateur (1).png",
                      height: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
