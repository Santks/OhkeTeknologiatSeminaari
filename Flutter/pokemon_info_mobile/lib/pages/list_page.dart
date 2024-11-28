import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_info_mobile/pages/favorite_list.dart';
import 'package:provider/provider.dart';

import 'package:pokemon_info_mobile/main.dart';
import 'package:pokemon_info_mobile/dialogs/data_dialog.dart';

addFavorite(id, name, url) async {
  var user = FirebaseAuth.instance.currentUser;
  DatabaseReference addFavorite =
      FirebaseDatabase.instance.ref('users/${user!.uid}');
  DatabaseReference newFavorite = addFavorite.push();
  newFavorite.set({'pkmnId': id, 'name': name, 'url': url});
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
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(nameFormat('${pokemon.name} ')),
                        ),
                        IconButton(
                            onPressed: () async {
                              appState.loadPokemonData(pokemon.id);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => DataDialog(),
                              );
                            },
                            icon: Icon(Icons.info)),
                        IconButton(
                            onPressed: () => addFavorite(
                                pokemon.id, pokemon.name, pokemon.pkmnLink),
                            icon: Icon(Icons.star))
                      ]);
                },
              ));
  }
}
