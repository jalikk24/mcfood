import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestoLoc extends StatefulWidget {
  const RestoLoc({Key? key}) : super(key: key);

  @override
  State<RestoLoc> createState() => _RestoLocState();
}

class _RestoLocState extends State<RestoLoc> {

  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> markers = new Set();
  LatLng latLng1 = LatLng(-6.9071672, 107.6211718);
  LatLng latLng2 = LatLng(-6.8948984, 107.6210657);
  LatLng latLng3 = LatLng(-6.8986393, 107.6173803);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Resto Location", style: TextStyle(
      //     fontFamily: "inter600",
      //     fontSize: 15,
      //     color: CustomColor.black
      //   ),),
      //   backgroundColor: CustomColor.white,
      //   centerTitle: true,
      //   elevation: 0,
      // ),
      body: GoogleMap(
        mapType: MapType.normal,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        initialCameraPosition: CameraPosition(target: latLng1, zoom: 15),
        markers: getmarkers(),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: (latlng) async {
          final coordinates = new Coordinates(latlng.latitude, latlng.longitude);
          var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
          var first = address.first;
          Fluttertoast.showToast(msg: first.addressLine ?? "");
        },
      ),
    );
  }

  Set<Marker> getmarkers() {
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(latLng1.toString()),
        position: latLng1,
        infoWindow: InfoWindow(
          title: 'SATU',
          snippet: 'SATU',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

      markers.add(Marker(
        markerId: MarkerId(latLng2.toString()),
        position: latLng2,
        infoWindow: InfoWindow(
          title: 'DUA',
          snippet: 'DUA',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
    return markers;
  }

}
