import '../models/recipe_model.dart';

abstract class RecipeRepository {
  Stream<List<RecipeModel>> getRecipes();
  Future<void> toggleFavorite(String recipeId);
  Stream<List<String>> getFavoriteIds();
}
