import 'package:flutter/material.dart';

showSnackbar(BuildContext context, String message, {bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
    backgroundColor: isError ? Colors.red : Theme.of(context).colorScheme.primary,
  ));
}
