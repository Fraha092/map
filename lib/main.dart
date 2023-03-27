import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Map for current location',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey
      ),
      home: const HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 10,
  );

  final List<Marker> _markers = <Marker>[
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(23.8103, 90.4125),
        infoWindow: InfoWindow(
          title: 'My Position',
        )
    ),
  ];

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Google Map for current Loaction"),
      ),
      body: Container(
        child: SafeArea(
          child: GoogleMap(
            initialCameraPosition: _kGoogle,
            markers: Set<Marker>.of(_markers),
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          getUserCurrentLocation().then((value) async {
            print(value.latitude.toString() +" "+value.longitude.toString());

            _markers.add(
                Marker(
                  markerId: MarkerId("1"),
                  position: LatLng(value.latitude, value.longitude),
                  infoWindow: InfoWindow(
                    title: 'My Current Location',
                  ),
                )
            );

            CameraPosition cameraPosition = new CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 10,
            );

            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {
            });
          });
        },
        child: Icon(Icons.local_activity),
      ),
    );
  }
}





















// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   final Completer<GoogleMapController> _controller =
//   Completer<GoogleMapController>();
//
//   LatLng _currentLocation = const LatLng(0, 0);
//
//
//   void _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _currentLocation = LatLng(position.latitude, position.longitude);
//     });
//   }
//
//   void _getLocationPermission()async{
//     var permissionStatus = await Permission.locationWhenInUse.status;
//     if(permissionStatus.isGranted){
//       _getCurrentLocation();
//     }
//     else{
//       showDialog(
//           context: context,
//           builder: (BuildContext context){
//             return AlertDialog(
//               title: Text('Location Permission Denied'),
//               content: Text('Please grabt permission to access your location.'),
//               actions: [
//                 TextButton(
//                     onPressed: (){
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('Ok'))
//               ],
//             );
//           });
//     }
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Google Map App"),
//           backgroundColor: Colors.green,
//         ),
//
//         body: GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: _currentLocation,
//             zoom: 11.0,
//           ),
//           onMapCreated: (GoogleMapController controller) {
//             _controller.complete(controller);
//           },
//
//           markers: Set<Marker>.of(
//             <Marker>[
//               Marker(markerId: MarkerId('currentLocation'),
//               position: _currentLocation,
//                 infoWindow: InfoWindow(
//                   title: 'My Location'
//                 )
//               )
//             ]
//           ),
//           mapType: MapType.normal,
//           myLocationEnabled: true,
//           myLocationButtonEnabled: true,
//           zoomControlsEnabled: true,
//           zoomGesturesEnabled: true,
//         ),
//       ),
//     );
//   }
// }
