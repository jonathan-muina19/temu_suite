import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image principale
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    recipe['imagePath'] ?? 'assets/images/default.png',
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
      
                // Nom
                Text(
                  recipe['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 8),
      
                // Type + Temps
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Type : ${recipe['type'] ?? 'Inconnu'}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 18, color: Colors.orange),
                        const SizedBox(width: 5),
                        Text(
                          recipe['tempsPreparation'] ?? 'N/A',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
      
                // Description
                Text(
                  recipe['description'] ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
      
                // Étapes
                const Text(
                  "Étapes de préparation",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
      
                // Liste des étapes
                ...List.generate(
                  (recipe['etapes'] as List<dynamic>?)?.length ?? 0,
                      (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${index + 1}. ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            recipe['etapes'][index],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          onPressed: () {
            // TODO: gérer ajout aux favoris
          },
          child: Icon(
            recipe['isFavorite'] == true
                ? Icons.favorite
                : Icons.favorite_border,
          ),
        ),
      ),
    );
  }
}
