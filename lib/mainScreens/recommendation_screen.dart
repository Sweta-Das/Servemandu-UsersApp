// ignore_for_file: unnecessary_null_comparison, unused_label

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:servemandu_users_app/global/global.dart';
import 'package:servemandu_users_app/models/address.dart';
import 'package:servemandu_users_app/widgets/progress_bar.dart';

import '../widgets/simple_appbar.dart';


class RecommendationScreen extends StatefulWidget {
  final Address? model;
  RecommendationScreen({this.model});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {


 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "Recommendation"),    

      body: FutureBuilder(
          future: FirebaseFirestore.instance
             .collection("users")
             .doc(sharedPreferences!.getString("uid"))
             .collection("userAddress")
             .doc()
             .get();,
          builder: (context, snapshot)
          {
            if (snapshot.connectionState != ConnectionState.done)
            {
              return Center(child: circularProgress(),);  
            }
            Address model = Address.fromJson(snapshot as Map<String, dynamic>);
            return userLatLng(model, context);
          },
        ),
      );
  }

  Widget userLatLng(Address model, BuildContext context) {
    return Column(
      children: [
      Row(
        children: [
          Text("Latitude"),
          Text(model.lat.toString()),
        ],
      ),
      
      Row(
        children: [
          Text("Longitude"),
          Text(model.lng.toString()),
        ],
      ),
    ],);
  }

  //fetching user latitude & longitude
  _fetch() async 
   {
     final firebaseUser = await FirebaseAuth.instance.currentUser!;
     if(firebaseUser != null)
     {
       await FirebaseFirestore.instance
             .collection("users")
             .doc(sharedPreferences!.getString("uid"))
             .collection("userAddress")
             .doc()
             .get();
      };
    }
}
