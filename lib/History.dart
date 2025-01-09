import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'assets/colors.dart';
import 'assets/setting_json.dart';



class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
                color:Colors.green,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Icon(Icons.history,color: Theme.of(context).iconTheme.color,size: 80,),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Contact details
          Center(
            child: Text(
              "History",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ),
          SizedBox(height: 20),
          getSectionTree(),
        ],
      ),
    );
  }
  Widget getSectionTree(){
    return Column(
      children: List.generate(setting_section_tree.length, (index){
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
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
                              color:setting_section_tree[index]['color'],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Icon(setting_section_tree[index]['icon'],color: Theme.of(context).iconTheme.color,size: 20,),
                            ),
                          ),
                          SizedBox(width: 12,),
                          Text(setting_section_tree[index]['text'.tr],style: TextStyle(
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
          ),
        );
      }),
    );
  }
}
