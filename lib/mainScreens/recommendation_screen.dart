// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:servemandu_users_app/global/global.dart';
import 'package:servemandu_users_app/widgets/progress_bar.dart';

import '../widgets/simple_appbar.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({Key? key}) : super(key: key);

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  
  double? myLat;
  double? myLng;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "Recommendation"),

      body: FutureBuilder<QuerySnapshot>(
        future: _fetch(),
        builder: (context, snapshot)
        {
          if (snapshot.connectionState != ConnectionState.done)
          {
            return Center(child: circularProgress(),);  
          }
          return Text("Your Latitude : $myLat \nYour Longitude : $myLng");
        },
      ),
    );
  }

  //fetching user latitude & longitude
  _fetch() async 
  {
    final firebaseUser = await FirebaseAuth.instance.currentUser!;
    if(firebaseUser != null)
    {
      await FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseUser.uid)
      .collection("userAddress")
      .doc()
      .get()
      .then((value) 
      {
       myLat = double.parse(('lat').toString());
       myLng = double.parse(('lng').toString());
       print(myLat);
       print(myLng);
      });
    }
    else
    {
      Center(child: Text("Error"));
    }
  }
}
