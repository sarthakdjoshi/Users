import 'package:flutter/material.dart';

class Fav extends StatefulWidget{
  const Fav({super.key});

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
       body: const Center(
         child: Text("Favorites"),
       ),
     );
  }
}