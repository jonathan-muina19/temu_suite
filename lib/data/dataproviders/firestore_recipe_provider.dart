import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temu_recipe/data/repositories/recipes_repository.dart';

import '../models/recipe_model.dart';

class MyRecipeProvider implements RecipeRepository {
  // On instancie FIREBASE
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Obtenir la liste des recettes
  // On retourne un flux de données
  Stream<List<RecipeModel>> getRecipes() {
    return _firebaseFirestore
        .collection("recipes")
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => RecipeModel.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }

  // Mettre à jour le favori
  Future<void> updateFavorite(String? recipeId, bool isFavorite) async {
    if (recipeId == null || recipeId.isEmpty) {
      print("❌ Erreur : l'ID du document est vide ou null");
      return;
    }

    await _firebaseFirestore.collection("recipes").doc(recipeId).update({
      "isFavorite": isFavorite,
    });

    if (isFavorite == true) {
      print("❤️ Ajouté aux favoris");
    } else {
      print("💔 Retiré des favoris");
    }
  }
}
