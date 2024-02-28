import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Signup extends StatelessWidget {
  var name = TextEditingController();
  var mobile = TextEditingController();

  Signup({super.key});

  Future<void> add() async {
    try {
      FirebaseFirestore.instance.collection("Add").add({
        "Name": name.text.trim().toString(),
        "Mobile": mobile.text.trim().toString(),
      }).then((value) => print("added"));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Sign-up",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo,
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(hintText: "Enter Name"),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: mobile,
                decoration: const InputDecoration(hintText: "Enter Mobile"),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      add();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        )),
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ));
  }
}
