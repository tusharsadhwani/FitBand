import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() {
  runApp(MaterialApp(
      title: "FitBand",
      home: const HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.green,
      )));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BluetoothConnection? connection;
  var text = "";
  String temperature = 'N/A';
  String steps = 'N/A';
  String pulse = 'N/A';

  void toggleBluetooth() async {
    try {
      if (connection?.isConnected ?? false) {
        connection?.close();
        connection = null;
        setState(() {
          temperature = 'N/A';
          steps = 'N/A';
          pulse = 'N/A';
        });
        return;
      } else {
        connection?.close();
        connection = await BluetoothConnection.toAddress('98:D3:31:80:74:A6');
      }

      var currentData = "";

      connection?.input?.listen((Uint8List data) {
        final dataFromBand = ascii.decode(data);
        for (final character in dataFromBand.characters) {
          if (character == '\n') {
            final split = currentData.split(',');
            if (split.length != 3) {
              currentData = "";
              return;
            }
            currentData = "";
            setState(() {
              temperature = int.tryParse(split[0])?.toString() ?? temperature;
              steps = int.tryParse(split[1])?.toString() ?? steps;
              pulse = int.tryParse(split[2])?.toString() ?? pulse;
            });
          } else {
            currentData += character;
          }
        }
        if (ascii.decode(data).contains('!')) {
          connection?.finish();
        }
      });
    } catch (exception) {
      print("can't connect!");
      print(exception);
      connection?.close();
    }
  }

  @override
  void initState() {
    super.initState();

    toggleBluetooth();
  }

  @override
  void dispose() {
    connection?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FitBand"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: FitBandCard(
                      fitbandParameter: "Body Temperature (celcius)",
                      fitbandParameterValue: temperature),
                ),
                Expanded(
                  flex: 1,
                  child: FitBandCard(
                      fitbandParameter: "Steps Taken",
                      fitbandParameterValue: steps),
                ),
                Expanded(
                  flex: 1,
                  child: FitBandCard(
                      fitbandParameter: "Heart Rate (beats/minute)",
                      fitbandParameterValue: pulse),
                ),
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleBluetooth,
        child: const Icon(Icons.connect_without_contact),
      ),
    );
  }
}

class FitBandCard extends StatelessWidget {
  const FitBandCard(
      {Key? key,
      required this.fitbandParameter,
      required this.fitbandParameterValue})
      : super(key: key);

  final String fitbandParameter;
  final String fitbandParameterValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(fitbandParameter,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  overflow: TextOverflow.visible,
                )),
            Text(fitbandParameterValue,
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 80,
                  overflow: TextOverflow.visible,
                ))
          ],
        ),
      ),
    );
  }
}
