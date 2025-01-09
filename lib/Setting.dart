import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'assets/colors.dart';
import 'package:provider/provider.dart';
import 'Theme_provider.dart';
import 'font_provider.dart';
import 'assets/setting_json.dart';
import 'History.dart';
import 'Language.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight(60), child: getAppBar()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                // backgroundImage: AssetImage('country/profile.png'), // Add your image
                backgroundColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20,),
            Text("Hossein Shakiba",style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w500,
            ),),
            SizedBox(height: 2),
            Text("09152149219",style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w500
            ),),
            Align(
              widthFactor: 5.8,
              alignment: Alignment.centerLeft,
              child: Text(
                'Settings'.tr,
                style: TextStyle(color: primary, fontSize: 18),
              ),
            ),
            getSectionOne(),
            SizedBox(height: 10,),
            Align(
              widthFactor: 10.2,
              alignment: Alignment.centerLeft,
              child: Text(
                'Help'.tr,
                style: TextStyle(color: primary, fontSize: 18),
              ),
            ),
            getSectionTwo()
          ],
        ),
      ),
    );
  }
  getAppBar() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        'Settings'.tr,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Toggle the theme
            themeProvider.setTheme(
              themeProvider.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
            );
          },
          icon: Icon(
            themeProvider.themeMode == ThemeMode.dark ? Icons.wb_sunny : CupertinoIcons.moon_stars_fill,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ],
    );
  }


  Widget getSectionOne(){
    final fontProvider = Provider.of<FontProvider>(context);
    return Column(
      children: List.generate(setting_section_one.length, (index){
        return GestureDetector(
          onTap: () {
            if (setting_section_one[index]['text'].toString().tr == "Font") {
              _showFontDropdown(fontProvider);
            } else {
              _navigateToPage(setting_section_one[index]['text'.tr]);
            }
          },
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left:10,right: 10,top: 8,bottom: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color:setting_section_one[index]['color'],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Icon(setting_section_one[index]['icon'],color: Theme.of(context).iconTheme.color,size: 20,),
                            ),
                          ),
                          SizedBox(width: 12,),
                          Text(setting_section_one[index]['text'].toString().tr,style: TextStyle(
                              fontSize: 16,color: Theme.of(context).textTheme.bodyLarge?.color,fontWeight: FontWeight.w500
                          ),)
                        ],
                      ),
                      Row(
                        children: [
                          if (setting_section_one[index]['text'].toString().tr == 'Language'.tr)
                            Text("English", style: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyLarge?.color)),
                          if (setting_section_one[index]['text'].toString().tr == 'Font'.tr)
                            Text(fontProvider.currentFont, style: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyLarge?.color)),
                          Icon(Icons.arrow_forward_ios, color: Theme.of(context).iconTheme.color, size: 15),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showFontDropdown(FontProvider fontProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text('Select Font'.tr, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
          content: DropdownButton<String>(
            value: fontProvider.currentFont,
            onChanged: (String? newValue) {
              if (newValue != null) {
                fontProvider.setFont(newValue);
                Navigator.of(context).pop();
              }
            },
            isExpanded: true,
            items: <String>['Default', 'Roboto', 'Inter', 'OpenSans', 'Lato', 'Delius']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _navigateToPage(String pageName) {
    Widget page;
    switch(pageName) {
      case 'Font':
        page = HistoryPage();
        break;
      case "History":
        page = HistoryPage();
        break;
    // case "Notifications":
    //   page = NotificationsPage();
    //   break;
    // case "Security":
    //   page = SecurityPage();
    //   break;
      case "Language":
        page = LanguagePage();
        break;
      default:
        return; // If no matching page, do nothing
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget getSectionTwo(){
    return Column(
      children: List.generate(setting_section_two.length, (index){
        return Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left:10,right: 10,top: 8,bottom: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color:setting_section_two[index]['color'],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Icon(setting_section_two[index]['icon'],color: Theme.of(context).iconTheme.color,size: 20,),
                          ),
                        ),
                        SizedBox(width: 12,),
                        Text(setting_section_two[index]['text'].toString().tr,style: TextStyle(
                            fontSize: 16,color: Theme.of(context).textTheme.bodyLarge?.color,fontWeight: FontWeight.w500
                        ),)
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, color: Theme.of(context).iconTheme.color, size: 15),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}


