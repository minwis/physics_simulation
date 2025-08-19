import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:physics_simulation/math/boris_pusher.dart';
import 'package:physics_simulation/math/verlet_integration.dart';
import 'particle.dart';
import '/environment_variable.dart';
import 'vecs.dart';


class SimulationPage extends StatefulWidget {
  SimulationPage({Key? key}) : super(key: key);

  @override
  SimulationPageState createState() => SimulationPageState();
}


class SimulationPageState extends State<SimulationPage> 
  with TickerProviderStateMixin {
  late Ticker ticker;

  final List<Particle> particles = [
      Particle(Vec2(0,0),Vec2(20, 30), Vec2(0, 0), Vec2(20, 0), 2, -1, 20, Colors.green),
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

  Vec2 gravityAcceleration(double mass) { //gravitational force
    return Vec2(0, -mass * g);
  }


  Vec2 dragAcceleration(Particle p) { //
    Vec2 vFluidVec = Vec2( vFluid, vFluid);
    Vec2 relativeVel = vFluidVec - p.vel;
    Vec2 relativeVelSquared = relativeVel^2;
    return relativeVelSquared * (-0.5 * dFluid * p.A);
  }

  

  void updateAcceleration(Particle p) { //List<Particle> particles
    for (var p in particles) {
      // Reset acceleration to zero before calculating
      p.acc = p.appliedAcc + gravityAcceleration(p.m);

      verletIntegration(p);

      dragAcceleration(p);

      borisPush(p, Vec2(E, E), B);

    }
  }

//The most critical function; updates the motion of particles
  void update(List<Particle> particles) {
    for (var p in particles) {

      
      updateAcceleration(p);
      
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
