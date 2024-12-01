import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:pokemon_info_mobile/main.dart';
import 'package:pokemon_info_mobile/dialogs/data_dialog.dart';

String nameFormat(String name) {
  return name[0].toUpperCase() + name.substring(1);
}

deleteFavorite(BuildContext context, id, String key) {
  var user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DatabaseReference removeRef = FirebaseDatabase.instance.ref();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Delete confirmation"),
        content: Text("Are you sure you want to delete this favorite?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                Navigator.of(context).pop();
                var appState = context.read<AppState>();
                appState.removeFavoriteById(id);
                await removeRef.child('users/${user.uid}/$key').remove();
              } catch (e) {
                print("Error deleting favorite: $e");
              }
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatefulWidget {
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final appState = context.read<AppState>();
    if (context.mounted) {
      await appState.loadFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    if (FirebaseAuth.instance.currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text("List of favorites")),
        body: Center(child: Text("Log in to add, view and manage favorites!")),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("List of favorites"),
        ),
        body: appState.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : appState.favList.isEmpty
                ? Text("No favorites yet, add some from the list page!")
                : ListView.builder(
                    itemCount: appState.favList
                        .length, //define list item count to avoid out of range exceptions
                    itemBuilder: (context, index) {
                      final favorite = appState.favList[index];
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.greenAccent, width: 2.0)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text(nameFormat('${favorite.name} '),
                                    style: TextStyle(fontSize: 20)),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    appState.loadPokemonData(favorite.id);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          DataDialog(),
                                    );
                                  },
                                  icon: Icon(Icons.info)),
                              IconButton(
                                onPressed: () => deleteFavorite(
                                    context, favorite.id, favorite.key),
                                // id needs to be passed to remove favorite from the UI
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                              )
                            ]),
                      );
                    },
                  ));
  }
}
