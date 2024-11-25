import 'package:flutter/material.dart';

import 'package:pokemon_info_mobile/main.dart';
import 'package:provider/provider.dart';

class DataDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    final pokemonData = appState.pokemonData;
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Pokemon info"),
        ),
        body: appState.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : pokemonData != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pokemon: ${pokemonData.name}'),
                      Text('ID: ${pokemonData.id}'),
                      Text('Weight ${pokemonData.weight / 10}kg'),
                      Text('Weight ${pokemonData.height / 10}m'),
                      Text("Abilities: "),
                      for (var ability in pokemonData.abilities)
                        Text(ability['is_hidden']
                            ? "${ability['name']} (hidden ability)"
                            : ability['name']),

                      for (var type in pokemonData.types)
                        Text(type['type']['name']),

                      for (var stat in pokemonData.stats)
                        Text("${stat['name']} ${stat['base_stat']}")
                      // Lisää muita tietoja Pokémonista
                    ],
                  )
                : Center(child: Text('No data available.')),
      ),
    );
  }
}
