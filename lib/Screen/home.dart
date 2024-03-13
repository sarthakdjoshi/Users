import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users/Model/Banner_model.dart';
import 'package:users/Model/Product_Model.dart';
import 'package:users/Model/category-model.dart';
import 'package:users/Screen/Category_Detail.dart';
import 'package:users/Screen/Prodcut_detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var search = TextEditingController();
  bool abc = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          centerTitle: true,
          backgroundColor: Colors.indigo,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.red,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.white,
                  Colors.deepPurpleAccent,
                  Colors.grey
                ])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 120,
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("Category")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          final List<CategoryModel> categories = snapshot
                              .data!.docs
                              .map((doc) => CategoryModel.fromFirestore(doc))
                              .toList();
                          return ListView.builder(
                            itemCount: categories.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var category = categories[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Category_Detail(
                                              category: category.Category_Name),
                                        ));
                                  },
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(category.Image),
                                        radius: 45.0,
                                      ),
                                      Text(
                                        category.Category_Name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("Banner")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        final List<Banner_Model> banners = snapshot.data!.docs
                            .map((doc) => Banner_Model.fromFirestore(doc))
                            .toList();
                        return CarouselSlider.builder(
                          itemCount: banners.length,
                          itemBuilder: (context, index, realIndex) {
                            var banner = banners[index];
                            return Image.network(
                              banner.Image,
                              fit: BoxFit.cover,
                            );
                          },
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                          ),
                        );
                      }
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Products",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("Product")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      final List<Product_Model> products = snapshot.data!.docs
                          .map((doc) => Product_Model.fromFirestore(doc))
                          .toList();
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          var product = products[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetail(
                                        productname: product.product_name),
                                  ));
                            },
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                elevation: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        product.images[0],
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        product.product_name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, bottom: 8.0),
                                      child: Text(
                                        product.product_newprice,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, bottom: 8.0),
                                      child: Text(
                                        product.product_price,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
