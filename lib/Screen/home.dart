import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:users/Model/Banner_model.dart';
import 'package:users/Model/Product_Model.dart';
import 'package:users/main.dart';

import '../Model/category-model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyHomePage(
                    title: "login",
                  ),
                ),
              );
            },
            icon: const Icon(Icons.logout_sharp),
            color: Colors.red,
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection("Category").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text("Error:${snapshot.hasError}");
                    } else {
                      final List<CategoryModel> users = snapshot.data!.docs
                          .map((doc) => CategoryModel.fromFirestore(doc))
                          .toList();
                      return ListView.builder(
                        itemCount: users.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var user = users[index];
                          return Card(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage((user.Image)),
                                  radius: 100.0,
                                ),
                                Text(
                                  user.Category_Name,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection("Banner").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text("Error:${snapshot.hasError}");
                    } else {
                      final List<Banner_Model> users = snapshot.data!.docs
                          .map((doc) => Banner_Model.fromFirestore(doc))
                          .toList();
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return CarouselSlider.builder(itemCount: users.length,
                              itemBuilder: (context, index, realIndex) {
                                var user = users[index];
                                return SizedBox(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(user.Image,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),

                                  ),
                                );
                              },
                              options: CarouselOptions(
                             autoPlay: true,
                             aspectRatio: 2.0,
                                enlargeCenterPage: true,
                              )
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection("Product").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text("Error:${snapshot.hasError}");
                    } else {
                      final List<Product_Model> users = snapshot.data!.docs
                          .map((doc) => Product_Model.fromFirestore(doc))
                          .toList();
                      return GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 1.0,
                          mainAxisSpacing: 20.0,
                          crossAxisSpacing: 20.0,
                          children: List.generate(users.length, (index) {
                            var user=users[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(user.images[0],height: 100,),
                                Text(user.product_price,style: const TextStyle(color: Colors.green,fontSize: 30),),
                              ],
                            );
                          })
                      );

                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
