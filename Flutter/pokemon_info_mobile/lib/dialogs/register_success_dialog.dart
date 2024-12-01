import 'package:flutter/material.dart';

class RegisterSuccessDialog {
  static void show(BuildContext context, user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Account Created'),
        content: Text(
            'Your account $user has been successfully created and logged in!'),
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
