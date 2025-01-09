import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'assets/contact.dart';
import 'assets/utils.dart';
import 'package:flutter/foundation.dart';
import 'database_helper.dart';

class ProviderContact with ChangeNotifier {
  List<Contact> allcontact = [];
  List<Contact> favoritecontact = [];

  late Database _database;

  ProviderContact() {
    _initializeContacts();
  }

  Future<void> _initializeContacts() async {
    // allcontact = await DatabaseHelper.instance.getContacts();

    if (allcontact.isEmpty) {
      allcontact = List.from(dataset);
      // Save these contacts to the database
      for (var contact in allcontact) {
        await DatabaseHelper.instance.insertContact(contact);
      }
    }
    notifyListeners();
  }

  Future<void> addToList(Contact newContact) async {
    allcontact.add(newContact);
    // await DatabaseHelper.instance.insertContact(newContact);
    notifyListeners();
  }

  Future<void> removeFromList(Contact contactToRemove) async{
    allcontact.remove(contactToRemove);
    // await DatabaseHelper.instance.deleteContact(contactToRemove);
    notifyListeners();
  }

  Future<void> addToFavorite(Contact newFavorite) async{
    favoritecontact.add(newFavorite);
    newFavorite.isFavorite = true;
    notifyListeners();
  }

  Future<void> removeFromFavorite(Contact removeAsFavorite) async{
    favoritecontact.remove(removeAsFavorite);
    removeAsFavorite.isFavorite = false;
    notifyListeners();
  }

  void updateContact(Contact updatedContact) {
    int index = allcontact.indexWhere((c) => c.name == updatedContact.name);
    if (index != -1) {
      allcontact[index] = updatedContact;

      // Update in favorite contacts if it exists there
      int favIndex = favoritecontact.indexWhere((c) => c.name == updatedContact.name);
      if (favIndex != -1) {
        favoritecontact[favIndex] = updatedContact;
      }

      notifyListeners();
    }
  }
}







//
//
//
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'dart:convert';
//
// import 'assets/contact.dart';
// import 'assets/utils.dart';
// import 'package:flutter/foundation.dart';
// import 'database_helper.dart';
//
// class ProviderContact with ChangeNotifier {
//   List<Contact> allcontact = [];
//   List<Contact> favoritecontact = [];
//
//   late Database _database;
//
//   ProviderContact() {
//     _initializeContacts();
//   }
//
//   Future<void> _initializeContacts() async {
//     _database = await openDatabase(
//       join(await getDatabasesPath(), 'contacts.db'),
//       onCreate: (db, version) {
//         return db.execute(
//             'CREATE TABLE IF NOT EXISTS contacts (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, imgPath TEXT, numbers TEXT, info TEXT, isFavorite INTEGER)');
//       },
//       version: 1,
//     );
//     await _loadContact();
//   }
//
//   Future<void> _loadContact() async {
//     final List<Map<String, dynamic>> maps = await _database.query('contacts');
//
//     allcontact = List.generate(maps.length, (i) {
//       return Contact(
//         id: maps[i]['id'],
//         name: maps[i]['name'],
//         imgPath: maps[i]['imgPath'],
//         numbers: _parseNumbers(maps[i]['numbers']),
//         info: maps[i]['info'],
//         isFavorite: maps[i]['isFavorite'] == 1,
//       );
//     });
//
//     favoritecontact = allcontact.where((contact) => contact.isFavorite).toList();
//     notifyListeners();
//   }
//
//   Map<String, String> _parseNumbers(String numbersString) {
//     String cleaned = numbersString.trim().replaceAll(RegExp(r'^{|}$'), '');
//
//     List<String> pairs = cleaned.split(', ');
//     Map<String, String> result = {};
//     for (String pair in pairs) {
//       List<String> keyValue = pair.split(': ');
//       if (keyValue.length == 2) {
//         String key = keyValue[0].trim().replaceAll(RegExp(r'^"|"$'), '');
//         String value = keyValue[1].trim().replaceAll(RegExp(r'^"|"$'), '');
//         result[key] = value;
//       }
//     }
//
//     return result;
//   }
//
//
//   Future<void> addToList(Contact newContact) async {
//     final id = await _database.insert(
//       'contacts',
//       newContact.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     newContact.id = id;
//     allcontact.add(newContact);
//     notifyListeners();
//   }
//
//
//   Future<void> removeFromList(Contact contactToRemove) async {
//     await _database.delete(
//       'contacts',
//       where: 'id = ?',
//       whereArgs: [contactToRemove.id],
//     );
//     allcontact.remove(contactToRemove);
//     favoritecontact.remove(contactToRemove);
//     notifyListeners();
//   }
//
//   Future<void> addToFavorite(Contact newFavorite) async {
//     newFavorite.isFavorite = true;
//     await _database.update(
//       'contacts',
//       {'isFavorite': 1},
//       where: 'id = ?',
//       whereArgs: [newFavorite.id],
//     );
//     favoritecontact.add(newFavorite);
//     notifyListeners();
//   }
//
//   Future<void> removeFromFavorite(Contact removeAsFavorite) async {
//     removeAsFavorite.isFavorite = false;
//     await _database.update(
//       'contacts',
//       {'isFavorite': 0},
//       where: 'id = ?',
//       whereArgs: [removeAsFavorite.id],
//     );
//     favoritecontact.remove(removeAsFavorite);
//     notifyListeners();
//   }
//
//   Future<void> updateContact(Contact updatedContact) async {
//     await _database.update(
//       'contacts',
//       updatedContact.toMap(),
//       where: 'id = ?',
//       whereArgs: [updatedContact.id],
//     );
//
//     int index = allcontact.indexWhere((c) => c.id == updatedContact.id);
//     if (index != -1) {
//       allcontact[index] = updatedContact;
//
//       // Update in favorite contacts if it exists there
//       int favIndex = favoritecontact.indexWhere((c) => c.id == updatedContact.id);
//       if (favIndex != -1) {
//         if (updatedContact.isFavorite) {
//           favoritecontact[favIndex] = updatedContact;
//         } else {
//           favoritecontact.removeAt(favIndex);
//         }
//       } else if (updatedContact.isFavorite) {
//         favoritecontact.add(updatedContact);
//       }
//
//       notifyListeners();
//     }
//   }
// }