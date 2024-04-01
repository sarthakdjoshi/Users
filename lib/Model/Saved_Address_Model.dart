import 'package:cloud_firestore/cloud_firestore.dart';

class Saved_Address_Model{
  final String id;
  final String add_id;
  final String city;
  final String country;
  final String fullname;
  final String houseno;
  final String nearbyshop;
  final String phoneno;
  final String pincode;
  final String roadname;
  final String state;
  Saved_Address_Model(
      {
         required this.id,
        required   this.add_id,
        required this.city,
        required  this.country,
        required this.fullname,
        required this.houseno,
        required this.nearbyshop,
        required this.phoneno,
        required  this.pincode,
        required   this.roadname,
        required this.state,

});
  factory Saved_Address_Model.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Saved_Address_Model(
        id: snapshot.id,
        add_id: data['add_id'],
        city: data['city'],
        country: data['country'],
        fullname: data['fullname'],
        houseno: data['houseno'],
        nearbyshop: data['nearbyshop'],
        phoneno: data['phoneno'],
        pincode: data['pincode'],
        roadname: data['roadname'],
        state: data['state']
    );
  }
  }
