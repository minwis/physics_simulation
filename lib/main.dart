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
      
      
      int _selectedParticle = 0;
      
      
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
        double x = 0;
        double y = 0;

        //eliminate all spacing
        String input = value.replaceAll(' ', '');
        //split x and y values with comma
        List<String> parts = input.split(','); 
        //if comma is used
        if (parts.length == 2) { 
          setState(() {
            //if x value is not empty, update the x position
            if (parts.first != '') { 
              //converts parts.first(string) to x(double)
              x = double.tryParse(parts.first) ?? 0;
            }
            if (parts.last != '') {
              y = double.tryParse(parts.last) ?? 0;
            }
          });
        }

        return Vec2(x, y);
      }

      void addNewParticle() {
        Vec2 pos = Vec2(0,0);
        Vec2 vel = Vec2(0,0);
        Vec2 acc = Vec2(0,0);
        Vec2 vMinusHalf = Vec2(0,0);
        double m = 0.1; 
        double q = 0;
        double r = 0; 
        Color col = Color.fromRGBO(76, 175, 80, 1);
        
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
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
                  particleMenuList.add(
                    DropdownMenuItem<int> (
                      value: SimulationPageState.particles.length,
                      child: Text('Particle ${SimulationPageState.particles.length}')
                    )
                  );
                  SimulationPageState.particles.add(
                    Particle(
                      acc,
                      pos,
                      vel,
                      vMinusHalf,
                      m,
                      q,
                      r,
                      col,
                    ),
                  );
                },
                child: const Text('Save and Add'),
              ),
            ],

            //vector variable input
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
                  onSubmitted: (value) {
                    vel = formatVecInput(value);
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Enter Initial Acceleration (X, Y)",
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
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
                    labelText: "Enter radius of the particle",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      r = double.tryParse(value) ?? 0;
                    });
                  },
                ),
                SizedBox(height: 16),

                //color input
                /*TextField(
                  decoration: InputDecoration(
                    labelText: "Enter color of the particle",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      r = double.tryParse(value) ?? 0;
                    });
                  },
                ),*/
              ],
            ),
          ),
        );
      }

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
                width: 400,
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


                      //choose which particle to display
                      DropdownButton(
                        menuWidth: 50,
                        value: _selectedParticle,
                        //icon: const Icon(Icons.menu),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                        onChanged: (int? newValue) {
                          setState( () {
                            _selectedParticle = newValue ?? 0;
                          });
                        },
                        items: particleMenuList
                      ),


                      
                      Text(
                        "Particle Variables: ",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      Text(
                        SimulationPageState.particles.isEmpty
                        ? "No particle"
                        : "Mass: ${SimulationPageState.particles[_selectedParticle].m}"
                      ),
                      Text(
                        SimulationPageState.particles.isEmpty
                        ? "No particle"
                        : "Charge: ${SimulationPageState.particles[_selectedParticle].q}"
                      ),
                      Text(
                        SimulationPageState.particles.isEmpty
                        ? "No particle"
                        : "X-Coor: ${SimulationPageState.particles[_selectedParticle].pos.x.toStringAsFixed(2)}",
                      ),
                      Text(
                        SimulationPageState.particles.isEmpty
                        ? "No particle"
                        : "Y-Coor: ${SimulationPageState.particles[_selectedParticle].pos.y.toStringAsFixed(2)}",
                      ),
                      Text(
                        SimulationPageState.particles.isEmpty
                        ? "No particle"
                        : "X-Vel: ${SimulationPageState.particles[_selectedParticle].vel.x.toStringAsFixed(2)}",
                      ),
                      Text(
                        SimulationPageState.particles.isEmpty
                        ? "No particle"
                        : "Y-Vel: ${SimulationPageState.particles[_selectedParticle].vel.y.toStringAsFixed(2)}",
                      ),
                      Text(
                        SimulationPageState.particles.isEmpty
                        ? "No particle"
                        : "Drag Coeff: ${SimulationPageState.particles[_selectedParticle].dragCoeff.toStringAsFixed(2)}",
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
