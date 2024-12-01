import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//Utility class imports
import 'package:pokemon_info_mobile/utils/pokemon.dart';
import 'package:pokemon_info_mobile/utils/pokemon_data.dart';
import 'package:pokemon_info_mobile/utils/favorites.dart';

//Dialog imports
import 'package:pokemon_info_mobile/dialogs/login_dialog.dart';
import 'package:pokemon_info_mobile/dialogs/register_dialog.dart';

// Page imports
import 'package:pokemon_info_mobile/pages/list_page.dart';
import 'package:pokemon_info_mobile/pages/favorite_list.dart';
import 'package:pokemon_info_mobile/pages/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  List<Pokemon> _pokemonList = []; //private list that holds all pokemon
  PokemonData?
      _pokemonData; //private object that holds data of one pokemon and can be null
  bool _isLoading = false;
  List<FavPokemon> _favList = []; //private list that holds favorite pokemon

  List<Pokemon> get pokemonList =>
      _pokemonList; //getter that returns list of all pokemon
  PokemonData? get pokemonData =>
      _pokemonData; //getter that returns data of one pokemon or null
  List<FavPokemon> get favList =>
      _favList; //getter that returns list  of favorite pokemon
  bool get isLoading => _isLoading;

  Future<void> loadPokemonData(int pkmnId) async {
    try {
      _isLoading = true;
      notifyListeners();
      final fetched =
          await fetchPokemonData(pkmnId); //fetch pokemon data from api
      _pokemonData = fetched; //set fetched data to pokemonData object
    } catch (err) {
      print('Error while fetching pokemon data: $err');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPokemonList() async {
    try {
      _isLoading = true;
      notifyListeners();
      final fetched = await fetchPokemon(); //fetch all pokemon from api
      _pokemonList
          .addAll(fetched); //add the fetched pokemon to the pokemon list
    } catch (err) {
      print('error while fetching list of pokemon: $err');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFavorites() async {
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        _isLoading = true;
        final fetched =
            await fetchFavorites(); //Fetch users favorites from the database
        for (var favorite in fetched) {
          //If a favorite is in the database twice don't add it to the UI favorite list again (lazy solution)
          if (!_favList.any((duplicate) => duplicate.id == favorite.id)) {
            _favList.add(favorite);
          }
        }
      } catch (err) {
        print("error while fetching favorites $err");
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void removeFavoriteById(id) {
    // Remove favorite from UI list
    _favList.removeWhere((favorite) => favorite.id == id);
    notifyListeners();
  }

//Lazy solution to empy favorite list after logout
  void clearUIfavorites() {
    _favList = [];
    notifyListeners();
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
        Scaffold(
          appBar: AppBar(title: Text("Pokemon info")),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoginDialog(),
                SizedBox(
                  height: 15,
                ),
                Text("Don't have an account? Create one now!"),
                SizedBox(
                  height: 10,
                ),
                RegisterDialog()
              ],
            ),
          ),
        ),
        ListPage(),
        FavoritesPage(),
        SettingsPage(),
      ][selectedIndex],
    );
  }
}
