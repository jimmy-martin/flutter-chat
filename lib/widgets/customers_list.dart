import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/globals.dart';
import 'package:flutter_chat/models/customer.dart';
import 'package:flutter_chat/services/firestore_helper.dart';

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
                    // TODO: Ouvrir une nouvelle page de chat
                  },
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(customer.avatar!),
                  ),
                  title: Text(customer.fullName),
                  subtitle: Text(customer.email),
                ),
              );
            },
          );
        });
  }
}
