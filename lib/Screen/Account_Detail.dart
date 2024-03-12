import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:users/Model/User_Model.dart';
import 'package:users/Screen/updateaccount.dart';

class Account_Detail extends StatelessWidget {
  const Account_Detail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("User")
              .where("Uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
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
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Username=",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                User.Name,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Email=",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                User.email,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Mobile no.=",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                User.Mobile,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Address=",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                User.Address,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Account_Update(user: User),
                                        ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero),
                                      backgroundColor: Colors.blue),
                                  child: const Text(
                                    "Update",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )))
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
    );
  }
}
