import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temu_recipe/data/dataproviders/firestore_recipe_provider.dart';
import 'package:temu_recipe/presentation/widgets/appbar_home.dart';
import 'package:temu_recipe/presentation/widgets/recipeCard.dart';
import 'package:temu_recipe/presentation/widgets/searchbar.dart';

import '../recipe_detail_screen.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController controllerSearch = TextEditingController();
  final MyRecipeProvider _provider = MyRecipeProvider();

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
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('recipes')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Erreur : ${snapshot.error}'),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('Aucune recette trouvée'),
                      );
                    }

                    final recipes = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        final doc = recipes[index]; // ✅ document Firestore
                        final data = doc.data() as Map<String, dynamic>; // ✅ données
                        final recipeId = doc.id; // ✅ l'id Firestore

                        final isFavorite = data['isFavorite'] ?? false;

                        return RecipeCard(
                          imagePath: data['imagePath'] ?? '',
                          title: data['name'] ?? '',
                          description: data['description'] ?? '',
                          time: data['time'] ?? '',
                          isFavorite: isFavorite,
                          type: data['Type'] ?? '',
                          onFavoriteTap: () async {
                            try {
                              await _provider.updateFavorite(recipeId, !isFavorite);

                              // ✅ Optionnel : feedback visuel
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    !isFavorite
                                        ? 'Ajouté aux favoris ❤️'
                                        : 'Retiré des favoris 💔',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            } catch (e) {
                              print('Erreur Firestore: $e');
                            }
                          },
                          onRecipeDetails: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    RecipeDetailScreen(recipe: data),
                              ),
                            );
                          },
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
