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

void navigationEsqueceuSenha(BuildContext context) {
  Navigator.of(context).pushNamed('/esqueceuSenha');
}

void navigationCadastro(BuildContext context) {
  Navigator.of(context).popAndPushNamed("/cadastro");
}

void navigationConvites(BuildContext context) {
  Navigator.of(context).popAndPushNamed("/convites");
}

void navigationAtivas(BuildContext context) {
  Navigator.of(context).popAndPushNamed('/ativas');
}

void navigationParticipando(BuildContext context) {
  Navigator.of(context).popAndPushNamed('/participando');
}

void navigationUpdateUser(BuildContext context) {
  Navigator.of(context).popAndPushNamed('/user-update');
}
