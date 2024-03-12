import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:users/Model/User_Model.dart';
import 'package:users/Screen/Account_Detail.dart';

class Account_Update extends StatefulWidget {
  final User_Model user;

  const Account_Update({super.key, required this.user});

  @override
  State<Account_Update> createState() => _Account_UpdateState();
}

class _Account_UpdateState extends State<Account_Update> {
  var name = TextEditingController();

  var mobile = TextEditingController();

  var address = TextEditingController();

  var email = TextEditingController();

  var pass = TextEditingController();

  bool abc = true;
  var right = "";

  Future<void> Update() async {
    abc = false;
    setState(() {});
    try {
      FirebaseFirestore.instance
          .collection("User")
          .doc(widget.user.Uid)
          .update({
        "Name": name.text.trim().toString(),
        "Mobile": mobile.text.trim().toString(),
        "email": email.text.trim().toString(),
        "Address": address.text.trim().toString(),
      }).then((value) {
        abc = true;
        setState(() {});
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Account_Detail(),));
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = widget.user.Name;
    mobile.text = widget.user.Mobile;
    address.text = widget.user.Address;
    email.text = widget.user.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Update My Profile"),
          centerTitle: true,
          backgroundColor: Colors.indigo,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Uid=${widget.user.Uid}",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      hintText: "Enter Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                      hintText: "Enter Name",
                      prefixIcon: const Icon(Icons.person),
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
                      prefixIcon: const Icon(Icons.phone),
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
                      prefixIcon: const Icon(Icons.location_city),
                      hintText: "Enter Address",
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
                          if (right == "Valid") {
                            Update();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Enter Vaild Email")));
                            email.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            )),
                        child: (abc)
                            ? const Text(
                                "Update",
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
