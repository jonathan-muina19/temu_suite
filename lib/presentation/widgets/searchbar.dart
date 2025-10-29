import 'package:flutter/material.dart';
//import 'package:lucide_icons/lucide_icons.dart'; // ou Icons si tu préfères

class SearchBarExample extends StatelessWidget {
  const SearchBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        hintText: "Rechercher votre plat...",
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.search, color: Colors.black),
        suffixIcon: Container(
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: IconButton(
            icon: Image.asset("assets/icons/parametres-curseurs.png", height: 20),
            onPressed: () {
              // Action filtre
            },
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(25),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          //borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
