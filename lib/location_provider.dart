import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider extends ChangeNotifier {
  // Initial location and address
  LatLng _currentLocation = LatLng(0.0, 0.0); // Set initial location to 0.0, 0.0
  String _address = 'Fetching address...';
  Marker? _marker;

  // Getter for location and address
  LatLng get currentLocation => _currentLocation;
  String get address => _address;
  Marker? get marker => _marker;

  // Method to check and request location permissions
  Future<void> checkPermissions() async {
    // Check the current permission status
    LocationPermission permissionStatus = await Geolocator.checkPermission();

    if (permissionStatus == LocationPermission.denied) {
      // If permission is denied, request it
      permissionStatus = await Geolocator.requestPermission();
    }

    // If permission is denied forever or denied, handle accordingly
    if (permissionStatus == LocationPermission.deniedForever || permissionStatus == LocationPermission.denied) {
      // Handle denied permission
      _address = "Permission denied.";
      notifyListeners();
    } else {
      // Permissions granted, now get the current location
      await getCurrentLocation();
    }
  }

  // Method to get the current location using Geolocator
  Future<void> getCurrentLocation() async {
    try {
      // Get the current position from Geolocator
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentLocation = LatLng(position.latitude, position.longitude);
      _marker = Marker(
        markerId: MarkerId("pin"),
        position: _currentLocation,
        draggable: false, // Marker is not draggable
      );

      // Fetch the address based on the current coordinates
      await _getAddressFromCoordinates(position.latitude, position.longitude);
      notifyListeners(); // Notify listeners about the changes
    } catch (e) {
      print("Error fetching location: $e");
      _address = "Error fetching location";
      notifyListeners();
    }
  }

  // Method to update the location based on map camera position
  void updateLocation(LatLng newLocation) {
    _currentLocation = newLocation;
    _marker = Marker(
      markerId: MarkerId("pin"),
      position: _currentLocation,
      draggable: false, // Marker is not draggable
    );
    notifyListeners(); // Notify listeners
  }

  // Method to fetch address using reverse geocoding
  Future<void> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark placemark = placemarks[0];
      _address = '${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
    } catch (e) {
      print("Error fetching address: $e");
      _address = "Unable to fetch address";
    }
  }

  // Method to update the address when camera stops moving (onCameraIdle)
  Future<void> updateAddress(LatLng location) async {
    await _getAddressFromCoordinates(location.latitude, location.longitude);
    notifyListeners(); // Notify listeners about the updated address
  }
}
