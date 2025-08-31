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
                  Text("Mass: ${SimulationPageState.particles[0].m}"),
                  Text("Charge: ${SimulationPageState.particles[0].q}"),
                  Text("X-Cooo: ${SimulationPageState.particles[0].pos.x}"),
                  Text("X-Cooo: ${SimulationPageState.particles[0].pos.y}"),
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