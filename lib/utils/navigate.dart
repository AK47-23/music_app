import 'package:flutter/material.dart';

void normalNavigate(BuildContext context, Widget destination) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => destination,
  ));
}
