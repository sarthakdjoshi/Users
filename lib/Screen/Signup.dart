import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var name = TextEditingController();

  var mobile = TextEditingController();

  var address = TextEditingController();

  var email = TextEditingController();

  var pass = TextEditingController();

  bool abc = true;

  Future<void> add() async {
    try {
      setState(() {
        abc = false;
      });
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: pass.text)
          .then((value) {
        FirebaseFirestore.instance
            .collection("User")
            .doc(FirebaseAuth.instance.currentUser?.uid.toString())
            .set({
          "Name": name.text.trim().toString(),
          "Mobile": mobile.text.trim().toString(),
          "email": email.text.trim().toString(),
          "Address": address.text.trim().toString(),
          "documentid": FirebaseAuth.instance.currentUser?.uid.toString()
        }).then((value) => setState(() {
                  name.clear();
                  mobile.clear();
                  email.clear();
                  address.clear();
                  pass.clear();
                  abc = true;
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Register Successfully")));
                }));
      });
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Center(
              child: Column(
                children: [
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                      hintText: "Enter Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                      hintText: "Enter Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: mobile,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter Mobile",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: address,
                    decoration: InputDecoration(
                      hintText: "Enter Address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: pass,
                    obscureText: (abc) ? true : false,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                        child: (abc)
                            ? const Text(
                                "Register",
                                style: TextStyle(color: Colors.white),
                              )
                            : const CircularProgressIndicator()),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
