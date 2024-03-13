import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../Model/Product_Model.dart';

class ProductDetail extends StatefulWidget {
  final String productname;

  const ProductDetail({super.key, required this.productname});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int qty = 1; //dropdown
  List<int> options = [1, 2, 3, 4, 5, 6];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productname),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("Product")
                    .where("product_name", isEqualTo: widget.productname)
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
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        var product = products[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CarouselSlider.builder(
                              itemCount: product.images.length,
                              itemBuilder: (context, index, realIndex) {
                                return Image.network(
                                  product.images[index],
                                  fit: BoxFit.cover,
                                );
                              },
                              options: CarouselOptions(
                                autoPlay: true,
                                aspectRatio: 2.0,
                                enlargeCenterPage: true,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Product Name: ${product.product_name}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  "-${product.discount}",
                                  style: const TextStyle(
                                    fontSize: 36,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "₹${product.product_newprice}",
                                  style: const TextStyle(
                                      fontSize: 36, color: Colors.green),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "MRP:",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  product.product_price,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Category: ${product.category}",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Quantity",
                                  style: TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                DropdownButton<int>(
                                  value: qty,
                                  onChanged: (int? newValue) {
                                    qty = newValue!;
                                    setState(() {});
                                  },
                                  items: options
                                      .map<DropdownMenuItem<int>>((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(value.toString()),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                child: const Text(
                                  "Add To Cart",
                                  style: TextStyle(
                                      color: Colors.lightBlue, fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightBlueAccent),
                                child: const Text(
                                  "Buy Now",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Details",
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Card(
                                child: Column(
                                  children: [
                                    Text(
                                      "Description: ${product.product_desc}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Color: ${product.product_color}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${product.product_title1_delail}: ${product.product_title1}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "title1_detail: ${product.product_title1_delail}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "title2: ${product.product_title2}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "title2_detail: ${product.product_title2_delail}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "title3: ${product.product_title3}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "title3_detail: ${product.product_title3_delail}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "title4: ${product.product_title4}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "title4_detail: ${product.product_title4_delail}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
