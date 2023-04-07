import 'package:flutter/material.dart';
import 'package:flutter_chat/globals.dart';

class NewFeaturesList extends StatefulWidget {
  const NewFeaturesList({Key? key}) : super(key: key);

  @override
  State<NewFeaturesList> createState() => _NewFeaturesListState();
}

class _NewFeaturesListState extends State<NewFeaturesList> {
  final List<String> _newFeatures = [
    "Notification lors de la réception",
    "Son lors de l'envoi d'un message",
    "Possibilité d'ajouter un contact en favoris",
    "Créer un groupe",
    "Mot de passe oublié",
    "Connexion avec Google, Facebook, etc.",
    "La vérificatoin de correspondance de mot de passe lors de la création d'un compte",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _newFeatures.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.new_releases, color: defaultColor),
          title: Text(_newFeatures[index]),
        );
      },
    );
  }
}
