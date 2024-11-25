import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

class PokemonData {
  final int id;
  final String name;
  final List<Map<String, dynamic>> abilities;
  final int weight;
  final int height;
  final List<dynamic> types;
  final List<dynamic> stats;

  const PokemonData(
      {required this.id,
      required this.name,
      required this.abilities,
      required this.weight,
      required this.height,
      required this.types,
      required this.stats});

  factory PokemonData.fromJson(Map<String, dynamic> json) {
    return PokemonData(
        id: json['id'] as int,
        name: json['name'] as String,
        abilities: (json['abilities'] as List<dynamic>).map((ability) {
          final abilityMap = ability as Map<String, dynamic>;
          return {
            'name': abilityMap['ability']['name'],
            'is_hidden': abilityMap['is_hidden'],
          };
        }).toList(),
        weight: json['weight'] as int,
        height: json['height'] as int,
        types: json['types'] as List<dynamic>,
        stats: (json['stats'] as List<dynamic>).map((stat) {
          final statMap = stat as Map<String, dynamic>;
          return {
            'name': statMap['stat']['name'] as String,
            'base_stat': statMap['base_stat'] as int
          };
        }).toList());
  }
}

Future<PokemonData> fetchPokemonData(int pkmnId) async {
  final response =
      await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pkmnId'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return PokemonData.fromJson(data);
  } else {
    throw Exception('Failed to load pokemon data.');
  }
}
