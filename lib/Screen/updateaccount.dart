import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:users/Model/User_Model.dart';
import 'package:users/Screen/Account_Detail.dart';
import 'package:uuid/uuid.dart';

import '../Appcolor.dart';

class Account_Update extends StatefulWidget {
  final User_Model user;

  const Account_Update({super.key, required this.user});

  @override
  State<Account_Update> createState() => _Account_UpdateState();
}

class _Account_UpdateState extends State<Account_Update> {
  var name = TextEditingController();
  var mobile = TextEditingController();
  var email = TextEditingController();
  var pass = TextEditingController();
  var str1 = TextEditingController();
  var str2 = TextEditingController();
  var landmark = TextEditingController();
  var pincode = TextEditingController();
  bool abc = true;
  var right = "";
  bool passkey = true;
  File? profilepic;

  Future<void> Update() async {
    abc = false;
    setState(() {});
    try {
      String photourl = widget.user.imageurl;
      if (profilepic != null) {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child("Stud-profilepic")
            .child(const Uuid().v1())
            .putFile(profilepic!);
        TaskSnapshot taskSnapshot = await uploadTask;
        photourl = await taskSnapshot.ref.getDownloadURL();
      }
      FirebaseFirestore.instance
          .collection("User")
          .doc(widget.user.Uid)
          .update({
        "street1": str1.text.trim().toString(),
        "street2": str2.text.trim().toString(),
        "landmark": landmark.text.trim().toString(),
        "pincode": pincode.text.trim().toString(),
        "imageurl": photourl.toString()
      }).then((value) {
        abc = true;
        setState(() {});
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Account_Detail(),
            ));
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
    email.text = widget.user.email;
    str1.text = widget.user.street1;
    str2.text = widget.user.street2;
    landmark.text = widget.user.landmark;
    pincode.text = widget.user.pincode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Update My Profile"),
          centerTitle: true,
          backgroundColor: AppColors.lightBlue,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Center(
              child: Column(
                children: [
                  (profilepic != null)
                      ? Center(
                          child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            profilepic!,
                            width: 200,
                            height: 200,
                          ),
                        ))
                      : Center(
                          child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.user.imageurl,
                            width: 200,
                            height: 200,
                          ),
                        )),
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
                      child: const Text("Choose Photo")),
                  TextField(
                    controller: email,
                    readOnly: true,
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
                    readOnly: true,
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
                    readOnly: true,
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
