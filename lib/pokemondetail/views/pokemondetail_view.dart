import 'package:flutter/material.dart';
import 'package:pokemondex/pokemonlist/models/pokemonlist_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemondetailView extends StatefulWidget {
  final PokemonListItem pokemonListItem;

  const PokemondetailView({Key? key, required this.pokemonListItem})
      : super(key: key);

  @override
  State<PokemondetailView> createState() => _PokemondetailViewState();
}

class _PokemondetailViewState extends State<PokemondetailView> {
  Map<String, dynamic>? pokemonData;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final response = await http.get(Uri.parse(widget.pokemonListItem.url));
    if (response.statusCode == 200) {
      setState(() {
        pokemonData = jsonDecode(response.body);
      });
    }
  }

  Color getTypeColor(String type) {
    switch (type) {
      case 'fire':
        return Colors.redAccent;
      case 'water':
        return Colors.blueAccent;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.yellow.shade600;
      case 'ice':
        return Colors.cyanAccent;
      case 'fighting':
        return Colors.orange;
      case 'poison':
        return Colors.purple;
      case 'ground':
        return Colors.brown;
      case 'flying':
        return Colors.lightBlueAccent;
      case 'psychic':
        return Colors.pinkAccent;
      case 'bug':
        return Colors.lightGreen;
      case 'rock':
        return Colors.grey;
      case 'ghost':
        return Colors.deepPurpleAccent;
      case 'dark':
        return Colors.black87;
      case 'dragon':
        return Colors.indigo;
      case 'steel':
        return Colors.blueGrey;
      case 'fairy':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatRow(String label, int value, int maxValue) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value.toString()),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value / maxValue,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(getTypeColor(label.toLowerCase())),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pokemonListItem.name.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: getTypeColor(widget.pokemonListItem.types.first),
        foregroundColor: Colors.white,
      ),
      body: pokemonData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              widget.pokemonListItem.imageUrl,
                              height: 150,
                              width: 150,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              pokemonData!['name'].toString().toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8.0,
                              children: (pokemonData!['types'] as List)
                                  .map((typeInfo) {
                                    final typeName = typeInfo['type']['name'];
                                    return Chip(
                                      label: Text(
                                        typeName.toUpperCase(),
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: getTypeColor(typeName),
                                    );
                                  })
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                            // Display Abilities
                            const Text('Abilities',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Wrap(
                              spacing: 8.0,
                              children: (pokemonData!['abilities'] as List)
                                  .map((abilityInfo) => Chip(
                                        label: Text(
                                          abilityInfo['ability']['name'],
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                            // Display Stats
                            const Text('Base Stats',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            ...((pokemonData!['stats'] as List)
                                .map((stat) => _buildStatRow(
                                      stat['stat']['name'],
                                      stat['base_stat'],
                                      100,
                                    ))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
