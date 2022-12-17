import 'dart:async';
import 'dart:math';

import 'package:ecommerceapk/loginpage.dart';
import 'package:ecommerceapk/providerclass.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mapUtil.dart';

class Drivermap extends StatefulWidget {
  const Drivermap({Key? key}) : super(key: key);

  @override
  State<Drivermap> createState() => _DrivermapState();
}

class _DrivermapState extends State<Drivermap> {
  double? latitue;
  double? longitue;
  String? Currentlocation;
  Timer? timer2;
  Timer? timer1;
  Position? _currentPosition;
  String pname = '';
  double plat = 0;
  double plong = 0;

  Polyline _polyline = Polyline(
    polylineId: PolylineId("_kpolyline"),
  );

  late GoogleMapController mapController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getCurrentLocation();

    timer1 = Timer.periodic(
        Duration(seconds: 65),
            (timer) =>_getCurrentLocation());
    timer2 = Timer.periodic(
        Duration(seconds: 50),
        (timer) =>
            Provider.of<Eprovider>(context, listen: false).uploadlocation());
    // Provider.of<Eprovider>(context,listen: false).getViewpoints();
  }

  final Polyline _kpolyline = Polyline(
    polylineId: PolylineId("_kpolyline"),
    points: [
      LatLng(11.057014, 76.093254),
      LatLng(11.119858, 76.121489),
      LatLng(11.098579, 76.055950),
      LatLng(11.077708, 76.102888),
      LatLng(11.247878, 75.784524),
    ],
    width: 5,
  );
  @override
  Widget build(BuildContext context) {
    latitue = double.parse(context.watch<Eprovider>().GetLat.toString());
    longitue = double.parse(context.watch<Eprovider>().GetLong.toString());
    Currentlocation = context.watch<Eprovider>().Getaddres;
    // _polyline=context.watch<Eprovider>().getKpolyline;
    pname = context.watch<Eprovider>().getpntname;
    // plat=double.parse(context.watch<Eprovider>().getpnlat);
    // plong=double.parse(context.watch<Eprovider>().getpntlog);

    List<Marker> Markeres = [];
    LatLng? _maplocationposition;
    _maplocationposition = LatLng(latitue!, longitue!);
    CameraPosition _initialLocation = CameraPosition(
        target: _maplocationposition, zoom: 11.0, tilt: 0, bearing: 0);

    LatLng startLocation = LatLng(latitue!, longitue!);
    Markeres.add(Marker(
      //add start location marker
      markerId: MarkerId('1'),
      position: startLocation, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: context.watch<Eprovider>().Getaddres,
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    // Markeres.add(Marker(
    //   //add start location marker
    //   markerId: MarkerId('2'),
    //   position: LatLng(plat!, plong!), //position of marker
    //   infoWindow: InfoWindow(
    //     //popup info
    //     title: '${pname}',
    //   ),
    //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    // ));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.clear();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Loginpage(),
              ));
        },
        child: Icon(Icons.logout),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialLocation,
        myLocationEnabled: true,
        mapType: MapType.normal,
        markers: Set.of(Markeres),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        // polylines: {_polyline},
        polylines: {_kpolyline},
      ),
    );
  }

  void _getCurrentLocation() async {
    print('start 1');
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      // Store the position in the variable
      _currentPosition = position;

      print('CURRENT POS: ${_currentPosition}');
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 11.0,
          ),
        ),
      );
    }).catchError((e) {
      print(e);
    });
    await Provider.of<Eprovider>(context, listen: false).getlocation();
  }
}
