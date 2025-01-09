import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'assets/colors.dart';
import 'ContactProvider.dart';
import 'package:provider/provider.dart';
import 'ContactInfo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AddContact.dart';
import 'dart:io';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'assets/contact.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  TextEditingController _searchController = TextEditingController();
  List<Contact> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String searchTerm = _searchController.text.toLowerCase();
    setState(() {
      if (searchTerm.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = context.read<ProviderContact>().allcontact
            .where((contact) => contact.name.toLowerCase().contains(searchTerm))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60), child: getAppBar()),
      body: getBody(),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => addContact()));
      },
        child: Icon(Icons.person_add_alt_1),
        backgroundColor: primary,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }

  Widget getAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: true,
      title: Text('Contacts'.tr, style: TextStyle(
          fontSize: 20, color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.w500),),
      leading: IconButton(onPressed: null,
          icon: Text('Sort'.tr,
              style: TextStyle(
                  fontSize: 16,
                  color: primary,
                  fontWeight: FontWeight.w500
              )
          )
      ),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 78,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 48,
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color
                      ),
                      cursorColor: Theme.of(context).textTheme.bodyLarge?.color,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          filled: true,
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          prefixIcon: Icon(Icons.search, color: primary),
                          hintText: 'Search'.tr,
                          hintStyle: TextStyle(color: primary, fontSize: 17)
                      ),
                    ),

                  ),
                ],
              ),
            ),
          ),
          getSectionIcons(),
          getContactList(),
        ],
      ),
    );
  }

  Widget getSectionIcons() {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.access_time_outlined, color: primary, size: 28,),
              SizedBox(width: 20,),
              Text('Recent Added'.tr, style: TextStyle(
                  color: primary, fontSize: 16, fontWeight: FontWeight.w500),)
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Divider(
              thickness: 1,
              color: Theme.of(context).iconTheme.color,
            ),
          )
        ],
      ),
    );
  }

  Widget getContactList() {
    List<Contact> displayList = _searchResults.isNotEmpty
        ? _searchResults
        : context.watch<ProviderContact>().allcontact;

    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: displayList.length,
        itemBuilder: (context, index) {
          var item = displayList[index];
          var favoriteContacts = context.watch<ProviderContact>().favoritecontact;
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
                      child: Text(item.name, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) => contactPage(name: item.name)));
                      },
                    ),
                    trailing: Wrap(
                      spacing: -16,
                      children: [
                        IconButton(
                          onPressed: () {
                            final contactProvider = context.read<ProviderContact>();
                            if (favoriteContacts.contains(item)) {
                              // If the contact is already in favorites, remove it
                              contactProvider.removeFromFavorite(item);
                            } else {
                              // If the contact is not in favorites, add it
                              contactProvider.addToFavorite(item);
                            }
                          },
                          icon: Icon(
                            favoriteContacts.contains(item) ? Icons.star : Icons.star_border,
                            color: favoriteContacts.contains(item) ? Colors.orangeAccent : Theme.of(context).iconTheme.color,
                          ),
                        ),
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
                          SnackBar(content: Text('Could not launch phone call')),
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