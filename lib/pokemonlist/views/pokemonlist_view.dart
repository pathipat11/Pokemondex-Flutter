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
  bool _isLoading = false;
  String? _nextPageUrl = 'https://pokeapi.co/api/v2/pokemon?limit=20';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // โหลดข้อมูลจาก API
  Future<void> loadData() async {
    if (_isLoading || _nextPageUrl == null) return;

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(_nextPageUrl!));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final newData = PokemonListResponse.fromJson(jsonResponse);

      setState(() {
        _data = _data == null
            ? newData
            : _data!.copyWith(
                results: [..._data!.results, ...newData.results],
                next: newData.next,
              );
        _nextPageUrl = newData.next;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: _data == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _data!.results.length + 1,
              itemBuilder: (context, index) {
                if (index == _data!.results.length) {
                  loadData(); // Trigger next page load
                  return const Center(
                      child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator()));
                }

                final pokemon = _data!.results[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Image.network(
                        pokemon.imageUrl,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        pokemon.name.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PokemondetailView(pokemonListItem: pokemon),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
