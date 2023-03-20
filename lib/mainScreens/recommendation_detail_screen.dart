import 'package:flutter/material.dart';
import 'package:servemandu_users_app/models/items.dart';

class RecommendationDetailScreen extends StatefulWidget {
  
  final Items? model;
  RecommendationDetailScreen({this.model});

  @override
  State<RecommendationDetailScreen> createState() => _RecommendationDetailScreenState();
}

class _RecommendationDetailScreenState extends State<RecommendationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.blueGrey,
                ],
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
      
        title: Text(
          "Servemandu",
          style: const TextStyle(fontSize: 45, fontFamily: "Signatra"),
        ),
        centerTitle: true,
      ),

      body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        //Displaying service image
        Image.network(widget.model!.thumbnailUrl.toString()),
      ]),
    );
  }
}