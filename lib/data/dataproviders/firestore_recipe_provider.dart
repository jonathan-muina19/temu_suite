import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temu_recipe/data/repositories/recipes_repository.dart';

import '../models/recipe_model.dart';

class MyRecipeProvider implements RecipeRepository {
  // On instancie FIREBASE
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Obtenir la liste des recettes
  // On retourne un flux de données
  Stream<List<RecipeModel>> getRecipes() {
    return _firebaseFirestore.collection("recipes").snapshots().map((
        snapshot) =>
        snapshot.docs.map((doc) => RecipeModel.fromMap(doc.data())).toList());
  }

  // Mettre à jour le favori
  Future<void> updateFavorite(String recipeId, bool isFavorite) async {
    await _firebaseFirestore.collection("recipes").doc(recipeId).update({
      "isFavorite": isFavorite,
    });
  }
}