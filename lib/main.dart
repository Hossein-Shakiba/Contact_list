import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/assets/LanguageList.dart';
import 'ContactProvider.dart';
import 'Theme_provider.dart';
import 'font_provider.dart';
import 'Setting.dart';
import 'ContactList.dart';
import 'FavoriteList.dart';
import 'assets/colors.dart';
import 'package:get/get.dart';

Future<void> main() async{
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderContact()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FontProvider()),
      ],
      child: Consumer2<ThemeProvider, FontProvider>(
        builder: (context, themeProvider,fontProvider, child) {
          return GetMaterialApp(
            locale: Locale('en', 'US'), // زبان پیش‌فرض
            translations: Languages(), // فایل ترجمه‌ها
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: MyHomePage(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  textTheme: Theme.of(context).textTheme.apply(
                    fontFamily: fontProvider.currentFont,
                  ),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: getFooter(),
      body: getBody(),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: [
        FavoritePage(),
        ContactPage(),
        SettingPage(),
      ],
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Icons.star,
      Icons.person,
      Icons.settings
    ];
    List<String> textItems = [
      'Favorite'.tr,
      'Contacts'.tr,
      'Settings'.tr
    ];
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(iconItems.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  pageIndex = index;
                });
              },
              child: Column(
                children: [
                  Icon(
                    iconItems[index],
                    size: 30,
                    color: pageIndex == index
                        ? primary
                        : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5),
                  ),
                  SizedBox(height: 3),
                  Text(
                    textItems[index],
                    style: TextStyle(
                      fontSize: 11,
                      color: pageIndex == index
                          ? primary
                          : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5),
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
