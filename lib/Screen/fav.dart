import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Fav extends StatefulWidget{
  @override
  State<Fav> createState() => _FavState();
}

class _FavState extends State<Fav> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: const Text("Favorites"),
         centerTitle: true,
         backgroundColor: Colors.indigo,

       ),
       body: Center(
         child: Text("Favorites"),
       ),
     );
  }
}