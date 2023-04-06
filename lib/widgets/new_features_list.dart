import 'package:flutter/material.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _newFeatures.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.new_releases, color: Colors.blue),
          title: Text(_newFeatures[index]),
        );
      },
    );
  }
}
