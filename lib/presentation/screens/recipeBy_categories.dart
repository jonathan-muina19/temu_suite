import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipesByCategoryPage extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const RecipesByCategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final recipesQuery = FirebaseFirestore.instance
        .collection('recipes')
        .where('categoryId', isEqualTo: categoryId);

    return Scaffold(
      appBar: AppBar(
        title: Text("$categoryName", style: TextStyle(fontFamily: 'Poppins')),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: recipesQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orangeAccent),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/category_icon.gif', height: 180),
                  Text(
                    "Aucune recette de cette categorie trouvée",
                    style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
                  ),
                ],
              ),
            );
          }

          final recipes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index].data();

              return ListTile(
                leading:
                    recipe['imagePath'] != null
                        ? Image.asset(
                          recipe['imagePath'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                        : const Icon(Icons.fastfood),
                title: Text(
                  recipe['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "$categoryName",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  // Aller vers les détails
                },
              );
            },
          );
        },
      ),
    );
  }
}
