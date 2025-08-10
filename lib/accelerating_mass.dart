import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'particle/particle.dart';
import '/environment_variable.dart';
import '/math/vecs.dart';


class AcceleratingMass extends StatefulWidget {
  AcceleratingMass({Key? key}) : super(key: key);

  @override
  AcceleratingMassState createState() => AcceleratingMassState();
}



class AcceleratingMassState extends State<AcceleratingMass> 
  with TickerProviderStateMixin {
  late Ticker ticker;

  final List<Particle> particles = [
      Particle(PosVec(20, 30), VelVec(0, 30), AccVec(20, 0), 2, -1, 20, Colors.green),
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


//The most critical function; updates the motion of particles
  void update(List<Particle> particles) {
    for (var p in particles) {
  // Calculate total force on this particle from all sources:
        //Offset force = computeForcesOnParticle(p, particles, externalFields);

  // Acceleration = force / mass (unique per particle)
        //Offset acceleration = force / p.mass;

  // Update velocity and position using acceleration
        p.vel.xVel += p.acc.xAcc * dt;
        p.coor.xPos += p.vel.xVel * dt;
      }
  }
}
  
