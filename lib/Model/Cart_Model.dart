import 'package:cloud_firestore/cloud_firestore.dart';

class Cart_Modek {
  final String id;
  final List<dynamic> Product_Image;
  final String Product_Name;
  final String Product_Price;
  final String User_id;

  Cart_Modek({
    required this.id,
    required this.Product_Image,
    required this.Product_Name,
    required this.Product_Price,
    required this.User_id,
  });

  factory Cart_Modek.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Cart_Modek(
      id: snapshot.id,
      Product_Image: data['Product_Image'],
      Product_Name: data['Product_Name'],
      Product_Price: data['Product_Price'],
      User_id: data['User_id'],
    );
  }
}
