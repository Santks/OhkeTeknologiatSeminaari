import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List of favourites")),
      body: FirebaseAuth.instance.currentUser != null
          ? Text("add listview here")
          : Text("Log in to add and manage favorites!"),
    );
  }
}
