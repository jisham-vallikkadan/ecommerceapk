import 'dart:convert';

import 'package:ecommerceapk/model/latandlongmodel.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Eprovider with ChangeNotifier {
  String baiseurl = 'http://192.168.43.84:5000';

  double locLatitude = 0;
  double locLongitue = 0;
  String addres = '';

  // Polyline _kpolyline = Polyline(
  //   polylineId: PolylineId("_kpolyline"),
  // );
  // late GoogleMapController mapController;
  // Position? _currentPosition;

  Marker marker = Marker(
    markerId: MarkerId('1'),
  );

  String get Getaddres {
    return addres;
  }

  double get GetLat {
    return locLatitude;
  }

  double get GetLong {
    return locLongitue;
  }

  // Polyline get getKpolyline {
  //   return _kpolyline;
  // }

  registration(Map<String, dynamic> regdata) async {
    var url = "http://localhost:5000/users/login";
    var responser = await http.post(Uri.parse(url), body: regdata);
    var body = jsonDecode(responser.body);
    print(body);
    // SharedPreferences preferences=await SharedPreferences.getInstance();
    // var token=body['token'];
    // var id=body["result"]['_id'];
    // var usertype=body['result']['usertype'];
    // preferences.setString('regToken', token);
    // preferences.setString('Id', id);
    // preferences.setInt('Usertype', usertype);
    // print(Token);
    // print(id);
    // print(usertype);
    // print('share is'+preferences.toString());
  }

  userLogin(Map<String, dynamic> logindata) async {
    var url = "${baiseurl}/users/login";
    var responser = await http.post(Uri.parse(url), body: logindata);
    var body = jsonDecode(responser.body);
    print(body);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = body['token'];
    var id = body["result"]['_id'];
    var usertype = body['result']['usertype'];
    print(usertype);
    preferences.setString('Token', token);
    preferences.setInt('usertype', usertype);
    preferences.setString('id', id);
  }

  // late GoogleMapController mapController;
  //  Position? currentPosition;
  //  void getCurrentLocation(mapController, currentPosition) async {
  //    print('start 1');
  //    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //        .then((Position position) async {
  //      currentPosition = position;
  //
  //      print('CURRENT POS: ${currentPosition}');
  //      mapController.animateCamera(
  //        CameraUpdate.newCameraPosition(
  //          CameraPosition(
  //            target: LatLng(position.latitude, position.longitude),
  //            zoom: 11.0,
  //          ),
  //        ),
  //      );
  //    }).catchError((e) {
  //      print(e);
  //    });
  //    getlocation();
  //  }

  Future<void> getlocation() async {
    print('Statrlocation finding');
    Position position = await _determinePosition();
    List data =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    locLatitude = position.latitude;
    locLongitue = position.longitude;
    // addres = '${data[0].locality}';
    addres = data[0].locality;

    print(addres);

    print(data);
    // print(data);
    print("Lat is " + locLatitude.toString());
    print("Lat is " + locLongitue.toString());
    print('add is ' + addres.toString());

    notifyListeners();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future uploadlocation() async {
    var data = {
      "pntname": addres,
      "pntlong": locLongitue.toString(),
      "pntlan": locLatitude.toString()
    };

    if (locLatitude > 0) {
      print('start uploding');
      print("Log is " + locLongitue.toString());
      print(locLatitude);
      print(addres);
      var url = "http://192.168.43.84:5000/point/add-point";
      var response = await http.post(Uri.parse(url), body: data);
      var body = jsonDecode(response.body);
      print(body);
      print('sucss');
    }
  }

  String pntname = '';
  String pntlat = '';
  String pntlog = '';

  String get getpntname {
    return pntname;
  }

  String get getpntlog {
    return pntlog;
  }

  String get getpnlat {
    return pntlat;
  }

  // List<LatLng> LatLongpoints = [];

  final Map<String, Marker> markers = {};

  List<LatLng> points=[];

  Future<List<ViewPoint>> getViewpoints() async {
    print('start');
    var url = 'http://192.168.43.84:5000/point/view-points';
    var responce = await http.get(Uri.parse(url));
    // print(responce);
    if (responce.statusCode == 200) {
      var body = jsonDecode(responce.body);
      // print(body);
      notifyListeners();
      List<ViewPoint> listdata =
          List<ViewPoint>.from(body.map((e) => ViewPoint.fromjson(e))).toList();
      for (int i = 0; i < listdata.length; i++) {
        final marker = Marker(
          markerId: MarkerId(listdata[i].pntname!),
          position: LatLng(double.parse(listdata[i].pntlat!),
              double.parse(listdata[i].pntlong!)),
          infoWindow: InfoWindow(
            title: listdata[i].pntname,
          ),
        );
        points.add(LatLng(double.parse(listdata[i].pntlat!), double.parse(listdata[i].pntlong!)));

        // print(marker);
        markers[listdata[i].pntname!] = marker;
      }
      print('pomnvksdngjf'+points.toString());

      pntname = body[listdata.length - 1]['pntname'];
      pntlog = body[listdata.length - 1]['pntlong'];
      pntlat = body[listdata.length - 1]['pntlan'];
      print(pntlat);
      print(pntlog);
      print(addres);

      return listdata;
    } else {
      List<ViewPoint> listdata = [];
      return listdata;
    }
  }

  // Future getlatandlong() async {
  //   var url = "";
  //   var resonce = await http.get(Uri.parse(url));
  //   if (resonce.statusCode == 200) {
  //     var body = jsonDecode(resonce.body);
  //     List<Getlatandlongfromapi> listData = List<Getlatandlongfromapi>.from(
  //         body[''].map((e) => Getlatandlongfromapi.fromJson(e))).toList();
  //     List<LatLng> point = [];
  //     listData.forEach((element) {
  //       point.add(LatLng(element.Lat!, element.long!));
  //     });
  //     _kpolyline = Polyline(
  //       polylineId: PolylineId("_kpolyline"),
  //       points: point,
  //       width: 5,
  //     );
  //   } else {
  //     return Polyline(
  //       polylineId: PolylineId("_kpolyline"),
  //     );
  //   }
  // }

  int _usertpe = 0;
  int get usertype => _usertpe;
  void regtype(int radionumber) {
    _usertpe = radionumber;
    notifyListeners();
  }
}

// class Getlatandlongfromapi {
//   double? Lat;
//   double? long;
//   String? pntname;
//   Getlatandlongfromapi({this.pntname, this.Lat, this.long});
//
//   factory Getlatandlongfromapi.fromJson(Map<String, dynamic> responce) {
//     return Getlatandlongfromapi(
//       long: responce['lat'],
//       Lat: responce['long'],
//       pntname: responce['addres'],
//     );
//   }
//
//
//
//
// }
