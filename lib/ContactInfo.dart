import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:untitled/assets/utils.dart';
import 'assets/colors.dart';
import 'ContactProvider.dart';
import 'package:provider/provider.dart';
import 'assets/contact.dart';
import 'package:url_launcher/url_launcher.dart';
import 'EditContact.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class contactPage extends StatefulWidget {
  final String name;

  const contactPage({Key? key, required this.name}) : super(key: key);

  @override
  State<contactPage> createState() => _contactPageState();
}

class _contactPageState extends State<contactPage> {
  Contact? currentContact;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      // Update the contact's image path
      if (currentContact != null) {
        currentContact!.imgPath = pickedFile.path;
        // Update the contact in the provider
        context.read<ProviderContact>().updateContact(currentContact!);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    currentContact = findContactByName(widget.name);
    if (currentContact != null && currentContact!.imgPath.isNotEmpty) {
      _image = File(currentContact!.imgPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    var favoriteContacts = context.watch<ProviderContact>().favoritecontact;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile picture or icon
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).iconTheme.color,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.person, size: 50, color: Theme.of(context).scaffoldBackgroundColor)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: ClipOval(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: primary,
                          child: Icon(Icons.edit, size: 20, color: Theme.of(context).iconTheme.color),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),

            // Contact details
            Center(
              child: Text(
                widget.name,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            ),
            SizedBox(height: 20),

            // Contact numbers list
            Text('Contact Numbers'.tr,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: primary)),
            SizedBox(height: 10),
                currentContact != null
                    ? Expanded(
                        child: ListView(
                          children: [
                            // Mobile number (if available)
                            if (currentContact!.numbers['mob'] != null && currentContact!.numbers['mob']!.isNotEmpty)
                              ListTile(
                                leading: Icon(Icons.phone_android, color: primary),
                                title: Text('Mobile'.tr,
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyLarge?.color)),
                                subtitle: Text(currentContact!.numbers['mob']!,
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyLarge?.color)),
                                trailing: _buildTrailingIcons(currentContact!.numbers['mob']!),
                              ),
                            // Home number (if available)
                            if (currentContact!.numbers['home'] != null && currentContact!.numbers['home']!.isNotEmpty)
                              ListTile(
                                leading: Icon(Icons.home, color: primary),
                                title: Text('Home'.tr,
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyLarge?.color)),
                                subtitle: Text(currentContact!.numbers['home']!,
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyLarge?.color)),
                                trailing: _buildTrailingIcons(currentContact!.numbers['home']!),
                              ),
                            // Work number (if available)
                            if (currentContact!.numbers['work'] != null && currentContact!.numbers['work']!.isNotEmpty)
                              ListTile(
                                leading: Icon(Icons.work, color: primary),
                                title: Text('Work'.tr,
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyLarge?.color)),
                                subtitle: Text(currentContact!.numbers['work']!,
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyLarge?.color)),
                                trailing: _buildTrailingIcons(currentContact!.numbers['work']!),
                              ),
                            // Other numbers
                            ...currentContact!.numbers.entries
                                .where((entry) => entry.key != 'mob' && entry.key != 'home' && entry.key != 'work' && entry.value.isNotEmpty)
                                .map((entry) {
                              return ListTile(
                                leading: Icon(Icons.phone, color: primary),
                                title: Text(entry.key,
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyLarge?.color)),
                                subtitle: Text(entry.value,
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyLarge?.color)),
                                trailing: _buildTrailingIcons(entry.value),
                              );
                            }).toList(),
                            // Additional info (if available)
                            if (currentContact!.info != null && currentContact!.info!.isNotEmpty)
                              ListTile(
                                leading: Icon(Icons.info_outline, color: primary),
                                title: Text('More Info'.tr,
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyLarge?.color)),
                                subtitle: Text(currentContact!.info!,
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyLarge?.color)),
                              ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          "No contact information available",
                          style: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                      ),

            // Action icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.edit,
                      color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditContactPage(contactToEdit: currentContact!),
                      ),
                    ).then((editedContact) {
                      if (editedContact != null) {
                        setState(() {
                          currentContact = editedContact;
                        });
                        // Update the contact in the provider
                        context.read<ProviderContact>().updateContact(editedContact);
                      }
                    });
                  },
                ),
                IconButton(
                  onPressed: () {
                    final contactProvider = context.read<ProviderContact>();
                    if (favoriteContacts.contains(currentContact)) {
                      // If the contact is already in favorites, remove it
                      contactProvider.removeFromFavorite(currentContact!);
                    } else {
                      // If the contact is not in favorites, add it
                      contactProvider.addToFavorite(currentContact!);
                    }
                  },
                  icon: Icon(
                    favoriteContacts.contains(currentContact)
                        ? Icons.star
                        : Icons.star_border,
                    color: favoriteContacts.contains(currentContact)
                        ? Colors.orangeAccent
                        : Theme.of(context).iconTheme.color,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.share,
                      color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    // Implement SMS functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete,
                      color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    // Show a confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          title: Text('Delete Contact'.tr,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color)),
                          content: Text(
                              'Are you sure you want to delete this contact?'.tr,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color)),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Cancel'.tr,
                                  style: TextStyle(color: primary)),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                            TextButton(
                              child: Text('Delete'.tr,
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                // Get the ProviderContact instance
                                var providerContact =
                                    Provider.of<ProviderContact>(context,
                                        listen: false);

                                // Remove the contact from both all contacts and favorite contacts
                                if (currentContact != null) {
                                  providerContact
                                      .removeFromList(currentContact!);
                                  if (favoriteContacts
                                      .contains(currentContact)) {
                                    providerContact
                                        .removeFromFavorite(currentContact!);
                                  }
                                }

                                // Close the dialog
                                Navigator.of(context).pop();

                                // Go back to the all contacts page
                                Navigator.of(context).pop();

                                // Show a snackbar to confirm deletion
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "${currentContact!.name} has been deleted"),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      onPressed: () {
                                        // Add the contact back if user wants to undo
                                        providerContact
                                            .addToList(currentContact!);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingIcons(String phoneNumber) {
  return Wrap(
    spacing: -16,
    children: phoneNumber.startsWith("09")
        ? [
            IconButton(
              onPressed: () async {
                final url = Uri(scheme: 'tel', path: phoneNumber);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch phone call')),
                  );
                }
              },
              icon: Icon(Icons.call, color: Theme.of(context).iconTheme.color),
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Messaging $phoneNumber')),
                );
              },
              icon: Icon(Icons.email, color: Theme.of(context).iconTheme.color),
            ),
            IconButton(
              onPressed: () async {
                final url = Uri(scheme: 'sms', path: phoneNumber);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch SMS')),
                  );
                }
              },
              icon: Icon(Icons.video_call, color: Theme.of(context).iconTheme.color),
            ),
          ]
        : [
            IconButton(
              onPressed: () async {
                final url = Uri(scheme: 'tel', path: phoneNumber);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch phone call')),
                  );
                }
              },
              icon: Icon(Icons.call, color: Theme.of(context).iconTheme.color),
            ),
          ],
  );
}
}
