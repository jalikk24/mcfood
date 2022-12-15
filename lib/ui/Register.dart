import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mcfood/controller/ControllerAuth.dart';
import 'package:mcfood/controller/ControllerRegion.dart';
import 'package:mcfood/customStyle/CustomDecoration.dart';
import 'package:mcfood/model/ModelKecamatan.dart';
import 'package:mcfood/model/ModelKelurahan.dart';
import 'package:mcfood/model/ModelKotaKabs.dart';
import 'package:mcfood/model/ModelProvinsi.dart';
import 'package:mcfood/model/ModelRegister.dart';
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
  int selectedGender = 1;

  TextEditingController tecNama = TextEditingController();
  TextEditingController tecUmur = TextEditingController();
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPassword = TextEditingController();

  ValueNotifier<bool> valHidePass = ValueNotifier(true);
  ValueNotifier<String> valAddress = ValueNotifier("");

  ValueNotifier<List<ModelProvinsi>> listProv = ValueNotifier([]);
  ValueNotifier<ModelProvinsi?> modelProv = ValueNotifier(null);

  ValueNotifier<List<ModelKotaKabs>> listKota = ValueNotifier([]);
  ValueNotifier<ModelKotaKabs?> modelKota = ValueNotifier(null);

  ValueNotifier<List<ModelKecamatan>> listKec = ValueNotifier([]);
  ValueNotifier<ModelKecamatan?> modelKec = ValueNotifier(null);

  ValueNotifier<List<ModelKelurahan>> listKel = ValueNotifier([]);
  ValueNotifier<ModelKelurahan?> modelKel = ValueNotifier(null);

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
              inputText(
                  TextInputType.text, "Nama atau Username", false, tecNama),
              inputText(TextInputType.number, "Umur", true, tecUmur),
              inputText(TextInputType.emailAddress, "Email", false, tecEmail),
              inputTextPassword(
                  TextInputType.visiblePassword, "Password", tecPassword),
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
                              selectedGender = 1;
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
                              selectedGender = 0;
                            });
                          }),
                    ),
                  ],
                ),
              ),
              titleDropdown("Provinsi"),
              dropdownProvinsi(),
              titleDropdown("Kota/Kabupaten"),
              dropdownKota(),
              titleDropdown("Kecamatan"),
              dropdownKec(),
              titleDropdown("Kelurahan"),
              dropdownKel(),
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
                      ModelRegister register = ModelRegister(
                          tecNama.text,
                          int.parse(tecUmur.text),
                          tecEmail.text,
                          tecPassword.text,
                          selectedGender,
                          modelProv.value!.provId,
                          modelKota.value!.cityId,
                          modelKec.value!.kecId,
                          modelKel.value!.kelurId,
                          _currentPosition.latitude!,
                          _currentPosition.longitude!,
                          valAddress.value);
                      postRegist(register);
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

  Widget inputText(TextInputType inputType, String hint, bool isUmur,
      TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: TextFormField(
        controller: controller,
        maxLength: isUmur ? 2 : 100,
        keyboardType: inputType,
        decoration: CustomDecoration().getFormBorder(hint, 10),
        style: TextStyle(
            fontFamily: "inter600", fontSize: 15, color: CustomColor.black),
      ),
    );
  }

  Widget inputTextPassword(
      TextInputType inputType, String hint, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: ValueListenableBuilder<bool>(
        valueListenable: valHidePass,
        builder: (_, res, __) {
          return TextFormField(
            controller: controller,
            obscureText: res,
            keyboardType: inputType,
            decoration: InputDecoration(
              suffixIcon: InkWell(
                onTap: () {
                  if (valHidePass.value) {
                    valHidePass.value = false;
                  } else {
                    valHidePass.value = true;
                  }
                  valHidePass.notifyListeners();
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

  Widget titleDropdown(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        title,
        style: TextStyle(
            fontFamily: "inter600", fontSize: 15, color: CustomColor.black),
      ),
    );
  }

  Widget dropdownProvinsi() {
    return ValueListenableBuilder(
      valueListenable: listProv,
      builder: (_, list, __) {
        return ValueListenableBuilder(
          valueListenable: modelProv,
          builder: (_, selectItem, __) {
            return DropdownButtonHideUnderline(
                child: DropdownButton2<ModelProvinsi>(
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
              items: list
                  .map((text) => DropdownMenuItem<ModelProvinsi>(
                      value: text,
                      child: Text(
                        text.provName,
                        style: const TextStyle(
                          fontFamily: "inter500",
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      )))
                  .toList(),
              value: selectItem,
              onChanged: (value) {
                modelProv.value = list[list.indexOf(value!)];
                modelProv.notifyListeners();

                getKota(modelProv.value?.provId ?? 0);
              },
            ));
          },
        );
      },
    );
  }

  Widget dropdownKota() {
    return ValueListenableBuilder(
      valueListenable: listKota,
      builder: (_, list, __) {
        return ValueListenableBuilder(
          valueListenable: modelKota,
          builder: (_, selectItem, __) {
            return DropdownButtonHideUnderline(
                child: DropdownButton2<ModelKotaKabs>(
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
              items: list
                  .map((text) => DropdownMenuItem<ModelKotaKabs>(
                      value: text,
                      child: Text(
                        text.cityName,
                        style: const TextStyle(
                          fontFamily: "inter500",
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      )))
                  .toList(),
              value: selectItem,
              onChanged: (value) {
                modelKota.value = list[list.indexOf(value!)];
                modelKota.notifyListeners();

                getKec(modelKota.value?.cityId ?? 0);
              },
            ));
          },
        );
      },
    );
  }

  Widget dropdownKec() {
    return ValueListenableBuilder(
      valueListenable: listKec,
      builder: (_, list, __) {
        return ValueListenableBuilder(
          valueListenable: modelKec,
          builder: (_, selectItem, __) {
            return DropdownButtonHideUnderline(
                child: DropdownButton2<ModelKecamatan>(
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
              items: list
                  .map((text) => DropdownMenuItem<ModelKecamatan>(
                      value: text,
                      child: Text(
                        text.kecName,
                        style: const TextStyle(
                          fontFamily: "inter500",
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      )))
                  .toList(),
              value: selectItem,
              onChanged: (value) {
                modelKec.value = list[list.indexOf(value!)];
                modelKec.notifyListeners();

                getKel(modelKec.value?.kecId ?? 0);
              },
            ));
          },
        );
      },
    );
  }

  Widget dropdownKel() {
    return ValueListenableBuilder(
      valueListenable: listKel,
      builder: (_, list, __) {
        return ValueListenableBuilder(
          valueListenable: modelKel,
          builder: (_, selectItem, __) {
            return DropdownButtonHideUnderline(
                child: DropdownButton2<ModelKelurahan>(
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
              items: list
                  .map((text) => DropdownMenuItem<ModelKelurahan>(
                      value: text,
                      child: Text(
                        text.kelurName,
                        style: const TextStyle(
                          fontFamily: "inter500",
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      )))
                  .toList(),
              value: selectItem,
              onChanged: (value) {
                modelKel.value = list[list.indexOf(value!)];
                modelKel.notifyListeners();
              },
            ));
          },
        );
      },
    );
  }

  getProvinsi() async {
    await ControllerRegion().getProvinsi((result) {
      listProv.value = result;
      listProv.notifyListeners();
    });
  }

  getKota(int idProv) async {
    await ControllerRegion().getKotaKabs(idProv, (result) {
      listKota.value = result;
      listKota.notifyListeners();
    });
  }

  getKec(int idKota) async {
    await ControllerRegion().getKecamatan(idKota, (result) {
      listKec.value = result;
      listKec.notifyListeners();
    });
  }

  getKel(int idKec) async {
    await ControllerRegion().getKelurahan(idKec, (result) {
      listKel.value = result;
      listKel.notifyListeners();
    });
  }

  void postRegist(ModelRegister modelRegister) async {
    await ControllerAuth().register(modelRegister, () {
      Fluttertoast.showToast(msg: "Registrasi berhasil");
      Navigator.pop(context);
    }, () {
      Fluttertoast.showToast(msg: "Registrasi gagal");
    });
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
        var address =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
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
}
