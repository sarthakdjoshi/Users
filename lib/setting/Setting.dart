import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/setting/Privacy_Policy.dart';
import 'package:users/setting/Return_Policy.dart';
import 'package:users/setting/Saved_Adress.dart';
import 'package:users/setting/tearm_of_use.dart';

import '../Provider.dart';

class My_Setting extends StatefulWidget {
  const My_Setting({super.key});

  @override
  State<My_Setting> createState() => _My_SettingState();
}

class _My_SettingState extends State<My_Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Setting"),
        centerTitle: true,
      ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Provider.of<ThemeProvider>(context, listen: false)
                  .toggleTheme();
            },
            child:  const ListTile(
              title: Text("Change Your Theme"),
              trailing: Icon(Icons.nightlight),
            ),
          ),
          const Text("Account Settings",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          const Divider(height: 3,),
          InkWell(
            onTap: () {
            },
            child:  const ListTile(
              title: Text("Manage Notification"),
              leading: Icon(Icons.notifications),
              trailing: Icon(Icons.keyboard_arrow_right_sharp),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Saved_Address(),));
            },
            child:  const ListTile(
              title: Text("Saved Address"),
              leading: Icon(Icons.location_on),
              trailing: Icon(Icons.keyboard_arrow_right_sharp),
            ),
          ),
          const SizedBox(height: 10,),
          const Text("Feedback&information",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

          const Divider(height: 3,),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Tearm_of_Use(),));
            },
            child:  const ListTile(
              title: Text("Tearm of Use"),
              leading: Icon(Icons.integration_instructions_sharp),
              trailing: Icon(Icons.keyboard_arrow_right_sharp),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen(),));

            },
            child:  const ListTile(
              title: Text("Privacy Policy "),
              leading: Icon(Icons.privacy_tip),
              trailing: Icon(Icons.keyboard_arrow_right_sharp),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReturnPolicyScreen(),));

            },
            child:  const ListTile(
              title: Text("Return Policy "),
              leading: Icon(Icons.keyboard_return ),
              trailing: Icon(Icons.keyboard_arrow_right_sharp),
            ),
          ),
          InkWell(
            onTap: () {
            },
            child:  const ListTile(
              title: Text("Help Center"),
              leading: Icon(Icons.help ),
              trailing: Icon(Icons.keyboard_arrow_right_sharp),
            ),
          ),

        ],
      ),
    );
  }
}
