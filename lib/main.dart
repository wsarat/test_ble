import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
//import 'package:rxdart/rxdart.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothScanner(),
    );
  }
}

class BluetoothScanner extends StatefulWidget {
  @override
  _BluetoothScannerState createState() => _BluetoothScannerState();
}

class _BluetoothScannerState extends State<BluetoothScanner> {
  final _ble = FlutterReactiveBle();
  final _scanResults = <DiscoveredDevice>[];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Location permission granted, start scanning for BLE devices
      startScan();
    } else {
      // Location permission not granted, handle accordingly
    }
  }

  void startScan() {
    //List<Uuid> scanList = [];
    final scanSubscription = _ble.scanForDevices(withServices: []).listen((device) {
      setState(() {
        if (!_scanResults.contains(device)) {
          _scanResults.add(device);
        }
      });
    });

    // Optionally, you can set a scan duration and stop the scan after a certain time.
    // For example, stopping the scan after 10 seconds:
    Future.delayed(Duration(seconds: 10), () {
      scanSubscription.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Scanner'),
      ),
      body: ListView.builder(
        itemCount: _scanResults.length,
        itemBuilder: (context, index) {
          DiscoveredDevice device = _scanResults[index];
          return ListTile(
            title: Text(device.id),
            subtitle: Text(device.name),
          );
        },
      ),
    );
  }
}
