import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temu_recipe/data/repositories/category_repository.dart';
import '../models/category_model.dart';

class CategoryProvider implements CategoryRepository {
  final FirebaseFirestore firestore ;

  CategoryProvider({required this.firestore});

  @override
  Stream<List<CategoryModel>> getCategories() {
    return firestore
        .collection('categories')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CategoryModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    await firestore.collection('categories').add(category.toMap());
  }

  @override
  Future<CategoryModel?> getCategoryById(String id) async {
    final doc = await firestore.collection('categories').doc(id).get();
    if (doc.exists) {
      return CategoryModel.fromFirestore(doc.data()!, doc.id);
    }
    return null;
  }
}
