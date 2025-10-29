import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temu_recipe/presentation/widgets/appbar_home.dart';
import 'package:temu_recipe/presentation/widgets/searchbar.dart';

import '../recipe_detail_screen.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController controllerSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBarExample(),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Qu’aimerais-tu cuisiner aujourd’hui ? 🍲",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: "Montserrat",
                ),
              ),
              const SizedBox(height: 15),
              const SearchBarExample(),
              const SizedBox(height: 20),

              // 🔥 Partie qui affiche les recettes
              Expanded(
                // On utilise un StreamBuilder pour afficher les recettes en temps réel
                child: StreamBuilder<QuerySnapshot>(
                  // On récupère les recettes depuis Firestore
                  stream: FirebaseFirestore.instance
                      .collection('recipes')
                      .snapshots(),
                  builder: (context, snapshot) {

                    // On affiche un circular quand on recuperer les recettes
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.orange
                          ));
                    }

                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Erreur : ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text('Aucune recette trouvée'));
                    }

                    final recipes = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        // On récupère les données de la recette
                        final data = recipes[index].data() as Map<String, dynamic>;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RecipeDetailScreen(recipe: data),
                                ),
                              );
                            },
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  data['imagePath'] ?? 'assets/images/default.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                data['name'] ?? 'Nom inconnu',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data['description'] ?? '',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                data['isFavorite'] == false
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                            ),
                          )
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
