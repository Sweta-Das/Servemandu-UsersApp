import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:servemandu_users_app/widgets/simple_appbar.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:math';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({Key? key}) : super(key: key);

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  String? _currentAddress;
  Position? _currentPosition;
  var predValue = "";

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void initState() {
    super.initState();
    predValue = "Click above button.";
  }

  Future<void> predData() async{
    final interpreter = await Interpreter.fromAsset('recommendation_model.tflite');
    var input = [_currentPosition!.latitude, _currentPosition!.longitude];
    var output = List.filled(16,0).reshape([1,16]);
    interpreter.run(input, output);
    print(input);
    print(output);

    switch(output[0][15])
    {

    }
      
    //for(int)
    String x1 = output[0][0].toString();
    String y1 = "Air Conditioner";
    x1 = y1;
    // print(x1);

    String x2 = output[0][1].toString();
    String y2 = "Air Conditioner";
    x2 = y2;
    // print(x1);

    String x3 = output[0][2].toString();
    String y3 = "Air Conditioner";
    x3 = y3;
    // print(x1);

    String x4 = output[0][3].toString();
    String y4 = "Air Conditioner";
    x4 = y4;
    // print(x1);

    String x5 = output[0][4].toString();
    String y5 = "Air Conditioner";
    x5 = y5;
    // print(x1);

    String x6 = output[0][5].toString();
    String y6 = "Air Conditioner";
    x6 = y6;
    // print(x1);

    String x7 = output[0][6].toString();
    String y7 = "Air Conditioner";
    x7 = y7;
    // print(x1);

    String x8 = output[0][7].toString();
    String y8 = "Air Conditioner";
    x8 = y8;
    // print(x1);

    String x9 = output[0][8].toString();
    String y9 = "Air Conditioner";
    x9 = y9;
    // print(x1);

    String x10 = output[0][9].toString();
    String y10 = "Air Conditioner";
    x10 = y10;
    // print(x1);

    String x11 = output[0][10].toString();
    String y11 = "Air Conditioner";
    x11 = y11;
    // print(x1);

    String x12 = output[0][11].toString();
    String y12 = "Air Conditioner";
    x12 = y12;
    // print(x1);

    String x13 = output[0][12].toString();
    String y13 = "Air Conditioner";
    x13 = y13;
    // print(x1);

    String x14 = output[0][13].toString();
    String y14 = "Air Conditioner";
    x14 = y14;
    // print(x1);

    String x15 = output[0][14].toString();
    String y15 = "Air Conditioner";
    x15 = y15;
    // print(x1);

    String x16 = output[0][15].toString();
    String y16 = "Air Conditioner";
    x16 = y16;
    // print(x1);


    
    this.setState(() {
      output[0].sort();
      predValue = x1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "Recommendation"),
      body: Container(
        padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Recommendation service ', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 17, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                    TextSpan(text: 'works based on your ', style: TextStyle(fontSize: 17, color: Colors.blueGrey)),
                    TextSpan(text: 'location.', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 17)),
                  ],
                ),
              ),

              SizedBox(height: 20,),
            
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Click ', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20, fontWeight: FontWeight.bold, color: Colors.lightBlue)),
                    TextSpan(text: 'on the button below!', style: TextStyle(fontSize: 17, color: Colors.black54)),
                    //TextSpan(text: 'location.', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 17)),
                  ],
                ),
              ),


              //Text('Recommendation service works based on your location.', style: TextStyle(fontSize: 16),),        
              //Center(child: Text('LAT: ${_currentPosition?.latitude ?? ""}',)),
              //Center(child: Text('LNG: ${_currentPosition?.longitude ?? ""}')),
              SizedBox(height: 20,),
              Center(child: Text('ADDRESS: ${_currentAddress ?? ""}')),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _getCurrentPosition,
                child:  Center(child: Text("Get Current Location")),
              ),

              SizedBox(height: 20),

              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Wanna know ', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20, fontWeight: FontWeight.bold, color: Colors.lightBlue)),
                    TextSpan(text: 'what users nearby you are booking?', style: TextStyle(fontSize: 17, color: Colors.black54)),
                    //TextSpan(text: 'location.', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 17)),
                  ],
                ),
              ),

              //Text('Wanna know what users nearby you are booking?'),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: predData,
                child:  Center(child: Text("Recommended Service!")),
              ),

              SizedBox(height: 40,),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                    TextSpan(text: "$predValue Service", style: TextStyle(color: Colors.blue[900], fontSize: 20),),],
                  ),
                  ),
              ),
              
            ],
          ),
          
      ),
    );
  }
}