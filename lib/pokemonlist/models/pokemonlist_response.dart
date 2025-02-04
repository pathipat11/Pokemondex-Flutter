import 'dart:convert';

class PokemonListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<PokemonListItem> results;

  PokemonListResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) {
    return PokemonListResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: List<PokemonListItem>.from(
          json['results'].map((x) => PokemonListItem.fromJson(x))),
    );
  }

  PokemonListResponse copyWith({
    int? count,
    String? next,
    String? previous,
    List<PokemonListItem>? results,
  }) {
    return PokemonListResponse(
      count: count ?? this.count,
      next: next ?? this.next,
      previous: previous ?? this.previous,
      results: results ?? this.results,
    );
  }
}

class PokemonListItem {
  final String name;
  final String url;
  List<String> types;

  PokemonListItem({
    required this.name,
    required this.url,
    this.types = const [],
  });

  String get imageUrl {
    // แปลง URL ให้ดึงภาพ PNG ที่มีความละเอียดสูง
    final id = url.split('/')[6];
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }

  factory PokemonListItem.fromJson(Map<String, dynamic> json) {
    return PokemonListItem(
      name: json['name'],
      url: json['url'],
      types: [],
    );
  }
  
  get http => null;

  Future<void> fetchTypes() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      this.types = (data['types'] as List)
          .map((typeInfo) => typeInfo['type']['name'] as String)
          .toList();
    }
  }
}
