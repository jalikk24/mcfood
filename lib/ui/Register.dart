import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mcfood/controller/ControllerRegion.dart';
import 'package:mcfood/customStyle/CustomDecoration.dart';
import 'package:mcfood/model/ModelProvinsi.dart';
import 'package:mcfood/util/CustomColor.dart';
import 'package:mcfood/util/ScreenSize.dart';
import 'package:location/location.dart' as LocationManager;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with ChangeNotifier {
  late LocationData _currentPosition;
  late String _address;
  late GoogleMapController mapController;
  final Set<Marker> markers = new Set();
  Location location = Location();

  late GoogleMapController _controller;
  LatLng _initialcameraposition = LatLng(-6.9071672, 107.6211718);

  // Completer<GoogleMapController> _controller = Completer();

  String gender = "Laki laki";
  List<String> listTest = ["test1", "test2"];
  String selectedTest = "test1";
  ValueNotifier<bool> valShowPass = ValueNotifier(false);
  ValueNotifier<String> valAddress = ValueNotifier("");
  ValueNotifier<List<ModelProvinsi>> listProv = ValueNotifier([]);

  @override
  void initState() {
    getLoc();
    getProvinsi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Register",
          style: TextStyle(
              fontFamily: "inter600", fontSize: 20, color: CustomColor.black),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_outlined),
            color: CustomColor.black),
        backgroundColor: CustomColor.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              inputText(TextInputType.text, "Nama atau Username"),
              inputText(TextInputType.number, "Umur"),
              inputText(TextInputType.emailAddress, "Email"),
              inputTextPassword(TextInputType.visiblePassword, "Password"),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                          activeColor: CustomColor.primary,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "Laki laki",
                            style: TextStyle(
                                fontFamily: "inter600",
                                fontSize: 15,
                                color: CustomColor.black),
                          ),
                          value: "Laki laki",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          }),
                    ),
                    Expanded(
                      child: RadioListTile(
                          activeColor: CustomColor.primary,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "Perempuan",
                            style: TextStyle(
                                fontFamily: "inter600",
                                fontSize: 15,
                                color: CustomColor.black),
                          ),
                          value: "Perempuan",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          }),
                    ),
                  ],
                ),
              ),
              DropdownButtonHideUnderline(
                  child: DropdownButton2(
                buttonDecoration: BoxDecoration(
                  color: CustomColor.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 2, color: CustomColor.greyBd),
                ),
                buttonPadding: EdgeInsets.symmetric(horizontal: 10),
                isExpanded: true,
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: CustomColor.white,
                ),
                dropdownElevation: 1,
                items: listTest
                    .map((text) => DropdownMenuItem(
                        value: text,
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontFamily: "inter500",
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        )))
                    .toList(),
                value: selectedTest,
                onChanged: (value) {
                  setState(() {
                    selectedTest = value as String;
                  });
                },
              )),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pilih Titik Alamat",
                      style: TextStyle(
                          fontFamily: "inter600",
                          fontSize: 15,
                          color: CustomColor.black),
                    ),
                    TextButton(
                        onPressed: () async {
                          final coordinates = Coordinates(
                              _currentPosition.latitude,
                              _currentPosition.longitude);
                          var address = await Geocoder.local
                              .findAddressesFromCoordinates(coordinates);
                          var first = address.first;
                          _address = first.addressLine!;
                          valAddress.value = _address;
                          valAddress.notifyListeners();
                          setState(() {
                            Marker marker = markers.firstWhere(
                                (element) =>
                                    element.markerId.value == "myLocation",
                                orElse: () => const Marker(
                                    markerId: MarkerId("myLocation")));
                            markers.remove(marker);

                            moveCamera(_currentPosition.latitude!,
                                _currentPosition.longitude!);
                          });
                        },
                        child: Text(
                          "Gunakan lokasi terkini",
                          style: TextStyle(
                              fontFamily: "inter600",
                              fontSize: 16,
                              color: CustomColor.primary),
                        ))
                  ],
                ),
              ),
              //Google Maps
              Container(
                width: ScreenSize.getWidth(context),
                height: ScreenSize.getHeight(context) / 2,
                padding: EdgeInsets.only(bottom: 20),
                margin: EdgeInsets.only(top: 10),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: GoogleMap(
                  markers: markers,
                  mapType: MapType.normal,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  myLocationButtonEnabled: true,
                  initialCameraPosition:
                      CameraPosition(target: _initialcameraposition, zoom: 15),
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Alamat",
                  style: TextStyle(
                      fontFamily: "inter600",
                      fontSize: 18,
                      color: CustomColor.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ValueListenableBuilder<String>(
                  valueListenable: valAddress,
                  builder: (_, res, __) {
                    return Text(
                      res,
                      style: TextStyle(
                          fontFamily: "inter500",
                          fontSize: 14,
                          color: CustomColor.black),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(45),
                        backgroundColor: CustomColor.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      "Registrasi",
                      style: TextStyle(
                          fontFamily: "inter600",
                          fontSize: 15,
                          color: CustomColor.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget inputText(TextInputType inputType, String hint) {
    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: TextFormField(
        obscureText: true,
        keyboardType: inputType,
        decoration: CustomDecoration().getFormBorder(hint, 10),
        style: TextStyle(
            fontFamily: "inter600", fontSize: 15, color: CustomColor.black),
      ),
    );
  }

  Widget inputTextPassword(TextInputType inputType, String hint) {
    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: ValueListenableBuilder<bool>(
        valueListenable: valShowPass,
        builder: (_, res, __) {
          return TextFormField(
            obscureText: res,
            keyboardType: inputType,
            decoration: InputDecoration(
              suffixIcon: InkWell(
                onTap: () {
                  if (valShowPass.value) {
                    valShowPass.value = false;
                  } else {
                    valShowPass.value = true;
                  }
                  valShowPass.notifyListeners();
                },
                child: Icon(res ? Icons.visibility_off : Icons.visibility),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              hintText: hint,
              hintStyle: TextStyle(
                  fontFamily: "inter600",
                  fontSize: 15,
                  color: CustomColor.greyBd),
              fillColor: CustomColor.greyFb,
              filled: true,
              isDense: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2, color: CustomColor.greyE8),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2, color: CustomColor.greyE8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 2, color: CustomColor.greyE8),
              ),
            ),
            style: TextStyle(
                fontFamily: "inter600", fontSize: 15, color: CustomColor.black),
          );
        },
      ),
    );
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    // location.onLocationChanged.listen((l) {
    //   moveCamera(l.latitude!, l.longitude!);
    // });
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    _initialcameraposition =
        LatLng(_currentPosition.latitude!, _currentPosition.longitude!);
    setState(() {
      moveCamera(_currentPosition.latitude!, _currentPosition.longitude!);
      _getAddress(_currentPosition.latitude!, _currentPosition.longitude!)
          .then((value) {
        _address = "${value.first.addressLine}";
        valAddress.value = _address;
        valAddress.notifyListeners();
      });
    });
    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   setState(() {
    //     _currentPosition = currentLocation;
    //     _initialcameraposition = LatLng(_currentPosition.latitude!, _currentPosition.longitude!);
    //     _getAddress(_currentPosition.latitude!, _currentPosition.longitude!)
    //         .then((value) {
    //       setState(() {
    //         _address = "${value.first.addressLine}";
    //         valAddress.value = _address;
    //         valAddress.notifyListeners();
    //         moveCamera(currentLocation.latitude!, currentLocation.longitude!);
    //       });
    //     });
    //   });
    // });
  }

  Future<List<Address>> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
  }

  void moveCamera(double lat, double longs) {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, longs), zoom: 15),
      ),
    );
    addMarkers(lat, longs);
  }

  void addMarkers(lat, longs) {
    markers.add(Marker(
      markerId: MarkerId("myLocation"),
      position: LatLng(lat, longs),
      draggable: true,
      onDragEnd: (latlng) async {
        final coordinates = Coordinates(latlng.latitude, latlng.longitude);
        var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = address.first;
        _address = first.addressLine!;
        valAddress.value = _address;
        valAddress.notifyListeners();
      },
      infoWindow: InfoWindow(
        title: valAddress.value,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ));
  }

  getProvinsi() async {
    await ControllerRegion().getProvinsi((result) {
      listProv.value = result;
      listProv.notifyListeners();
      print("PROVINSI ${listProv.value}");
    });
  }

}
