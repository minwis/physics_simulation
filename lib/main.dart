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
  int? _selectedParticle;

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

  Vec2 formatVecInput(String value) {
    final input = value.replaceAll(' ', '');
    final parts = input.split(',');

    double x = 0;
    double y = 0;

    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      x = double.tryParse(parts[0]) ?? 0;
    }
    if (parts.length > 1 && parts[1].isNotEmpty) {
      y = double.tryParse(parts[1]) ?? 0;
    }

    // Prevent NaN or Infinity from being returned
    if (x.isNaN || y.isNaN || x.isInfinite || y.isInfinite) {
      x = 0;
      y = 0;
    }

    return Vec2(x, y);
  }

  void addNewParticle() {
    Vec2 pos = Vec2(0, 0);
    Vec2 vel = Vec2(0, 0);
    Vec2 acc = Vec2(0, 0);
    Vec2 vMinusHalf = Vec2(0, 0);
    double m = 0.1;
    double q = 0;
    double r = 0;
    Color col = Color.fromRGBO(76, 175, 80, 1);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Particle Characteristics'),
        contentPadding: const EdgeInsets.all(20.0),
        content: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Enter Initial Position (X, Y)",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                pos = formatVecInput(value);
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Enter Initial Velocity (X, Y)",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                vel = formatVecInput(value);
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Enter Initial Acceleration (X, Y)",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                acc = formatVecInput(value);
              },
            ),
            SizedBox(height: 16),

            //scalar variable input
            TextField(
              decoration: InputDecoration(
                labelText: "Enter mass of the particle",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  m = double.tryParse(value) ?? 0.1;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Enter charge of the particle",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  q = double.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Enter display radius of the particle",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  r = double.tryParse(value) ?? 10;
                });
              },
            ),
            SizedBox(height: 16),

            Text(
              "Be sure to press 'return/enter' key when entering variables.",
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();

              SimulationPageState.particles.add(
                Particle(acc, pos, vel, vMinusHalf, m, q, r, col),
              );

              int newIndex = SimulationPageState.particles.length-1;
              particleMenuList.add(
                DropdownMenuItem<int>(
                  value: newIndex,
                  child: Text('Particle $newIndex'),
                ),
              );
              _selectedParticle = newIndex; // optional: auto-select the new one
            },

            child: const Text('Save and Add'),
          ),
        ],
      ),
    );
  }

  void adjustValues() {}

  List<DropdownMenuItem<int>> particleMenuList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Row(
        children: [
          Expanded(child: SimulationPage()),

          SizedBox(
            width: displayWidth,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Environment Variables: "),
                  Text("G Strength: $g"),
                  Text("dt: $dt"),
                  Text("B(uniform): $B"),
                  Text("Drag Coeff: $k"),

                  //choose which particle to display
                  DropdownButton(
                    menuWidth: 100,
                    value: _selectedParticle,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedParticle = newValue;
                      });
                    },
                    items: particleMenuList,
                  ),

                  Text(
                    "Particle Variables: ",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Text(
                    _selectedParticle == null
                        ? "No particle"
                        : "Mass: ${SimulationPageState.particles[_selectedParticle!].m}",
                  ),
                  Text(
                    _selectedParticle == null
                        ? "No particle"
                        : "Charge: ${SimulationPageState.particles[_selectedParticle!].q}",
                  ),
                  Text(
                    _selectedParticle == null
                        ? "No particle"
                        : "X-Coor: ${SimulationPageState.particles[_selectedParticle!].pos.x.toStringAsFixed(2)}",
                  ),
                  Text(
                    _selectedParticle == null
                        ? "No particle"
                        : "Y-Coor: ${SimulationPageState.particles[_selectedParticle!].pos.y.toStringAsFixed(2)}",
                  ),
                  Text(
                    _selectedParticle == null
                        ? "No particle"
                        : "X-Vel: ${SimulationPageState.particles[_selectedParticle!].vel.x.toStringAsFixed(2)}",
                  ),
                  Text(
                    _selectedParticle == null
                        ? "No particle"
                        : "Y-Vel: ${SimulationPageState.particles[_selectedParticle!].vel.y.toStringAsFixed(2)}",
                  ),
                  Text(
                    _selectedParticle == null
                        ? "No particle"
                        : "Drag Coeff: ${SimulationPageState.particles[_selectedParticle!].dragCoeff.toStringAsFixed(2)}",
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      _animationController.stop();
                      isStop = true;
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
                      isStop = false;
                    },
                    child: Text("Resume"),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.red,
                    ),
                    onPressed: () {
                      SimulationPageState.particles.removeWhere(
                        // ignore: unnecessary_type_check
                        (obj) => obj is Particle,
                      );
                      SimulationPageState.particles.clear();
                      particleMenuList.clear();
                    },
                    child: Text("Reset"),
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

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Adjust Values'),
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
