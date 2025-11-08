import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/models/recipe_model.dart';
import '../../widgets/favoriteItem.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xffF1F5F9),
      appBar: AppBar(
        title: const Text(
          "Mes favoris",
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        centerTitle: true,
        backgroundColor: Colors.white30,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('recipes')
                .where('isFavorite', isEqualTo: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Aucune recette en favoris"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.only(bottom: 20),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final recipeId = doc.id;

              // Gestion robuste des données potentiellement null
              final RecipeModel? recipe =
                  (() {
                    try {
                      return RecipeModel.fromMap(data, recipeId);
                    } catch (e) {
                      print(
                        'Erreur lors de la récupération de la recette $recipeId : $e',
                      );
                      return null;
                    }
                  })();

              if (recipe == null) return const SizedBox.shrink();

              return FavoriteItem(
                recipe: recipe,
                time: recipe.time,
                name: recipe.name,
                type: recipe.type,
                imagePath: recipe.imagePath,
                onDelete: () => _toggleFavorite(recipeId, data['isFavorite']),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _toggleFavorite(String docId, bool currentValue) async {
    await FirebaseFirestore.instance.collection('recipes').doc(docId).update({
      'isFavorite': !currentValue,
    });
  }
}
