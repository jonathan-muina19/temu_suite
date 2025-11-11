class CategoryModel {
  final String id;
  final String name;
  final String icon;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  // Convertir Firestore en objet Dart
  factory CategoryModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return CategoryModel(
      id: docId,
      name: data['name'] ?? '',
      icon: data['icon'] ?? '',
    );
  }

  // Convertir objet Dart en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon,
    };
  }
}
