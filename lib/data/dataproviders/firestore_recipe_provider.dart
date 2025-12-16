import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:temu_recipe/data/repositories/recipes_repository.dart';

import '../models/recipe_model.dart';

class MyRecipeProvider implements RecipeRepository {
  // On instancie FIREBASE
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  /// 🔴 Vérifie si la recette est favorite (PAR USER)
  Stream<bool> isRecipeFavorite(String recipeId) {
    final uid = _auth.currentUser!.uid;

    return _firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(recipeId)
        .snapshots()
        .map((doc) => doc.exists);
  }

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

  // ❤️ Toggle favoris PAR UTILISATEUR
  Future<void> toggleFavorite(String recipeId) async {
    final uid = _auth.currentUser!.uid;

    final favRef = _firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(recipeId);

    final snapshot = await favRef.get();

    if (snapshot.exists) {
      // 💔 Retirer des favoris
      await favRef.delete();
    } else {
      // ❤️ Ajouter aux favoris
      await favRef.set({
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }


  Future<void> addToFavorites(String recipeId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(recipeId)
        .set({
      'recipeId': recipeId,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }







  /// 🔹 1. IDs des recettes favorites de l'utilisateur
  Stream<List<String>> getFavoriteRecipeIds() {
    final uid = _auth.currentUser!.uid;

    return _firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  /// 🔹 2. Récupérer les recettes favorites
  Stream<List<RecipeModel>> getFavoriteRecipesByIds(List<String> ids) {
    if (ids.isEmpty) {
      return Stream.value([]);
    }

    return _firebaseFirestore
        .collection('recipes')
        .where(FieldPath.documentId, whereIn: ids)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs
              .map((doc) => RecipeModel.fromMap(doc.data(), doc.id))
              .toList(),
    );
  }




  // ✅ Vérifier si recette est favorite
  Stream<List<String>> getFavoriteIds() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .collection("favorites")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((d) => d.id).toList());
  }
}


