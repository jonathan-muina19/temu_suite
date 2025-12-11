import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temu_recipe/data/dataproviders/firestore_recipe_provider.dart';
import '../../widgets/appbar_home.dart';
import '../../widgets/carousel_home.dart';
import '../../widgets/recipeCard.dart';
import '../../widgets/searchbar.dart';
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
              //const SizedBox(height: 10),
              //const SearchBarExample(),
              const SizedBox(height: 15),
              const RecipeImageCard(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Text(
                      'Mes Recettes',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 120),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Voir plus',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

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
                      itemCount: recipes.length,
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
                              await _provider.updateFavorite(
                                recipeId,
                                !isFavorite,
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
