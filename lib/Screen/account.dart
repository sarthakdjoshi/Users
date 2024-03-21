import 'package:flutter/material.dart';
import 'package:users/Screen/Account_Detail.dart';
import 'package:users/Screen/Logout.dart';
import 'package:users/Screen/Myorder.dart';
import 'package:users/Screen/Setting.dart';
import 'package:users/Screen/fav.dart';

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
    "Logout"
  ];
  List<Icon> icons = [
    const Icon(Icons.person),
    const Icon(Icons.shopping_cart),
    const Icon(Icons.favorite_border_outlined),
    const Icon(Icons.settings),
    const Icon(Icons.logout_sharp),
  ];
  List<Widget> screen = [
    const Account_Detail(),
    const MyOrder(),
    const Fav(),
    const My_Setting(),
    const Logout()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
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
          const Text(
            "Contact Information",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const Text(
            "Mobile=0123456789",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
