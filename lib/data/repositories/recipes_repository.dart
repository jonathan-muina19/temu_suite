import '../models/recipe_model.dart';

abstract class RecipeRepository {
  Stream<List<RecipeModel>> getRecipes();
  Future<void> updateFavorite(String recipeId, bool isFavorite);
}
