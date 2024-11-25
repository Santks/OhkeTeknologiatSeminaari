import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pokemon_info_mobile/main.dart';
import 'package:pokemon_info_mobile/dialogs/data_dialog.dart';

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
                          child: Text('${pokemon.id}  ${pokemon.name}'),
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
                            onPressed: () => print("button pressed"),
                            icon: Icon(Icons.star))
                      ]);
                },
              ));
  }
}
