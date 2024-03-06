import 'package:flutter/material.dart';
import 'package:users/Screen/account.dart';
import 'package:users/Screen/cart.dart';
import 'package:users/Screen/fav.dart';
import 'package:users/Screen/home.dart';

// ignore: must_be_immutable
class Bottomnavigate extends StatefulWidget {
  int selectedindex;

  Bottomnavigate({super.key, this.selectedindex = 0});

  @override
  State<Bottomnavigate> createState() => _BottomnavigateState();
}

class _BottomnavigateState extends State<Bottomnavigate> {
  List<Widget> screen = [
    const Home(),
    const Fav(),
    const Cart(),
    const Account(),
  ];

  void ontap(int index) {
    setState(() {
      widget.selectedindex = index;
    });
  }
  Future<bool> _onWillPop() async {
    if (widget.selectedindex == 0) {
      return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Exit"),
              content: Text("Are you sure you want to exit?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Yes"),
                ),
              ],
            );
          },
      ) ?? false;

    } else {
      setState(() {
        widget.selectedindex = 0; // Set selected index to 0 (Home)
      });
      return false; // Do not allow back button to pop the current screen
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[widget.selectedindex],
      bottomNavigationBar: WillPopScope(
        onWillPop: _onWillPop,
        child: BottomNavigationBar(
          onTap: ontap,

          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.blue,
          currentIndex: widget.selectedindex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
