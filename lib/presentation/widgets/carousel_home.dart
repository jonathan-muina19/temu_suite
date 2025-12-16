import 'package:flutter/material.dart';

class RecipeImageCard extends StatelessWidget {
  const RecipeImageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320, // largeur de la carte
        height: 150, // hauteur de la carte
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage('assets/images/madeblo.png'), // ton image ici
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // 🔹 Tag "Featured"
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "A la une",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // 🔹 Dégradé sombre pour lisibilité du texte
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),

            // 🔹 Texte et infos en bas
            const Positioned(
              left: 12,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Madesu",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        "50 minutes",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.people, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        "4",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.flag, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        "Irish",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
