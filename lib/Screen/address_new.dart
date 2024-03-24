import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class Address_New extends StatefulWidget{
  const Address_New({super.key});

  @override
  State<Address_New> createState() => _Address_NewState();
}

class _Address_NewState extends State<Address_New> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  )
                ),
              ),
              const SizedBox(height: 10,),
               TextField(
                 controller: phoneno,
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
                    countryValue = value;
                  });
                },
                onStateChanged:(value) {
                  setState(() {
                    stateValue = value!;
                  });
                },
                onCityChanged:(value) {
                  setState(() {
                    cityValue = value!;
                  });
                },
              ),
              const SizedBox(height: 8,),
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
                child: ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(shape:const RoundedRectangleBorder(borderRadius: BorderRadius.zero)), child: const Text("Save Address")),
              )
            ],
          ),
        ),
      ),
    );
  }
}