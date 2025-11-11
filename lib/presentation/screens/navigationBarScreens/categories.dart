import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temu_recipe/data/dataproviders/category_provider.dart';

import '../../../data/models/category_model.dart';
import '../../../data/repositories/category_repository.dart';
import '../../utils/icon_converter.dart';
import '../../widgets/category_card.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({super.key});

  final CategoryRepository repository = CategoryProvider(firestore: FirebaseFirestore.instance);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Categories", style: TextStyle(
              fontFamily: 'Poppins'
          ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pushNamedAndRemoveUntil
              (context, '/mainwrapper', (route) => false),
            child: Container(
              margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
        body: StreamBuilder<List<CategoryModel>>(
          stream: repository.getCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(
                color: Colors.orangeAccent
              ));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Aucune catégorie trouvée"));
            }

            final categories = snapshot.data!;

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.3,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];

                return CategoryCard(
                  title: category.name,
                  icon: convertIcon(category.icon),
                  onTap: () {
                    // TODO: Aller vers liste des recettes par catégorie
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
