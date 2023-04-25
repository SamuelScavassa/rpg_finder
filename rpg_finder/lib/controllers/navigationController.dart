import 'package:flutter/material.dart';

void feed(BuildContext context) {
  Navigator.of(context).popAndPushNamed("/feed");
}

void user(BuildContext context) {
  Navigator.of(context).popAndPushNamed("/user-home");
}

void createCampanha(BuildContext context) {
  Navigator.of(context).popAndPushNamed("/create-campanha");
}
