import 'package:flutter/material.dart';
import 'package:temu_recipe/presentation/widgets/appbar_home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBarExample(),
      ),
    );
  }
}




