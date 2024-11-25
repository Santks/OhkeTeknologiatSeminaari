import 'package:flutter/material.dart';

class RegisterDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            ),
                            ElevatedButton(
                                onPressed: () => print("button pressed"),
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
