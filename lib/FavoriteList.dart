import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'assets/colors.dart';
import 'ContactProvider.dart';
import 'package:provider/provider.dart';
import 'ContactInfo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'EditContact.dart';
import 'dart:io';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';


class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _ContactPageState();
}

class _ContactPageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    // final favoriteContacts = Provider.of<ProviderContact>(context);
    final favoriteContacts = context.watch<ProviderContact>();
    final Contacts = favoriteContacts.favoritecontact;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar:
          PreferredSize(preferredSize: Size.fromHeight(60), child: getAppBar()),
      body: getBody(Contacts),
    );
  }

  Widget getAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: true,
      title: Text(
        'Favorite'.tr,
        style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500),
      ),
      leading: IconButton(
          onPressed: null,
          icon: Text('Edit'.tr,
              style: TextStyle(
                  fontSize: 16, color: primary, fontWeight: FontWeight.w500))),
      actions: [
        IconButton(
            onPressed: null,
            icon: Icon(
              Icons.edit_note,
              color: primary,
            ))
      ],
    );
  }

  Widget getBody(final Contacts) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 80,
            decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 48,
                    child: TextField(
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color),
                      cursorColor: Theme.of(context).textTheme.bodyLarge?.color,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              // borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(50)),
                          filled: true,
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          prefixIcon: Icon(
                            Icons.search,
                            color: primary,
                          ),
                          hintText: 'Search'.tr,
                          hintStyle: TextStyle(color: primary, fontSize: 17)
                      ),
                      onChanged: (value){

                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          getFavoriteList(Contacts)
        ],
      ),
    );
  }

  Widget getFavoriteList(final Contacts) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: Contacts.length,
        itemBuilder: (context, index) {
          var item = Contacts[index];
          return Column(
            children: [
              Dismissible(
                key: UniqueKey(),
                child: Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) => contactPage(name: item.name)));
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: RandomColor.getColorObject(Options(
                          colorType: ColorType.random,
                          luminosity: Theme.of(context).brightness == Brightness.dark
                              ? Luminosity.light
                              : Luminosity.dark,
                        )),
                        backgroundImage: item.imgPath.isNotEmpty ? FileImage(File(item.imgPath)) : null,
                        child: item.imgPath.isEmpty
                            ? Text(
                          '${item.name[0].toString().toUpperCase()}',
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        )
                            : null,
                      ),
                    ),
                    title: GestureDetector(
                      child: Text(item.name,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.color)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => contactPage(name: item.name)));
                      },
                    ),
                    trailing: Wrap(
                      spacing: -16,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditContactPage(contactToEdit: Contacts[index]!),
                              ),
                            ).then((editedContact) {
                              if (editedContact != null) {
                                setState(() {
                                  Contacts[index] = editedContact;
                                });
                                // Update the contact in the provider
                                context.read<ProviderContact>().updateContact(editedContact);
                              }
                            });
                          },
                          icon: Icon(Icons.edit,
                              color: Theme.of(context).iconTheme.color),
                        ),
                        IconButton(
                            onPressed: () {
                              final favoriteContacts = Provider.of<ProviderContact>(context, listen: false);
                              final removedContact = Contacts[index];
                              favoriteContacts.removeFromFavorite(removedContact);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${removedContact.name} removed from favorites"),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      favoriteContacts.addToFavorite(removedContact);
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.delete,color: Theme.of(context).iconTheme.color))
                      ],
                    ),
                  ),
                ),
                background: Container(
                  color: Colors.green,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(Icons.call, color: Colors.white),
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.blue,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.email, color: Colors.white),
                    ),
                  ),
                ),
                onDismissed: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    // Call the mobile number
                    final phoneNumber = item.numbers['mob'];
                    if (phoneNumber != null) {
                      final url = Uri.parse('tel:$phoneNumber');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Could not launch phone call')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No mobile number available')),
                      );
                    }
                  } else if (direction == DismissDirection.endToStart) {
                    // Send SMS to the mobile number
                    final phoneNumber = item.numbers['mob'];
                    if (phoneNumber != null) {
                      final url = Uri.parse('sms:$phoneNumber');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not launch SMS')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No mobile number available')),
                      );
                    }
                  }
                  // Don't remove the contact from the list
                  setState(() {});
                },
              ),
              Divider(
                color: Theme.of(context).iconTheme.color,
                height: 1,
              ),
            ],
          );
        },
      ),
    );
  }
}
