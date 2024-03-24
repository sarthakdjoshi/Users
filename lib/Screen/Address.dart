import 'package:flutter/material.dart';
import 'package:users/Screen/address_new.dart';

class Address extends StatefulWidget{
  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Address"),
        centerTitle: true,
        backgroundColor:Colors.indigo,
      ),
      body: Column(
        children: <Widget>[
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Address_New(),));
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add,size: 20,color: Colors.indigo,),
                Text("Add New Address",style: TextStyle(fontSize: 20,color: Colors.indigo),)
              ],
            ),
          ),

        ],
      ),
      );
    
  }
}