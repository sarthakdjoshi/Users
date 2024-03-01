import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
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
  var right="";
  bool passkey = true;

  Future<void> add() async {
    try {
     await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: pass.text)
          .then((value) {
        FirebaseFirestore.instance
            .collection("User")
            .doc(value.user?.uid)
            .set({
          "Name": name.text.trim().toString(),
          "Mobile": mobile.text.trim().toString(),
          "email": email.text.trim().toString(),
          "Address": address.text.trim().toString(),
          "Uid": FirebaseAuth.instance.currentUser?.uid.toString()
        });
        setState(() {
                  name.clear();
                  mobile.clear();
                  email.clear();
                  address.clear();
                  pass.clear();
                  abc = true;
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Register Successfully")));
                });
      });
    } on FirebaseAuthException catch (e) {
     print(e.code.toString());
      if (e.code == "weak-password") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Password Is Weak")));
      }
      if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email Is Already In USed")));
      }
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
                      prefixIcon: Icon(Icons.email),
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
                      prefixIcon: Icon(Icons.person),
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
                    maxLength: 10,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
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
                      prefixIcon: Icon(Icons.location_city),
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
                    obscureText: passkey,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        onPressed: () {
                          passkey = !passkey;
                          setState(() {});
                        },
                        icon: Icon(Icons.key),
                      ),
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
                          final bool isValid =
                          EmailValidator.validate(email.text.toString());
                          if (isValid) {
                            right = "Valid";
                          } else {
                            right = "Invalid";
                          }
                          if(right=="Valid") {
                            add();
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter Vaild Email")));
                          }
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
                            : const CircularProgressIndicator(
                                color: Colors.white,
                              )),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
