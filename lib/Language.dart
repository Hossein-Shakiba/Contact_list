import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'assets/colors.dart';
import 'assets/LanguageList.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String selectedLanguage = 'English';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile picture or icon
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color:Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Icon(Icons.language,color: Theme.of(context).iconTheme.color,size: 80,),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Contact details
          Center(
            child: Text(
              "Language".tr,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ),
          SizedBox(height: 20),
          selectLanguage(),
        ],
      ),
    );
  }

  Widget selectLanguage() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: Language.values.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            // color: textfieldColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: ClipOval(
              child: Language.values[index].image.image(
                width: 39,
                height: 39,
              ),
            ),
            title: Text(
              Language.values[index].text,
              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            trailing: Radio<String>(
              value: Language.values[index].value.toString(),
              groupValue: selectedLanguage,
              onChanged: (String? value) {
                setState(() {
                  selectedLanguage = value!;
                  Locale newLocale = Language.values[index].value;
                  Get.updateLocale(newLocale); // تغییر زبان برنامه
                });
              },
              activeColor: primary,
            ),
            onTap: () {
              setState(() {
                selectedLanguage = Language.values[index].value.toString();
                Get.updateLocale(Language.values[index].value); // تغییر زبان برنامه
              });
            },
          ),
        );
      },
    );
  }

// Widget selectLanguage(){
//   // return ListView.separated(
//   //   shrinkWrap: true,
//   //   itemBuilder: (ctx,i){
//   //   return ListTile(
//   //     onTap: (){
//   //       print("${Language.values[i].text}");
//   //     },
//   //     title: Text(Language.values[i].text,style: TextStyle(color: white),),
//   //     leading: ClipOval(
//   //       child: Language.values[i].image.image(
//   //         width: 39,
//   //         height: 39,
//   //       ),
//   //     ),
//   //     trailing: Icon(
//   //       Icons.check_circle_rounded,
//   //       color: primary,
//   //     ),
//   //     shape: RoundedRectangleBorder(
//   //       borderRadius: BorderRadius.circular(10),
//   //       side: BorderSide(color: primary,width: 1.5)
//   //     ),
//   //     textColor: primary.withOpacity(0.05),
//   //   );
//   // }, separatorBuilder: (ctx,i){
//   //     return Container();
//   // }, itemCount: Language.values.length
//   // );
// }
}
