import 'package:cloud_firestore/cloud_firestore.dart';

class Address_Model {
  final String id;
  final String city;
  final String country;
  final String fullname;
  final String houseno;
  final String nearbyshop;
  final String roadname;
  final String state;
  final String phoneno;
  final String add_id;
  final String pincode;

  Address_Model({
    required this.id,
    required this.city,
    required this.country,
    required this.fullname,
    required this.houseno,
    required this.nearbyshop,
    required this.roadname,
    required this.state,
    required this.add_id,
    required this.phoneno,
    required this.pincode,
  });

  factory Address_Model.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Address_Model(
      id: snapshot.id,
      city: data['city'],
      country: data['country'],
      fullname: data['fullname'],
      houseno: data['houseno'],
      nearbyshop: data['nearbyshop'],
      roadname: data['roadname'],
      state: data['state'],
      phoneno: data['phoneno'],
      add_id: data['add_id'],
      pincode: data['pincode'],
    );
  }
}
