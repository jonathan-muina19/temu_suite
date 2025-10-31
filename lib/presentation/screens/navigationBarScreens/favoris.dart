import 'package:flutter/material.dart';

class FavorisPage extends StatelessWidget {
  const FavorisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recipes = [
      {
        "title": "Boxty Breakfast",
        "image": "assets/images/boxty.jpg",
        "time": "30 min",
        "people": "4",
        "country": "Irish",
      },
      {
        "title": "Pondu",
        "image": "assets/images/pondu.jpg",
        "time": "1h30",
        "people": "3",
        "country": "Congo",
      },
      {
        "title": "Salade César",
        "image": "assets/images/salad.jpg",
        "time": "20 min",
        "people": "2",
        "country": "French",
      },
      // tu peux en ajouter d'autres ici
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recettes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: recipes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 👈 2 cartes par ligne
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return RecipeCard(recipe: recipe);
          },
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipe;
  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(recipe["image"]),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Dégradé noir transparent
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Text(
                recipe["title"],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

