import 'package:flutter/material.dart';

import '../../data/dataproviders/firestore_recipe_provider.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.orange[50],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// IMAGE PRINCIPALE
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.recipe['imagePath'] ?? 'assets/images/default.png',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 16),

                /// TITRE INGREDIENTS
                Row(
                  children: [
                    Image.asset('assets/icons/oignon.png', height: 40),
                    const SizedBox(width: 10),
                    const Text(
                      "Ingrédients",
                      style: TextStyle(fontSize: 22, fontFamily: 'Poppins'),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.orange.withOpacity(0.15),
                      child: Text(
                        "${widget.recipe['ingredients'].length}",
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                /// LISTE DES INGREDIENTS (PLUS DE SCROLL INTERNE)
                ListView.separated(
                  shrinkWrap: true, // ← IMPORTANT
                  physics: const NeverScrollableScrollPhysics(), // ← IMPORTANT
                  itemCount:
                      (widget.recipe['ingredients'] as List<dynamic>?)?.length ?? 0,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.orange[50],
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.recipe['ingredients'][index],
                                style: const TextStyle(fontFamily: 'Poppins'),
                              ),
                            ),
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                /// --- TITRE INSTRUCTIONS AVEC ICÔNE ---
                Row(
                  children: [
                    Image.asset('assets/icons/livre-ouvert.png', height: 28),
                    const SizedBox(width: 10),
                    const Text(
                      "Instructions",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.orange.withOpacity(0.15),
                      child: Text(
                        "${widget.recipe['steps'].length}",
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// --- LISTE DES ÉTAPES ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(widget.recipe['steps'].length, (index) {
                    final stepNumber = index + 1;
                    final stepText = widget.recipe['steps'][index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// NUMÉRO DANS UNE BULLE
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.deepOrange,
                            child: Text(
                              "$stepNumber",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// TEXTE : TITRE + DESCRIPTION
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// TITRE (PAS EN MAJUSCULES)
                                Text(
                                  stepText,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),

                                const SizedBox(height: 6),

                                /// SOUS-TITRE
                                Text(
                                  "Step $stepNumber",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// ICÔNE CHECK
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.grey[400],
                            size: 26,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 15),
                /*GestureDetector(
                  onTap: ()  {
                  },
                  child: Container(
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_sharp, color: Colors.white),
                        const SizedBox(width: 15),
                        Center(
                          child: Text(
                            'Ajouter aux favoris',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: Colors.white
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),*/
               // const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
