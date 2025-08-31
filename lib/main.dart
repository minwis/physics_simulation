import 'dart:async';

import 'package:flutter/material.dart';
import 'acceleration.dart';
import 'particle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      home: MyHomePage(
        title: 'Physics Simulation'
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();

      // Example: refresh every 16ms (~60fps)
      Timer.periodic(Duration(milliseconds: 16), (timer) {
        setState(() {}); // forces rebuild, pulls new pos.x/pos.y values
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Row(
        children: [
          Expanded(child: SimulationPage()),
          SizedBox (
            width: 100, 
            child: SingleChildScrollView(
              child: Column(
                
                children: [
                  //SimulationPage(),
                  Text("Mass: ${SimulationPageState.particles[0].m}"),
                  Text("Charge: ${SimulationPageState.particles[0].q}"),
                  Text("X-Coor: ${SimulationPageState.particles[0].pos.x.toStringAsFixed(2)}"),
                  Text("Y-Coor: ${SimulationPageState.particles[0].pos.y.toStringAsFixed(2)}"),
                  Text("X-Vel: ${SimulationPageState.particles[0].vel.x.toStringAsFixed(2)}"),
                  Text("Y-Vel: ${SimulationPageState.particles[0].vel.y.toStringAsFixed(2)}"),
              ]
            ),
          )
          )
        ]
      )
      //body: SimulationPage()
    );
  }
}