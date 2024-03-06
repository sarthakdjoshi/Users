import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:users/Model/User_Model.dart';

class Account_Detail extends StatelessWidget {
  const Account_Detail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: SizedBox(
        height: 120,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("Category").where("Uid",isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              final List<User_Model> Users = snapshot.data!.docs
                  .map((doc) => User_Model.fromFirestore(doc))
                  .toList();
              return ListView.builder(
                itemCount: Users.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var User = Users[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Card(
                          child: Row(
                            children: [
                              const Text(
                                "User Name=",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                User.Name,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          child: Row(
                            children: [
                              const Text(
                                "User Email=",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                User.email,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          child: Row(
                            children: [
                              const Text(
                                "User Mobile no.=",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                User.Mobile,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          child: Row(
                            children: [
                              const Text(
                                "User Address no.=",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                User.Address,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
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
    );
  }
}
