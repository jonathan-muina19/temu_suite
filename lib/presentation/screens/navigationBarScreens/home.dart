import 'package:flutter/material.dart';
import 'package:temu_recipe/presentation/widgets/appbar_home.dart';
import 'package:temu_recipe/presentation/widgets/myTextfield.dart';
import 'package:temu_recipe/presentation/widgets/searchbar.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  TextEditingController controllerSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBarExample(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Qu'aimerais-tu cuisiner aujourd'hui",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: "Montserrat",
                  //fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const SearchBarExample(),
            ],
          ),
        ),
      ),
    );
  }
}
