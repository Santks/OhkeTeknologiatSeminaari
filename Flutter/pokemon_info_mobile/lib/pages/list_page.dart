import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_info_mobile/pages/favorite_list.dart';
import 'package:provider/provider.dart';

import 'package:pokemon_info_mobile/main.dart';
import 'package:pokemon_info_mobile/dialogs/data_dialog.dart';
import 'package:pokemon_info_mobile/utils/pokemon.dart';

addFavorite(id, name, url) async {
  var user = FirebaseAuth.instance.currentUser;
  DatabaseReference addFavorite =
      FirebaseDatabase.instance.ref('users/${user!.uid}');
  DatabaseReference newFavorite = addFavorite.push();
  newFavorite.set({'pkmnId': id, 'name': name, 'url': url});
}

class ListPage extends StatefulWidget {
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  TextEditingController _searchController = TextEditingController();
  List<Pokemon> pokemon = [];
  List<Pokemon> filtered = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      filterPokemons();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var appState = context.watch<AppState>();
    pokemon = appState.pokemonList;
    filtered = pokemon;
  }

  void filterPokemons() {
    setState(() {
      if (_searchController.text.isEmpty) {
        filtered = pokemon;
      } else {
        filtered = pokemon
            .where((pkmn) => pkmn.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Scaffold(
        appBar: AppBar(title: Text("Pokemon list")),
        body: appState.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Pokemon...',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final pokemon = filtered[index];
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.greenAccent, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text(nameFormat('${pokemon.name} '),
                                    style: TextStyle(fontSize: 20)),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    appState.loadPokemonData(pokemon.id);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          DataDialog(),
                                    );
                                  },
                                  icon: Icon(Icons.info)),
                              IconButton(
                                onPressed: () {
                                  if (FirebaseAuth.instance.currentUser !=
                                      null) {
                                    addFavorite(pokemon.id, pokemon.name,
                                        pokemon.pkmnLink);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${pokemon.name} added to favorites!'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Log in to add favorites!'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(
                                  appState.favList
                                          .any((fav) => fav.id == pokemon.id)
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.yellow,
                                ),
                              )
                            ]),
                      );
                    },
                  ),
                )
              ]));
  }
}
