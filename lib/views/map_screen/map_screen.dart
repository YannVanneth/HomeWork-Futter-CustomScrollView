import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var initialCameraPosition = CameraPosition(
    target: LatLng(11.572543, 104.893275),
    zoom: 20,
  );

  var address = '';
  Timer? _timer;
  int _start = 2;

  void delayTwoSecondToGetAddress(LatLng location) {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          getLocationAddress(location);
        } else {
          _start--;
        }
      },
    );
  }

  void getLocationAddress(LatLng location) {
    placemarkFromCoordinates(location.latitude, location.longitude)
        .then((value) {
      var _address = '';
      var mark = value.first;

      _address += '${mark.thoroughfare ?? ''}, ';

      _address += '${mark.subLocality ?? ''}, ';
      _address += mark.locality ?? '';
      setState(() {
        address = _address;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            bottom: 145,
            child: GoogleMap(
              initialCameraPosition: initialCameraPosition,
              onCameraMove: (position) async {
                setState(() {
                  address = 'Loading ...';
                });
                delayTwoSecondToGetAddress(position.target);
              },
            ),
          ),
          Positioned(
              top: 30,
              left: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SizedBox(
                  height: 80,
                  child: Icon(
                    Icons.arrow_back,
                    size: 32,
                  ),
                ),
              )),
          Positioned(
            top: (MediaQuery.of(context).size.height) / 2 - 64,
            child: SizedBox(
              height: 64,
              // color: Colors.green,
              child: Icon(
                Icons.location_on_rounded,
                color: Colors.black,
                size: 42,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              height: MediaQuery.sizeOf(context).height * 0.15,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            backgroundColor: Colors.black),
                        child: Text(
                          'Select Location',
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
