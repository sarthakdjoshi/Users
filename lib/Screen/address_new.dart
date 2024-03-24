import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:users/Model/address_Model.dart';
import 'package:uuid/uuid.dart';


class Address_New extends StatefulWidget{
  const Address_New({super.key});

  @override
  State<Address_New> createState() => _Address_NewState();
}

class _Address_NewState extends State<Address_New> {
  String countryValue = " ";
  String stateValue = " ";
  String cityValue = " ";
  var name=TextEditingController();
  var phoneno=TextEditingController();
  var pincode=TextEditingController();
  var houseno=TextEditingController();
  var roadname=TextEditingController();
  var shop=TextEditingController();

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }

      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    setState(() {
      pincode.text = placemarks.isNotEmpty ? placemarks[0].postalCode ?? '' : '';
      houseno.text = placemarks.isNotEmpty ? placemarks[0].subThoroughfare ?? '' : '';
      roadname.text = placemarks.isNotEmpty ? placemarks[0].thoroughfare ?? '' : '';
      shop.text = placemarks.isNotEmpty ? placemarks[0].name ?? '' : '';
    });
  }
  Future<void>adddata() async{
    try{
      FirebaseFirestore.instance.collection("Customeraddress").add(
          {
            "fullname":name.text.trim().toString(),
            "phoneno":phoneno.text.trim().toString(),
            "pincode":pincode.text.trim().toString(),
            "country":countryValue,
            "state":stateValue,
            "city":cityValue,
            "houseno":houseno.text.trim().toString(),
            "roadname": roadname.text.trim().toString(),
            "nearbyshop":shop.text.trim().toString(),
            "Uid":FirebaseAuth.instance.currentUser?.uid,
            "add_id":Uuid().v1()
          }).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Address Saved"),duration: Duration(seconds: 2),));
          /*  name.clear();
            phoneno.clear();
            pincode.clear();
            countryValue="";
            stateValue="";
            cityValue="";
            stateValue=="";
            houseno.clear();
            roadname.clear();
            shop.clear();

           */


      });
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address"),
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(
            children: <Widget>[
               TextField(
                 controller: name,
                decoration: const InputDecoration(
                  hintText: "Full Name",
                  border:  OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
              const SizedBox(height: 10,),
               TextField(
                 controller: phoneno,
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Phone No.",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  )
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                children: <Widget>[
                   SizedBox(
                    width: 150,
                    child: TextField(
                      controller: pincode,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: "Pincode",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                          )
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  SizedBox(
                    width: 150,
                    child: InkWell(
                      onTap: _getCurrentLocation,

                      child: const Row(
                        children: <Widget>[
                          Icon(Icons.my_location),
                          SizedBox(width: 8,),
                          Text("Use My Location")
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            const  SizedBox(height: 8,),
              CSCPicker(
                onCountryChanged: (value) {
                  setState(() {
                    countryValue = value ?? '';
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    stateValue = value ?? '';
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    cityValue = value ?? '';
                  });

                },
              ), const SizedBox(height: 8,),
               TextField(
                 controller: houseno,
                decoration: const InputDecoration(
                    hintText: "House No.,Building Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    )
                ),
              ),
              const SizedBox(height: 10,),
               TextField(
                 controller: roadname,
                decoration: const InputDecoration(
                    hintText: "Road Name,Area,Colony",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    )
                ),
              ),
              const SizedBox(height: 10,),
               TextField(
                 controller: shop,
                decoration: const InputDecoration(
                    hintText: "Near By Shop/Mall/Landmark",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    )
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      String errorMessage = '';

                      if (name.text.isEmpty) {
                        errorMessage = 'Please enter your name';
                      } else if (phoneno.text.isEmpty) {
                        errorMessage = 'Please enter your phone number';
                      } else if (pincode.text.isEmpty) {
                        errorMessage = 'Please enter the pincode';
                      } else if (countryValue.isEmpty) {
                        errorMessage = 'Please select a country';
                      } else if (stateValue.isEmpty) {
                        errorMessage = 'Please select a state';
                      } else if (cityValue.isEmpty) {
                        errorMessage = 'Please select a city';
                      } else if (houseno.text.isEmpty) {
                        errorMessage = 'Please enter the house/building number';
                      } else if (roadname.text.isEmpty) {
                        errorMessage = 'Please enter the road/area/colony';
                      } else if (shop.text.isEmpty) {
                        errorMessage = 'Please enter a nearby shop/mall/landmark';
                      }

                      if (errorMessage.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(errorMessage),duration: Duration(seconds: 2),
                        ));
                      } else {
                        adddata();
                      }
                    },
                    style: ElevatedButton.styleFrom(shape:const RoundedRectangleBorder(borderRadius: BorderRadius.zero)), child: const Text("Save Address")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}