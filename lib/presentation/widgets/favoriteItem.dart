import 'package:flutter/material.dart';
import '../../data/models/recipe_model.dart';

class FavoriteItem extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback onDelete;
  final String name;
  final String type;
  final String imagePath;
  final String time;

  const FavoriteItem({
    super.key,
    required this.imagePath,
    required this.type,
    required this.name,
    required this.recipe,
    required this.onDelete,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              recipe.imagePath,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // TEXTS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    //const Icon(Icons.local_fire_department, size: 16),
                    const Icon(Icons.timer, size: 16),
                    const SizedBox(width: 3),
                    Text(
                      "${recipe.time}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // DELETE BUTTON
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
