import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temu_recipe/data/dataproviders/firestore_recipe_provider.dart';

import '../../../data/models/recipe_model.dart';
import '../../../data/repositories/recipes_repository.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage({super.key});

  final MyRecipeProvider repository = MyRecipeProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes favoris", style: TextStyle(fontFamily: 'Poppins')),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
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
      ),
      body: StreamBuilder<List<String>>(
        stream: repository.getFavoriteRecipeIds(),
        builder: (context, favSnapshot) {
          if (!favSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final favoriteIds = favSnapshot.data!;

          if (favoriteIds.isEmpty) {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/icons/notifications-telephoniques.gif", height: 170),
                    Text("Aucune recette en favori", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                      ),
                    ),
                  ],
                )
            );
          }

          return StreamBuilder<List<RecipeModel>>(
            stream: repository.getFavoriteRecipesByIds(favoriteIds),
            builder: (context, recipeSnapshot) {
              if (!recipeSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final recipes = recipeSnapshot.data!;

              return ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6),
                      ],
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          recipe.imagePath,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        recipe.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("⏱ ${recipe.time}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('favorites')
                              .doc(recipe.id)
                              .delete();
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
