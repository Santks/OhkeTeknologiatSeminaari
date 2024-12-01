import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokemon_info_mobile/main.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  if (FirebaseAuth.instance.currentUser != null) {
                    await FirebaseAuth.instance.signOut();
                    appState.clearUIfavorites();
                    if (context.mounted) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text("Logged out"),
                                content: Text("Logout was successful."),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text("OK"))
                                ],
                              ));
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text("Couldn't log out"),
                              content: Text("Not logged in to any account!"),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text("OK"))
                              ],
                            ));
                  }
                },
                child: Text("Log out")),
          ),
        ],
      ),
    );
  }
}
