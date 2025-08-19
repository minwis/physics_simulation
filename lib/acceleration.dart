import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'particle.dart';
import '/environment_variable.dart';
import '/math/vecs.dart';


class SimulationPage extends StatefulWidget {
  SimulationPage({Key? key}) : super(key: key);

  @override
  SimulationPageState createState() => SimulationPageState();
}


class SimulationPageState extends State<SimulationPage> 
  with TickerProviderStateMixin {
  late Ticker ticker;

  final List<Particle> particles = [
      Particle(Vec2(20, 30), Vec2(0, 0), Vec2(20, 0), 2, -1, 20, Colors.green),
  ];
  
  @override
  void initState() {
    super.initState();
    ticker = createTicker((Duration elapsed) {
      setState(() {
        update(particles);
      });
    });
    ticker.start();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: particles.map((p) => p.buildWidget()).toList(),
        ),
      ),
    );
    
  }

  Vec2 gravityAcceleration(double mass) {
    return Vec2(0, mass * g);
  }

/*
  AccVec dragAcceleration(Particle p) {
    
    //return -0.5 * (p_fluid * )
  }*/

  

  void calculateAcceleration(List<Particle> particles) {
    for (var p in particles) {
      // Reset acceleration to zero before calculating
      
      p.acc.x = 0;
      p.acc.y = 0;



      // Apply a constant acceleration
      p.acc.y = -g; // Gravity acting downwards
    }
  }

//The most critical function; updates the motion of particles
  void update(List<Particle> particles) {
    for (var p in particles) {

      

      
  // Calculate total force on this particle from all sources:
        //Offset force = computeForcesOnParticle(p, particles, externalFields);

  // Acceleration = force / mass (unique per particle)
        //Offset acceleration = force / p.mass;

  // Update velocity and position using acceleration
        p.vel.x += p.acc.x * dt;
        p.coor.x += p.vel.x * dt;
      }
  }
}
