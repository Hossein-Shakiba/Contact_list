import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:untitled/assets/contact.dart';
import 'package:untitled/assets/colors.dart';

class EditContactPage extends StatefulWidget {
  final Contact contactToEdit;

  EditContactPage({Key? key, required this.contactToEdit}) : super(key: key);

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _homeController;
  late TextEditingController _workController;
  late TextEditingController _infoController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contactToEdit.name);
    _mobileController = TextEditingController(text: widget.contactToEdit.numbers['mobile'] ?? '');
    _homeController = TextEditingController(text: widget.contactToEdit.numbers['home'] ?? '');
    _workController = TextEditingController(text: widget.contactToEdit.numbers['work'] ?? '');
    _infoController = TextEditingController(text: widget.contactToEdit.info ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Contact'.tr),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveContact,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'.tr),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _mobileController,
              decoration: InputDecoration(labelText: 'Mobile'.tr),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _homeController,
              decoration: InputDecoration(labelText: 'Home'.tr),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _workController,
              decoration: InputDecoration(labelText: 'Work'.tr),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _infoController,
              decoration: InputDecoration(labelText: 'More Info'.tr),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  void _saveContact() {
    final editedContact = Contact(
      imgPath: widget.contactToEdit.imgPath,
      name: _nameController.text,
      numbers: {
        'mobile': _mobileController.text,
        'home': _homeController.text,
        'work': _workController.text,
      },
      info: _infoController.text,
    );
    editedContact.isFavorite = widget.contactToEdit.isFavorite;

    Navigator.pop(context, editedContact);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _homeController.dispose();
    _workController.dispose();
    _infoController.dispose();
    super.dispose();
  }
}