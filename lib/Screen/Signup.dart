import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../Appcolor.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var name = TextEditingController();
  var mobile = TextEditingController();
  var email = TextEditingController();
  var pass = TextEditingController();
  var str1 = TextEditingController();
  var str2 = TextEditingController();
  var landmark = TextEditingController();
  var pincode = TextEditingController();
  File? profilepic;

  bool abc = true;
  var right = "";
  bool passkey = true;

  Future<void> add() async {
    try {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("Stud-profilepic")
          .child(const Uuid().v1())
          .putFile(profilepic!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String photourl = await taskSnapshot.ref.getDownloadURL();
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: pass.text)
          .then((value) {
        FirebaseFirestore.instance.collection("User").doc(value.user?.uid).set({
          "Name": name.text.trim().toString(),
          "Mobile": mobile.text.trim().toString(),
          "email": email.text.trim().toString(),
          "street1": str1.text.trim().toString(),
          "street2": str2.text.trim().toString(),
          "landmark": landmark.text.trim().toString(),
          "pincode": pincode.text.trim().toString(),
          "Uid": FirebaseAuth.instance.currentUser?.uid.toString(),
          "imageurl": photourl.toString()
        });
        setState(() {
          name.clear();
          mobile.clear();
          email.clear();
          str1.clear();
          str2.clear();
          landmark.clear();
          pincode.clear();
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
          backgroundColor: AppColors.lightBlue,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Center(
              child: Column(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      try {
                        XFile? selecetedimage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (selecetedimage != null) {
                          print("Image");
                          File cf = File(selecetedimage.path);
                          setState(() {
                            profilepic = cf;
                          });
                        } else {
                          print("No Image");
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 40,
                      backgroundImage:
                          (profilepic != null) ? FileImage(profilepic!) : null,
                    ),
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
                  const SizedBox(
                    height: 10,
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
                    controller: str1,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_city),
                      hintText: "Street-1",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: str2,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_city),
                      hintText: "Street-2",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: landmark,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_city),
                      hintText: "landmark",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: pincode,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_city),
                      hintText: "pincode",
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
                        icon: const Icon(Icons.key),
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
                          if (right == "Valid" && profilepic != null) {
                            add();
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
