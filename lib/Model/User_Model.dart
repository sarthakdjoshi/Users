import 'package:cloud_firestore/cloud_firestore.dart';

class User_Model {
  final String id;
  final String Uid;
  final String email;
  final String Name;
  final String Address;
  final String Mobile;

  User_Model({
    required this.id,
    required this.Uid,
    required this.email,
    required this.Name,
    required this.Address,
    required this.Mobile,
  });

  factory User_Model.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return User_Model(
      id: snapshot.id,
      Uid: data['Uid'],
      email: data['email'],
      Name: data['Name'],
      Address: data['Address'],
      Mobile: data['Mobile'],
    );
  }
}
