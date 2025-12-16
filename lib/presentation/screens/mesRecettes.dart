import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:temu_recipe/data/dataproviders/firestore_recipe_provider.dart';
import 'package:temu_recipe/presentation/screens/recipe_detail_screen.dart';

import '../widgets/recipeCard.dart';

class Mesrecettes extends StatelessWidget {
  Mesrecettes({super.key});

  final MyRecipeProvider _provider = MyRecipeProvider();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap:
                () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/mainwrapper',
                  (route) => false,
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Mes recettes",
            style: TextStyle(fontSize: 22, fontFamily: 'Poppins'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              Row(
                children: [

                ],
              ),
              const SizedBox(height: 10),
              // 🔥 Partie affichage des recettes
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                  FirebaseFirestore.instance
                      .collection('recipes')
                  //.where('Type', isEqualTo: 'Plat principal' )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Erreur : ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('Aucune recette trouvée'),
                      );
                    }

                    final recipes = snapshot.data!.docs;

                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: recipes.length ,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 👉 2 colonnes
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio:
                        0.70, // Ajuste la hauteur des cartes
                      ),
                      itemBuilder: (context, index) {
                        final doc = recipes[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final recipeId = doc.id;

                        final isFavorite = data['isFavorite'] ?? false;

                        return RecipeCard(
                          imagePath: data['imagePath'] ?? '',
                          title: data['name'] ?? '',
                          description: data['description'] ?? '',
                          time: data['time'] ?? '',
                          type: data['Type'] ?? '',
                          isFavorite: isFavorite,
                          onFavoriteTap: () async {
                            try {
                              await _provider.toggleFavorite(
                                recipeId,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    !isFavorite
                                        ? 'Ajouté aux favoris ❤️'
                                        : 'Retiré des favoris 💔',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                builder:
                                    (_) => RecipeDetailScreen(recipe: data),
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
