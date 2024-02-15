import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          "assets/icons/grad_cap.png",
          height: 70.0,
          color: Colors.blue,
        ),
        Text(
          "UnivTime",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class CampusMap extends StatefulWidget {
  const CampusMap({Key? key}) : super(key: key);

  @override
  State<CampusMap> createState() => _CampusMapState();
}

class _CampusMapState extends State<CampusMap> with TickerProviderStateMixin {
  final LatLng _universitiMalayaLocation = LatLng(3.1219, 101.6570);

  GoogleMapController? _mapController;
  late AnimationController _animationController;

  void _animateToLocation(LatLng target, double zoom) {
    _animationController = AnimationController(
      duration: Duration(seconds: 3), // Adjust the duration as needed
      vsync: this,
    );
    _animationController.forward();
    _animationController.addListener(() {
      if (_mapController != null) {
        final currentZoom = _animationController.value * zoom;
        _mapController!
            .moveCamera(CameraUpdate.newLatLngZoom(target, currentZoom));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _animateToLocation(_universitiMalayaLocation, 15.0); // Initial zoom level
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF12171D),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 39.0),
            child: Header(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: Center(
                child: Container(
                  constraints: BoxConstraints.expand(),
                  color: Color(0xFF12171D),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _universitiMalayaLocation,
                      zoom: 15.0,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('Universiti Malaya'),
                        position: _universitiMalayaLocation,
                        infoWindow: InfoWindow(
                          title: 'Universiti Malaya',
                        ),
                      ),
                    },
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
