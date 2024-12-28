
import 'package:flutter/material.dart';

class LocationState with ChangeNotifier {
  double _latitude = 37.7749;  // Default to San Francisco (you can set your default location)
  double _longitude = -122.4194;

  double get latitude => _latitude;
  double get longitude => _longitude;

  // Method to update the location
  void updateLocation(double latitude, double longitude) {
    _latitude = latitude;
    _longitude = longitude;
    notifyListeners();
  }
}
