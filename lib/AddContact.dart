import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'ContactProvider.dart';
import 'assets/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'assets/contact.dart';

class addContact extends StatefulWidget {
  const addContact({super.key});

  @override
  State<addContact> createState() => _addContactState();
}

class _addContactState extends State<addContact> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _homeController = TextEditingController();
  final TextEditingController _workController = TextEditingController();
  final TextEditingController _moreInfoController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _homeController.dispose();
    _workController.dispose();
    _moreInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                            child: Icon(Icons.add_a_photo, size: 20, color: Theme.of(context).iconTheme.color),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 18),
                decoration: InputDecoration(
                  label: Text('Full Name'.tr),
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                  prefixIconColor: Theme.of(context).iconTheme.color,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _mobileController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]+"))],
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 18),
                decoration: InputDecoration(
                  label: Text('Mobile Number'.tr),
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_android),
                  prefixIconColor: Theme.of(context).iconTheme.color,
                ),
                maxLength: 11,
              ),
              SizedBox(height: 5),
              TextField(
                controller: _homeController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]+"))],
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 18),
                decoration: InputDecoration(
                  label: Text('Home Number'.tr),
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                  prefixIconColor: Theme.of(context).iconTheme.color,
                ),
                maxLength: 11,
              ),
              SizedBox(height: 5),
              TextField(
                controller: _workController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]+"))],
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 18),
                decoration: InputDecoration(
                  label: Text('Work Number'.tr),
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                  prefixIconColor: Theme.of(context).iconTheme.color,
                ),
                maxLength: 11,
              ),
              SizedBox(height: 5),
              TextField(
                controller: _moreInfoController,
                decoration: InputDecoration(
                  label: Text('More Info'.tr),
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    context.read<ProviderContact>().addToList(
                      Contact(
                        imgPath: _image?.path ?? "",
                        name: _nameController.text,
                        numbers: {
                          'mobile': _mobileController.text,
                          'home': _homeController.text,
                          'work': _workController.text,
                        },
                        info: _moreInfoController.text
                      ),
                    );
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.add_task, size: 30,color: Theme.of(context).iconTheme.color,),
                  label: Text('Add'.tr, style: TextStyle(fontSize: 20,color: Theme.of(context).iconTheme.color)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}