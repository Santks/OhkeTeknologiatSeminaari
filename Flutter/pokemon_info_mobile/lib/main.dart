import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState()
        ..loadPokemonList(), // fetch pokemon data when starting the app
      child: MaterialApp(
        title: 'Pokemon info',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
          useMaterial3: true,
        ),
        home: HomePage(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  List<Pokemon> _pokemonList = [];
  bool _isLoading = true;

  List<Pokemon> get pokemonList => _pokemonList;
  bool get isLoading => _isLoading;

  Future<void> loadPokemonList() async {
    try {
      _isLoading = true;
      notifyListeners();
      final fetched = await fetchPokemon();
      _pokemonList.addAll(fetched);
    } catch (err) {
      print('error while fetching pokemon: $err');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        indicatorColor: Colors.greenAccent,
        selectedIndex: selectedIndex,
        destinations: [
          NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: "Home"),
          NavigationDestination(
              selectedIcon: Icon(Icons.list),
              icon: Icon(Icons.list_outlined),
              label: "LIst"),
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_outline),
            label: "Favourites",
          ),
          NavigationDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined),
              label: "Settings")
        ],
      ),
      body: <Widget>[
        Scaffold(appBar: AppBar(title: Text("Pokemon info"))),
        ListPage(),
        FavoritesPage(),
        SettingsPage(),
      ][selectedIndex],
    );
  }
}

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Scaffold(
        appBar: AppBar(title: Text("Pokemon list")),
        body: appState.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  final pokemon = appState.pokemonList[index];
                  return ListTile(
                    title: Text('${pokemon.id}  ${pokemon.name}'),
                  );
                },
              ));
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("List of favourites")));
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Settings")));
  }
}
