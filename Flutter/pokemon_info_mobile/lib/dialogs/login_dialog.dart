import 'package:flutter/material.dart';

class LoginDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
              onPressed: () => showDialog<String>(
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
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Close'),
                              ),
                              TextButton(
                                  onPressed: () => print("button pressed"),
                                  child: Text("Log in"))
                            ],
                          ),
                        ),
                      )),
              child: const Text("Open Login Dialog")),
        ]);
  }
}
