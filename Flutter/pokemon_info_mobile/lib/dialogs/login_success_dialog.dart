import 'package:flutter/material.dart';

class LoginSuccessDialog {
  static void show(BuildContext context, email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login successful!'),
        content: Text('Logged in to account $email'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
