import 'package:flutter/material.dart';

import 'package:pokemon_info_mobile/main.dart';
import 'package:pokemon_info_mobile/pages/favorite_list.dart';
import 'package:provider/provider.dart';

import 'package:pokemon_info_mobile/utils/type_color.dart';

import 'package:fl_chart/fl_chart.dart';

class DataDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    final pokemonData = appState.pokemonData;
    final imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemonData?.id}.png';
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
                ? Center(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Image(
                            image: NetworkImage(imageUrl),
                            width: 150,
                            height: 150,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          ' ${nameFormat(pokemonData.name)}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text('National Pokedex number: ${pokemonData.id}'),
                        SizedBox(height: 10),
                        Text(
                            'Weight: ${pokemonData.weight / 10}kg, Height: ${pokemonData.height / 10}m'),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var type in pokemonData.types)
                              Container(
                                width: 80,
                                margin: EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  color: typeColor(
                                      type['type']['name'].toString()),
                                  border: Border.all(width: 1.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      nameFormat(type['type']['name']),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text("Abilities: "),
                        for (var ability in pokemonData.abilities)
                          Text(ability['is_hidden']
                              ? "${nameFormat(ability['name'])} (hidden ability)"
                              : nameFormat(ability['name'])),
                        Container(
                          height: 315,
                          width: 320,
                          padding: EdgeInsets.all(8.0),
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 255,
                              barTouchData: BarTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 25,
                                  ),
                                ),
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: true),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(show: true),
                              borderData: FlBorderData(show: false),
                              barGroups: pokemonData.stats
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => BarChartGroupData(
                                      x: entry.key,
                                      barRods: [
                                        BarChartRodData(
                                          toY: entry.value['base_stat']
                                              .toDouble(),
                                          color: Colors.greenAccent,
                                          width: 16,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(child: Text('No data available.')),
      ),
    );
  }
}
