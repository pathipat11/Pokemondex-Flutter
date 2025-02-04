import 'package:flutter/material.dart';
import 'package:pokemondex/pokemondetail/views/pokemondetail_view.dart';
import 'package:pokemondex/pokemonlist/models/pokemonlist_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonList extends StatefulWidget {
  const PokemonList({Key? key}) : super(key: key);

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  PokemonListResponse? _data;
  List<PokemonListItem> _filteredResults = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String? _nextPageUrl = 'https://pokeapi.co/api/v2/pokemon?limit=20&offset=0';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (_isLoading || _nextPageUrl == null) return;

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(_nextPageUrl!));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final newData = PokemonListResponse.fromJson(jsonResponse);

      for (var item in newData.results) {
        final typeResponse = await http.get(Uri.parse(item.url));
        if (typeResponse.statusCode == 200) {
          final typeData = jsonDecode(typeResponse.body);
          final types = (typeData['types'] as List)
              .map((typeInfo) => typeInfo['type']['name'] as String)
              .toList();

          item.types = types;
        }
      }

      setState(() {
        _data = _data == null
            ? newData
            : _data!.copyWith(
                results: [..._data!.results, ...newData.results],
                next: newData.next,
              );
        _nextPageUrl = newData.next;
        _isLoading = false;
        _hasMore = _nextPageUrl != null;
        _filterPokemonList(_searchQuery);
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Failed to load data');
    }
  }

  void _filterPokemonList(String query) {
    setState(() {
      _searchQuery = query;
      _filteredResults = _data!.results
          .where((pokemon) =>
              pokemon.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterPokemonList,
              decoration: InputDecoration(
                labelText: 'Search Pokemon',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _data == null
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: _filteredResults.length,
                    itemBuilder: (context, index) {
                      final pokemon = _filteredResults[index];
                      final primaryType =
                          pokemon.types.isNotEmpty ? pokemon.types.first : 'normal';
                      final typeColor = getTypeColor(primaryType);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PokemondetailView(pokemonListItem: pokemon),
                            ),
                          );
                        },
                        child: Card(
                          color: typeColor,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  pokemon.imageUrl,
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  pokemon.name.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  primaryType.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _hasMore && !_isLoading
          ? FloatingActionButton(
              onPressed: loadData,
              child: const Icon(Icons.add),
              backgroundColor: Colors.red[900],
            )
          : null,
    );
  }
}
