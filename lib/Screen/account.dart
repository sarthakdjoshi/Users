import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:users/Screen/Account_Detail.dart';
import 'package:users/Screen/Logout.dart';
import 'package:users/Screen/Myorder.dart';
import 'package:users/setting/Setting.dart';
import 'package:users/Screen/fav.dart';

import '../Appcolor.dart';
import '../main.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  List<String> name = [
    "MY Account",
    "MY Order",
    "MY Wishlist",
    "MY Setting",
   ];
  List<Icon> icons = [
    const Icon(Icons.person),
    const Icon(Icons.shopping_cart),
    const Icon(Icons.favorite_border_outlined),
    const Icon(Icons.settings),
  ];
  List<Widget> screen = [
    const Account_Detail(),
    const MyOrder(),
    const Fav(),
    const My_Setting(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        centerTitle: true,
        backgroundColor:AppColors.lightBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: name.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: InkWell(
                          child: ListTile(
                            title: Text(name[index]),
                            trailing: icons[index],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => screen[index],
                                ));
                          },
                        ),
                      ),
                    ),

                  ],
                );
              },
            ),
          ),
          InkWell(
            child: const ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.logout),
            ),
            onTap: (){
              FirebaseAuth.instance
                  .signOut()
                  .then((value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const MyHomePage(title: "Login"),
                  )));
            },
          )
        ],
      ),
    );
  }
}
