import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class FavPokemon {
  final String key; //Firebase reference key
  final int id;
  final String name;
  final String url;

  const FavPokemon(
      {required this.key,
      required this.id,
      required this.name,
      required this.url});

//Create a favorite pokemon instance from Json data
  factory FavPokemon.fromJson(Map<String, dynamic> json, String key) {
    return FavPokemon(
        key: key,
        id: json['pkmnId'] as int,
        name: json['name'] as String,
        url: json['url'] as String);
  }
}

//Fetch favorites from database
Future<List<FavPokemon>> fetchFavorites() async {
  var user = FirebaseAuth.instance.currentUser;
  DatabaseReference favoriteRef =
      FirebaseDatabase.instance.ref('users/${user!.uid}');
  try {
    final snapshot =
        await favoriteRef.get(); //Get a snapshot of current users favorites
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data.entries.map((entry) {
        //Add entry key to Map with values because its not included in the entry.value
        return FavPokemon.fromJson(
            Map<String, dynamic>.from(entry.value as Map), entry.key);
      }).toList();
    } else {
      throw Exception("No favorites found for this user.");
    }
  } catch (error) {
    throw Exception("Failed to load favorites: $error");
  }
}
