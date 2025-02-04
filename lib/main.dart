import 'package:flutter/material.dart';
import 'package:pokemondex/pokemonlist/views/pokemonlist_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: const Text(
              'My Pokemon App',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Colors.red[900],
          foregroundColor: Colors.grey.shade100,
        ),
        body: const PokemonList(),
      ),
    );
  }
}
