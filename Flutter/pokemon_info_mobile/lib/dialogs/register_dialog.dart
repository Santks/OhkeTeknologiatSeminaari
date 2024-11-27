import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:pokemon_info_mobile/dialogs/register_success_dialog.dart';

registerUser(BuildContext context, email, password, passwordCheck) async {
  try {
    if (password != passwordCheck) {
      print("passwords do not match!");
    } else {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null && context.mounted) {
        Navigator.of(context).pop();
        RegisterSuccessDialog.show(context, email);
      }
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('Weak password, please choose a more secure one.');
    } else if (e.code == 'email-already-in-use') {
      print('An account with given email exists, try logging in.');
    }
  } catch (e) {
    print('error: $e');
  }
}

class RegisterDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var email = "";
    var password = "";
    var passwordCheck = "";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => Dialog(
                      child: Padding(
                        padding: EdgeInsets.all(25.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Create an account"),
                            SizedBox(height: 15),
                            TextFormField(
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "Email..."),
                              onChanged: (value) => email = value,
                            ),
                            SizedBox(height: 10),
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
                            SizedBox(height: 10),
                            TextFormField(
                              obscureText: true,
                              autocorrect: false,
                              enableSuggestions: false,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: "Confirm Password...",
                              ),
                              onChanged: (value) => passwordCheck = value,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            ),
                            ElevatedButton(
                                onPressed: () => registerUser(
                                    context, email, password, passwordCheck),
                                child: Text("Create account"))
                          ],
                        ),
                      ),
                    )),
            child: const Text("Open Register Dialog"))
      ],
    );
  }
}
