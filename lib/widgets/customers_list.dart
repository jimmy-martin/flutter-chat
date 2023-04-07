import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/globals.dart';
import 'package:flutter_chat/models/customer.dart';
import 'package:flutter_chat/repositories/customer_repository.dart';
import 'package:flutter_chat/services/firestore_helper.dart';
import 'package:flutter_chat/widgets/chat.dart';

class CustomersList extends StatefulWidget {
  const CustomersList({Key? key}) : super(key: key);

  @override
  State<CustomersList> createState() => _CustomersListState();
}

class _CustomersListState extends State<CustomersList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper().firebaseCustomers.snapshots(),
        builder: (context, snapshot) {
          List documents = snapshot.data?.docs ?? [];

          if (documents.isEmpty) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              Customer customer = Customer(documents[index]);

              if (customer.id == myUser.id) {
                return Container();
              }

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
                  trailing: myUser.favorites!.contains(customer.id)
                      ? removeFavoriteButton(customer)
                      : addFavoriteButton(customer),
                ),
              );
            },
          );
        });
  }

  Widget addFavoriteButton(Customer customer) {
    return IconButton(
      icon: const Icon(Icons.favorite_border),
      onPressed: () async {
        await CustomerRepository().addToFavorites(myUser.id, customer.id);
        setState(() {
          myUser.favorites!.add(customer.id);
        });
      },
    );
  }

  Widget removeFavoriteButton(Customer customer) {
    return IconButton(
      icon: const Icon(
        Icons.favorite,
        color: Colors.pink,
      ),
      onPressed: () async {
        await CustomerRepository().removeToFavorites(myUser.id, customer.id);
        setState(() {
          myUser.favorites!.remove(customer.id);
        });
      },
    );
  }
}
