import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

int nextId = 1;

// generate id for pokemon
int generateId() {
  final int uniqueId = nextId;
  nextId++;
  return uniqueId;
}

// pokemon class
class Pokemon {
  final int id;
  final String name;
  final String pkmnLink;

  const Pokemon({required this.id, required this.name, required this.pkmnLink});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: generateId(),
      name: json['name'] as String,
      pkmnLink: json['url'] as String,
    );
  }
}

// fetch all pokemon from api
Future<List<Pokemon>> fetchPokemon() async {
  final response = await http
      .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/?limit=1302'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)
        as Map<String, dynamic>; //Decode json data to a dart map object
    final results = data['results']
        as List<dynamic>; //Get results array from dart map object
    return results
        .map((json) => Pokemon.fromJson(json as Map<String, dynamic>))
        .toList(); //Map json objects from the list to pokemon objects and return all of them in a list
  } else {
    throw Exception('Failed to load pokemon list.');
  }
}
