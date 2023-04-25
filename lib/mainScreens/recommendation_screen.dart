import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:servemandu_users_app/widgets/simple_appbar.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
//import 'dart:math';

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

       
    this.setState(() {
       //finding max probability
       var max = output[0][0];
       var j;
       for(var i=0; i<output[0].length; i++)
       {
        if (output[0][i] > max) {
          max = output[0][i];  
          j=i;        
        }
       }
       print(max);
       print(j);
       int k = j;

       switch(k){
        case 0: {
          predValue = "Air Conditioner";
          break;
        }

        case 1: {
          predValue = "Antivirus";
          break;
        }

        case 2: {
          predValue = "Electrician";
          break;
        }

        case 3: {
          predValue = "Facial";
          break;
        }

        case 4: {
          predValue = "Gardening";
          break;
        }

        case 5: {
          predValue = "Hardware";
          break;
        }

        case 6: {
          predValue = "Manicure";
          break;
        }

        case 7: {
          predValue = "Microwave";
          break;
        }

        case 8: {
          predValue = "Pedicure";
          break;
        }

        case 9: {
          predValue = "Pest Cleaning";
          break;
        }

        case 10: {
          predValue = "Plumbing Service";

          break;
        }

        case 11: {
          predValue = "Refrigerator";
          break;
        }

        case 12: {
          predValue = "Room Cleaning";
          break;
        }

        case 13: {
          predValue = "Software";
          break;
        }

        case 14: {
          predValue = "TV";
          break;
        }

        case 15: {
          predValue = "Thread & wax";
          displayImage();
          break;
        }
      }
      
    });
    displayImage();
  }

  void displayImage() {
    //await predValue;
    SizedBox(height: 20,);
    CircleAvatar(
      radius: 100,
      child: Image.asset("images/Logo.png"),
    );
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
                  ],
                ),
              ),

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
              SizedBox(height: 40,),
              if(predValue == "Air Conditioner")
               Center(
                 child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("slider/0.png")),
               )
              
              else if(predValue == "Antivirus")
                Center(
                 child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("slider/21.png")),
               )
               
              else if(predValue == "Electrician")
                Center(
                 child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("slider/15.png")),
               )
               
              else if(predValue == "Facial")
                Center(
                 child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("slider/17.png")),
               )
               
              else if(predValue == "Gardening")
                Center(
                 child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("slider/11.png")),
               )
               
              else if(predValue == "Hardware")
                Center(
                 child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("slider/25.png")),
               )
              
              else if(predValue == "Manicure")
                Center(
                 child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("slider/19.png")),
               )
               
              else if(predValue == "Microwave")
                Center(
                 child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("slider/2.png")),
               )
              
              else if(predValue == "Pedicure")
                Center(
                 child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("slider/18.png")),
               )
               
              else if(predValue == "Pest Cleaning")
                Center(
                 child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("slider/10.png")),
               )
               
              else if(predValue == "Plumbing")
                Center(
                 child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("slider/16.png")),
               )
               
              else if(predValue == "Refrigerator")
                Center(
                 child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("slider/22.png")),
               )
               
              else if(predValue == "Room Cleaning")
                Center(
                 child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("slider/23.png")),
               )
               
              else if(predValue == "Software")
                Center(
                 child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("slider/24.png")),
               )
              
              else if(predValue == "TV")
                Center(
                 child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("slider/1.png")),
               )
              
              else if(predValue == "Thread & wax")
                Center(
                 child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("slider/20.png")),
               ),     
              
            ],
            
          ),
          
      ),
    );
  }
}