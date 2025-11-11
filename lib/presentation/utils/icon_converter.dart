import 'package:flutter/material.dart';

IconData convertIcon(String iconName) {
  switch (iconName) {
    case "free_breakfast_outlined":
      return Icons.free_breakfast_outlined;
    case "lunch_dining_outlined":
      return Icons.lunch_dining_outlined;
    case "local_bar":
      return Icons.local_bar;
    case "cake_outlined":
      return Icons.cake_outlined;
    default:
      return Icons.category;
  }
}
