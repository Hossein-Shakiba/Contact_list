// import 'package:url_launcher/url_launcher.dart';

import 'contact.dart';


// TODO: read from DataBase
List<Contact> dataset = [
  Contact(imgPath:'',name: "ali", numbers: {"mob": "0915" ,"home": "051", "work": "051"},info:''),
  Contact(imgPath:'',name: "reza", numbers: {"home": "071", "work": "081", "mob": "0917"},info:''),
  Contact(imgPath:'',name: "sara", numbers: {"home": "021", "work": "021", "mob": "0912"},info:''),
  Contact(imgPath:'',name: "zah", numbers: {"home": "051", "work": "051", "mob": "0915"},info:''),
  Contact(imgPath:'',name: "omid", numbers: {"home": "011", "work": "011", "mob": "0911"},info:''),

];

Contact? findContactByName(String name) {
  return dataset.firstWhere((c) => c.name == name,);
}

// List<contact> favcontacts=[];
//
// _makingPhoneCall() async {
//   var url = Uri.parse("tel:9776765434");
//   await launchUrl(url);
// }
// _sendingMails() async {
//   var url = Uri.parse("mailto:feedback@geeksforgeeks.org");
//
//   await launchUrl(url);
//
// }
// _sendingSMS() async {
//   var url = Uri.parse("sms:966738292");
//   await launchUrl(url);
//
// }
