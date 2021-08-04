import 'package:flutter/material.dart';

void nextScreen(BuildContext context, String route) {
  Navigator.of(context).pushNamed(route);
}

void replaceScreen(BuildContext context, String route) {
  Navigator.of(context).pushReplacementNamed(route);
}
