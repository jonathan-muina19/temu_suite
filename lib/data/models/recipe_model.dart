class RecipeModel {
  final String id;
  final String name;
  final String description;
  final String type; // ex: "Plat principal", "Dessert", "Boisson"
  final List<String> steps; // chaque étape de préparation
  final List<String> ingredients;
  final String time; // ex: "45 min"
  final String imagePath; // chemin local dans assets
  final bool isFavorite; // pour savoir si c’est un favori

  RecipeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.steps,
    required this.ingredients,
    required this.time,
    required this.imagePath,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "type": type,
      "steps": steps,
      "ingredients": ingredients, // nouvelle propriété "ingredients"
      "time": time,
      "imagePath": imagePath,
      "isFavorite": isFavorite,
    };
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map, String documentId) {
    return RecipeModel(
      id: documentId,
      name: map["name"],
      description: map["description"],
      type: map["type"],
      steps: List<String>.from(map["steps"]),
      ingredients: List<String>.from(
        map["ingredients"],
      ), // nouvelle propriété "ingredients"
      time: map["time"],
      imagePath: map["imagePath"],
      isFavorite: map["isFavorite"] ?? false,
    );
  }

  //
  RecipeModel copyWith({bool? isFavorite}) {
    return RecipeModel(
      id: id,
      name: name,
      description: description,
      type: type,
      steps: steps,
      ingredients: ingredients, // nouvelle propriété "ingredients"
      time: time,
      imagePath: imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
