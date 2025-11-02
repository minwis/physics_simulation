import 'package:flutter/material.dart';
import 'package:physics_simulation/environment_variable.dart';
import 'move.dart';
import 'particle.dart';
import 'vecs.dart';

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
      home: MyHomePage(title: 'Physics Simulation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController
  _animationController; //declaring animation controller

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      //initializing animation controller
      duration: Duration(minutes: 120),
      vsync: this,
    );

    _animationController
        .forward(); //starts the animation from its lower bound(0) to its upper bound

    _animationController.addListener(() {
      //updates the animation everytime it is called.
      setState(() {});
    });
  }

  void addNewParticle() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              SimulationPageState.particles.add(
                Particle(
                  Vec2(0, 0), //force
                  Vec2(0, 0), //acc
                  Vec2(0, 0), //applicedAcc
                  Vec2(0, 0), //pos
                  Vec2(0, 0), //posPrev
                  Vec2(0, 0), //vel
                  Vec2(0, 0), //vMinusHalf
                  0, // m
                  0, // q
                  0, //r
                  Colors.green, //col; color.
                ),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
        title: const Text('Particle Characteristics'),
        contentPadding: const EdgeInsets.all(20.0),
        content: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Enter mass of the particle",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  SimulationPageState.particles.last.m =
                      double.tryParse(value) ?? 0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Enter Position (X, Y) e.g., 5.0, -10.2",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                //eliminate all spacing
                String input = value.replaceAll(' ', ''); 
                //split x and y values with comma
                List<String> parts = input.split(','); 
                //if comma is used
                if (parts.length == 2) { 
                  setState(() {
                    //if x value is not empty, update the x position
                    if (parts.first != '') { 
                      SimulationPageState.particles.last.pos.x =
                          //converts parts.first(string) to x(double)
                          double.tryParse(parts.first) ??
                          //if parsing fails, keep the previous position
                          SimulationPageState.particles.last.pos.x; 
                    }
                    if (parts.last != '') {
                      SimulationPageState.particles.last.pos.y =
                          double.tryParse(parts.last) ??
                          SimulationPageState.particles.last.pos.x;
                    }
                  });
                }
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Row(
        children: [
          Expanded(child: SimulationPage()),

          
          SizedBox(
            width: 200,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Environment Variables: ",
                    //style: TextStyle(fontStyle: italic),
                  ),
                  Text("G Strength: $g"),
                  Text("dt: $dt"),
                  Text("B(uniform): $B"),
                  Text("Drag Coeff: $k"),

                  Text(
                    "Particle Variables: ",
                    //style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Text("Mass: ${SimulationPageState.particles[0].m}"),
                  Text("Charge: ${SimulationPageState.particles[0].q}"),
                  Text(
                    "X-Coor: ${SimulationPageState.particles[0].pos.x.toStringAsFixed(2)}",
                  ),
                  Text(
                    "Y-Coor: ${SimulationPageState.particles[0].pos.y.toStringAsFixed(2)}",
                  ),
                  Text(
                    "X-Vel: ${SimulationPageState.particles[0].vel.x.toStringAsFixed(2)}",
                  ),
                  Text(
                    "Y-Vel: ${SimulationPageState.particles[0].vel.y.toStringAsFixed(2)}",
                  ),
                  Text(
                    "Drag Coeff: ${SimulationPageState.particles[0].dragCoeff.toStringAsFixed(2)}",
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      _animationController.stop();
                      isStop = !isStop;
                    },
                    child: Text("Stop"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      _animationController.forward();
                    },
                    child: Text("Resume"),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Add New Particle'),
                    onPressed: () {
                      addNewParticle();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
