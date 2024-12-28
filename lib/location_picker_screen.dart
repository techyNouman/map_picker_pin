import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'location_provider.dart';

class LocationPicker extends StatefulWidget {
  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  @override
  void initState() {
    super.initState();
    // Check for permissions and get current location
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationProvider>(context, listen: false).checkPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Location"),
      ),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          // Show loading indicator until the location is fetched
          return locationProvider.currentLocation == LatLng(0.0, 0.0)
              ? Center(child: CircularProgressIndicator())
              : Column(
            children: [
              // Display the current address
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Address: ${locationProvider.address}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              // Google Map widget
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: locationProvider.currentLocation,
                    zoom: 14.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {},
                  markers: {if (locationProvider.marker != null) locationProvider.marker!},
                  onCameraMove: (CameraPosition position) {
                    // Dynamically update the marker position while moving the map
                    locationProvider.updateLocation(position.target);
                  },
                  onCameraIdle: () {
                    // Fetch address when the camera stops moving
                    locationProvider.updateAddress(locationProvider.currentLocation);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
