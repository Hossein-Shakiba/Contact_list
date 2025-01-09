import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ContactProvider.dart';
import 'assets/contact.dart';

class ContactListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderContact>(
      builder: (context, contactProvider, child) {
        return ListView.builder(
          itemCount: contactProvider.allcontact.length,
          itemBuilder: (context, index) {
            Contact contact = contactProvider.allcontact[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: contact.imgPath.isNotEmpty
                    ? AssetImage(contact.imgPath)
                    : null,
                child: contact.imgPath.isEmpty
                    ? Text(contact.name[0].toUpperCase())
                    : null,
              ),
              title: Text(contact.name),
              subtitle: Text(contact.numbers['mob'] ?? ''),
              onTap: () {
                // Handle tap on contact
                // You can navigate to a detail view here
              },
            );
          },
        );
      },
    );
  }
}