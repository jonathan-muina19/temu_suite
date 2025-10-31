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
                      "Type : ${recipe['Type'] ?? 'Inconnu'}",
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold
                          ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 18, color: Colors.orange),
                        const SizedBox(width: 5),
                        Text(
                          recipe['time'] ?? 'N/A',
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

                // Ingrédients
                const Text(
                  "Les ingrédients",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                //const Divider(thickness: 1),
                const SizedBox(height: 15),

                SizedBox(
                  height: 120, // hauteur fixe pour les containers
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        (recipe['ingredients'] as List<dynamic>?)?.length ?? 0,
                    separatorBuilder:
                        (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return Container(
                        width: 90, // Ajustez la largeur selon vos besoins
                        //margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade300, // Couleur sombre inspirée de l'image
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // 2. L'image de l'ingrédient et la coche
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                // Le cercle blanc pour l'image
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    // Simule l'image (utilisez Image.asset ou Image.network pour une vraie image)
                                    child: Text(
                                      '🥦',
                                      style: TextStyle(fontSize: 20),
                                    ), // Remplacer par Image.asset(imagePath): Container(),
                                  ),
                                ),
                                // La coche verte

                              ],
                            ),
                            const SizedBox(height: 10),

                            // 3. Le nom de l'ingrédient
                            Text(
                              recipe['ingredients'][index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Étapes
                const Text(
                  "Étapes de préparation",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(thickness: 1),
                const SizedBox(height: 10),

                // Liste des étapes
                ...List.generate(
                  (recipe['steps'] as List<dynamic>?)?.length ?? 0,
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
                            recipe['steps'][index],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
