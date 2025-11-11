import 'package:temu_recipe/data/models/category_model.dart';

abstract class CategoryRepository {
  Stream<List<CategoryModel>> getCategories();
  Future<void> addCategory(CategoryModel category);
  Future<CategoryModel?> getCategoryById(String id);
}