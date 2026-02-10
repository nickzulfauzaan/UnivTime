import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:univtime/utils/theme.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  final LatLng _centerLocation = const LatLng(3.1219, 101.6570);
  GoogleMapController? _mapController;

  final Map<String, LatLng> _locations = {
    'Main Library': LatLng(3.1190, 101.6560),
    'Engineering Block A': LatLng(3.1225, 101.6575),
    'Engineering Block B': LatLng(3.1230, 101.6580),
    'Student Center': LatLng(3.1210, 101.6550),
    'Cafeteria': LatLng(3.1220, 101.6560),
    'Sports Complex': LatLng(3.1200, 101.6590),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Campus Map',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
        ),
      ),
      body: Column(
        children: [
          _buildQuickLocations(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider),
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _centerLocation,
                  zoom: 16,
                ),
                markers: _markers,
                onMapCreated: (controller) => _mapController = controller,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> get _markers {
    return _locations.entries.map((entry) {
      return Marker(
        markerId: MarkerId(entry.key),
        position: entry.value,
        infoWindow: InfoWindow(title: entry.key),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
    }).toSet();
  }

  Widget _buildQuickLocations() {
    return SizedBox(
      height: 50,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: _locations.keys.map((location) {
          return GestureDetector(
            onTap: () {
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(_locations[location]!, 17),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider),
              ),
              child: Center(
                child: Text(
                  location,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
