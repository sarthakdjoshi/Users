import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Model/Sub-Category-Model.dart';

class Category_Detail extends StatefulWidget{
  final String category;
  const Category_Detail({super.key, required this.category});

  @override
  State<Category_Detail> createState() => _Category_DetailState();
}

class _Category_DetailState extends State<Category_Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Brands") ,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
      child: Column(
        children: [
           SizedBox(
            height: 120,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("Sub-Category").where("Category_Name",isEqualTo: widget.category)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  final List< Sub_CategoryModel> categories = snapshot.data!.docs
                      .map((doc) =>  Sub_CategoryModel.fromFirestore(doc))
                      .toList();
                  return ListView.builder(
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var category = categories[index];
                      return Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(category.Image),
                              radius: 45.0,
                            ),
                            Text(
                              category.Sub_Category,
                              style: const TextStyle(
                                fontSize: 16,
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
        ],
      )
      ),
    );
  }
}