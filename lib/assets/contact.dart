import 'dart:convert';

class Contact {
  int? id;
  String name;
  String imgPath;
  Map<String, String> numbers;
  String info;
  bool isFavorite;

  Contact({
    this.id,
    required this.name,
    required this.imgPath,
    required this.numbers,
    required this.info,
    this.isFavorite = false,
  });
  //
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'imgPath': imgPath,
  //     'numbers': json.encode(numbers),
  //     'info': info,
  //     'isFavorite': isFavorite ? 1 : 0,
  //   };
  // }
  //
  // factory Contact.fromJSON(Map<String, dynamic> json) {
  //   return Contact(
  //     id: json['id'],
  //     name: json['name'],
  //     imgPath: json['imgPath'],
  //     numbers: Map<String, String>.from(jsonDecode(json['numbers'])),
  //     info: json['info'],
  //     isFavorite: json['isFavorite'] == 1,
  //   );
  // }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imgPath': imgPath,
      'numbers': numbers.toString(),
      'info': info,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      imgPath: map['imgPath'],
      info: map['info'],
      numbers: Map<String, String>.from(eval(map['numbers'])),
      isFavorite: map['isFavorite'] == 1,
    );
  }

  static Map<String, String> eval(String str) {
    // This is a simple implementation. You might want to use a more robust solution.
    str = str.substring(1, str.length - 1);
    var pairs = str.split(', ');
    return Map.fromEntries(pairs.map((pair) {
      var split = pair.split(': ');
      return MapEntry(split[0], split[1]);
    }));
  }
}








//
//
//
//
// class Contact {
//   int? id;
//   String name;
//   String imgPath;
//   Map<String, String> numbers;
//   String info;
//   bool isFavorite;
//
//   Contact({
//     this.id,
//     required this.name,
//     required this.imgPath,
//     required this.numbers,
//     required this.info,
//     this.isFavorite = false,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'imgPath': imgPath,
//       'numbers': numbers.toString(),
//       'info': info,
//       'isFavorite': isFavorite ? 1 : 0,
//     };
//   }
//
//   factory Contact.fromMap(Map<String, dynamic> map) {
//     return Contact(
//       id: map['id'],
//       name: map['name'],
//       imgPath: map['imgPath'],
//       numbers: _parseNumbers(map['numbers']),
//       info: map['info'],
//       isFavorite: map['isFavorite'] == 1,
//     );
//   }
//
//   static Map<String, String> _parseNumbers(String numbersString) {
//     // حذف کاراکترهای اضافی از ابتدا و انتهای رشته
//     String cleaned = numbersString.trim().replaceAll(RegExp(r'^{|}$'), '');
//
//     // تقسیم رشته به جفت‌های کلید-مقدار
//     List<String> pairs = cleaned.split(', ');
//
//     // ایجاد Map از جفت‌های کلید-مقدار
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
// }