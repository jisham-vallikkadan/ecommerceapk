import 'package:ecommerceapk/loginpage.dart';
import 'package:ecommerceapk/providerclass.dart';
import 'package:ecommerceapk/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';

class Userpage extends StatefulWidget {
  const Userpage({Key? key}) : super(key: key);

  @override
  State<Userpage> createState() => _UserpageState();
}

class _UserpageState extends State<Userpage> {
  double? latitue = 0;
  double? longitue = 0;
  String? currentlocation;
  // List<Marker> Markeres = [];
  String? pntlat;
  String? pntlong;
  String? pntname;

  // GoogleMapController? mapControllers;
  late GoogleMapController mapController;
  Position? currentPosition;
  // late Map<String, Marker> markers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getCurrentLocation();
    // Provider.of<Eprovider>(context,listen: false).getCurrentLocation(mapController,currentPosition);
    Provider.of<Eprovider>(context, listen: false).getViewpoints();
  }

  @override
  Widget build(BuildContext context) {
    latitue = context.watch<Eprovider>().GetLat;
    longitue = context.watch<Eprovider>().GetLong;
    currentlocation = context.watch<Eprovider>().Getaddres;
    pntlat = context.watch<Eprovider>().getpnlat;
    pntlong = context.watch<Eprovider>().getpntlog;
    pntname = context.watch<Eprovider>().getpntname;


    // Markeres.add(Marker(
    //   //add start location marker
    //   markerId: MarkerId('1'),
    //   position: LatLng(latitue!, longitue!), //position of marker
    //   infoWindow: InfoWindow(
    //     //popup info
    //     title: '${currentlocation}',
    //   ),
    //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    // ));
    // Markeres.add(Marker(
    //   //add start location marker
    //   markerId: MarkerId('2'),
    //   position: LatLng(double.parse(pntlat!), double.parse(pntlong!)), //position of marker
    //   infoWindow: InfoWindow(
    //     //popup info
    //     title: '${pntname}',
    //   ),
    //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    // ));


    return Scaffold(
        appBar: AppBar(
          title: Text('useroage'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(8),
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(0.0, 0.0),
                      zoom: 11.0,
                      tilt: 0,
                      bearing: 0),
                  // myLocationEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  mapType: MapType.normal,
                  // markers: Set.of(Markeres),
                  markers: Provider.of<Eprovider>(context,listen: false).markers.values.toSet(),
                  polylines: {
               Polyline(
                polylineId: PolylineId("_kpolyline"),
                points: Provider.of<Eprovider>(context,listen: false).points,
                width: 5,
                ),
                  },
                ),
              ),
              Button(
                buttonclik: () {
                  Provider.of<Eprovider>(context, listen: false)
                      .getViewpoints();
                },
                buttonmarginright: 20,
                buttonmarginleft: 20,
                buttontext: "find driver",
                boxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: Colors.red),
                buttonTextcolor: Colors.white,
              ),
              Text("${longitue}"),
              Text("${latitue}"),
              Text("${currentlocation}"),
              SizedBox(
                height: 50,
              ),
              Text("${pntname}"),
              Text("${pntlong}"),
              Text("${pntlat}"),
              // Text('${Provider.of<Eprovider>(context,listen: false).LatLongpoints}'),
            ],
          ),
        ));
  }

  void _getCurrentLocation() async {
    print('start');
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      // Store the position in the variable
      currentPosition = position;

      print('CURRENT POS: ${currentPosition}');
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 9.0,
          ),
        ),
      );
    }).catchError((e) {
      print(e);
    });
    await Provider.of<Eprovider>(context, listen: false).getlocation();
  }
}
