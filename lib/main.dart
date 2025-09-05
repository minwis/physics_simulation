//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:physics_simulation/environment_variable.dart';
import 'acceleration.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  late AnimationController _animationController; //declaring animation controller
  
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController( //initializing animation controller
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _animationController.forward(); //starts the animation from its lower bound(0) to its upper bound

    _animationController.addListener( () { //updates the animation everytime it is called.
        setState(() {});
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      backgroundColor: const Color.fromARGB(255, 221, 240, 200),
      body: Row(
        children: [
          Expanded(child: SimulationPage()),
          
          SizedBox (
            width: 150, 
            child: SingleChildScrollView(
              child: Column(
                
                children: [
                  //SimulationPage(),

                  Text(
                    "Environment Variables: ",
                     style: TextStyle(
                      fontStyle: FontStyle.italic,
                     )
                  ),
                  Text("G Strength: $g"),
                  Text("dt: 1/6"),
                  Text("B(uniform): $B"),
                  Text("Drag Coeff: $k"),                  

                  Text(
                    "Particle Variables: ",
                     style: TextStyle(
                      fontStyle: FontStyle.italic,
                     )
                  ),
                  //Text("Environment Variables: "),
                  Text("Mass: ${SimulationPageState.particles[0].m}"),
                  Text("Charge: ${SimulationPageState.particles[0].q}"),
                  Text("X-Coor: ${SimulationPageState.particles[0].pos.x.toStringAsFixed(2)}"),
                  Text("Y-Coor: ${SimulationPageState.particles[0].pos.y.toStringAsFixed(2)}"),
                  Text("X-Vel: ${SimulationPageState.particles[0].vel.x.toStringAsFixed(2)}"),
                  Text("Y-Vel: ${SimulationPageState.particles[0].vel.y.toStringAsFixed(2)}"),
                  Text("Drag Coeff: ${SimulationPageState.particles[0].dragCoeff.toStringAsFixed(2)}"),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: (){
                      _animationController.stop();
                    },
                    child: Text("Stop")
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: (){
                      _animationController.forward();
                    },
                    child: Text("Resume")
                  ),
              ]
            ),
          )
          )
        ]
      ),

      //body: SimulationPage()
    );
  }
}