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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[widget.selectedindex],
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}
