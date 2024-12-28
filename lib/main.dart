import 'package:flutter/material.dart';
import 'package:map_picker_pin/location_picker_screen.dart';
import 'package:map_picker_pin/location_provider.dart';
import 'package:provider/provider.dart';

import 'location_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationProvider(),  // Provide the LocationState
      child: MaterialApp(
        title: 'Location Picker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LocationPicker(),  // Our LocationPicker widget
      ),
    );
  }
}
