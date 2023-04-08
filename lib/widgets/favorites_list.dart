import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/globals.dart';
import 'package:flutter_chat/models/customer.dart';
import 'package:flutter_chat/repositories/customer_repository.dart';
import 'package:flutter_chat/services/firestore_helper.dart';
import 'package:flutter_chat/widgets/chat.dart';

class FavoritesList extends StatefulWidget {
  const FavoritesList({Key? key}) : super(key: key);

  @override
  State<FavoritesList> createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  List<Customer> _favorites = [];

  Future<void> _loadFavorites() async {
    List<String> favoriteIds =
        await CustomerRepository().getFavorites(myUser.id);
    List<Customer> favorites = [];
    for (String id in favoriteIds) {
      DocumentSnapshot snapshot =
          await FirestoreHelper().firebaseCustomers.doc(id).get();
      favorites.add(Customer(snapshot));
    }
    setState(() {
      _favorites = favorites;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _favorites.isEmpty
          ? const Center(
              child: Text('Aucun favoris'),
            )
          : ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                Customer customer = _favorites[index];
                return Card(
                  elevation: 5,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Chat(customer: customer);
                      }));
                    },
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(customer.avatar!),
                    ),
                    title: Text(customer.fullName),
                    subtitle: Text(customer.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () async {
                        await CustomerRepository()
                            .removeToFavorites(myUser.id, customer.id);
                        _loadFavorites();
                        setState(() {
                          _favorites.remove(customer);
                          myUser.favorites!.remove(customer.id);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
