import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:pokemon_info_mobile/dialogs/login_success_dialog.dart';

logUserIn(BuildContext context, email, password) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if (credential.user != null && context.mounted) {
      Navigator.of(context).pop();
      LoginSuccessDialog.show(context, email);
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('no account found with that email');
    } else if (e.code == 'wrong-password') {
      print('wrong password provided');
    }
  } catch (e) {
    print('error: $e');
  }
}

class LoginDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var email = "";
    var password = "";
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
              onPressed: () => FirebaseAuth.instance.currentUser != null
                  ? showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text('Already logged in!'),
                            content: Text(
                                'Log out in the settings page before trying to log into another account.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ))
                  : showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Log in to pokemon info."),
                                  SizedBox(height: 15),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: "Email..."),
                                    onChanged: (value) => email = value,
                                  ),
                                  SizedBox(height: 15),
                                  TextFormField(
                                    obscureText: true,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: "Password...",
                                    ),
                                    onChanged: (value) => password = value,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Close'),
                                  ),
                                  TextButton(
                                      onPressed: () =>
                                          logUserIn(context, email, password),
                                      child: Text("Log in"))
                                ],
                              ),
                            ),
                          )),
              child: const Text("Open Login Dialog")),
        ]);
  }
}
