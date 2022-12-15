import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';

class TestGeocoding extends StatefulWidget {
  const TestGeocoding({Key? key}) : super(key: key);

  @override
  State<TestGeocoding> createState() => _TestGeocodingState();
}

class _TestGeocodingState extends State<TestGeocoding> {

  TextEditingController latitudeController = new TextEditingController();
  TextEditingController longitudeController = new TextEditingController();
  // variable created to store the address
  String stAddress = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // on below line we have given title of App
        title: Text('GFG'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Get Address from Coordinates', style: TextStyle(color: Color(0xFF0F9D58), fontWeight: FontWeight.bold, fontSize: 20),),
              SizedBox(height: 10),

              // textfield1 for taking input as latitude
              TextField(
                controller: latitudeController,
                decoration: InputDecoration(
                  // Given Hint Text
                    hintText: 'Latitude',
                    border: OutlineInputBorder(
                      // Given border to textfield
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(height: 10),

              // textfield2 for taking input as longitude
              TextField(
                controller: longitudeController,
                decoration: InputDecoration(
                  // Given hint text
                    hintText: 'Longitude',
                    border: OutlineInputBorder(
                      // given border to textfield
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(height: 10),

              // Given padding to the Container
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: Center(child: Text(stAddress),),
                ),
              ),
              SizedBox(height: 10),

              GestureDetector(
                onTap: () async {

                  // stored the value of latitude in lat from textfield
                  String lat = latitudeController.text;
                  // stored the value of longitude in lon from textfield
                  String lon = longitudeController.text;

                  // converted the lat from string to double
                  double lat_data = double.parse(lat);
                  // converted the lon from string to double
                  double lon_data = double.parse(lon);

                  // // Passed the coordinates of latitude and longitude
                  final coordinates = Coordinates(lat_data, lon_data);
                  var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
                  var first = address.first;

                  // on below line we have set the address to string
                  setState(() {
                    stAddress = first.addressLine.toString();
                  });

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      // specified color for button
                      color: Colors.green,
                    ),
                    // given height for button
                    height: 50,
                    child: Center(
                      // on below line we have given button name
                      child: Text('Convert',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
