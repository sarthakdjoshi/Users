import 'package:cloud_firestore/cloud_firestore.dart';

class  Cart_Model{

  final String id;
  final List<dynamic>images;
  final String price_new;
  final String price_old;
  final String qty;
  final double total;
  final String uid;
  final String product_name;
  Cart_Model({
    required this.id,
    required this.images,
    required this.price_new,
    required this.price_old,
    required this.total,
    required this.qty,
    required this.uid,
    required this.product_name,

  });
  factory Cart_Model.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Cart_Model(
        id: snapshot.id,
        images: data['images'],
        price_new: data['price_new'],
        price_old: data['price_old'],
        qty: data['qty'],
        total: data['total'],
        uid: data['Uid'],
        product_name: data['product_name']
    );
  }
}
