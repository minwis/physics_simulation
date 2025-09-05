import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'particle.dart';
import '/environment_variable.dart';
import 'vecs.dart';

class SimulationPage extends StatefulWidget {
  const SimulationPage({super.key});

  @override
  SimulationPageState createState() => SimulationPageState();
}

class SimulationPageState extends State<SimulationPage>
    with TickerProviderStateMixin {
  static late Ticker ticker;

  static List<Particle> particles = [
    Particle(
      Vec2(0, 0),
      Vec2(0, 0),
      Vec2(0, 0),
      Vec2(1, 1),
      Vec2(0, 0),
      Vec2(0, 0),
      0.5,
      -1,
      20,
      Colors.green,
    ),
  ];

  List<Particle> particlesGetter() {
    return particles;
  }

  void muteTicker() {
    ticker.muted = true;
  }
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
    return Scaffold(
      body: Stack(children: particles.map((p) => p.buildWidget()).toList()),
    );
  }

  Vec2 gravity(double mass) {
    //gravitational force
    return Vec2(0, g * mass);
  }

  Vec2 drag(Vec2 velVec) {
    /*Vec2 vFluidVec = Vec2(vFluid, vFluid);
    Vec2 relativeVel = vFluidVec - velVec;
    //Vec2 relativeVelSquared = relativeVel^2;
    Vec2 dragForce = relativeVel * (0.5 * dFluid * p.A);
    return Vec2(dragForce.x.abs(), dragForce.y.abs());*/
    return velVec * k;
  
  }

  Vec2 magnetic(Particle p, Vec2 velVec) {
    Vec2 lorentzForce = velVec * (B * p.q); //assumes sin(theta) = 1
    return Vec2(lorentzForce.x.abs(), lorentzForce.y.abs());
  }

  Vec2 electric(Particle p, Vec2 E) {
    Vec2 electricForce = E * p.q;
    return electricForce;
  }

  Vec2 acceleration(Particle p) {
    //List<Particle> particles
    Vec2 force = gravity(p.m);
    //force -= drag(p.vel);
    force += magnetic(p, p.vel);
    //force -= electric(p, E); //uniform E in current scenario
    return force / p.m;
  }

  void update(List<Particle> particles) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    for (var p in particles) {
      if ( p.accelerate ) {
        Vec2 acc = acceleration(p);
        p.vel = p.vel + (acc * (dt.toDouble()));
        p.posPrev = p.pos; //saving previous position.
        p.pos = p.pos + p.vel * (dt.toDouble());
      }
      

      // boundaries
      if (p.pos.x <= 0) {
        p.pos.x = 0;
        //p.vel.x = 0;
        p.accelerate = false;
      } else if (p.pos.x >= screenWidth - 4 * p.r) {
        p.pos.x = screenWidth - 4 * p.r;
        //p.vel.x = 0;
        p.accelerate = false;
      }

      if (p.pos.y <= 0) {
        p.pos.y = 0;
        //p.vel.y = 0;
        p.accelerate = false;
      } else if (p.pos.y >= screenHeight - 4 * p.r) {
        p.pos.y = screenHeight - 4 * p.r;
        //p.vel.y = 0;
        p.accelerate = false;
        
      }
    }
  }

  //explicit verlet integration
  void velocityVerlet(Particle p) { 
    //save current position to the previous position. 
    p.posPrev = p.pos; 

    //calculate current acceleration. both velocity-dependent and velocity-not-dependent forces are acting on the system
    p.acc = acceleration(p);
    
    //update position. standard explicit verlet integration
    p.pos = p.pos + (((p.pos - p.posPrev) * (dt.toDouble()) ) + (p.acc * ( (dt.toDouble()) * (dt.toDouble()) * 0.5))); //update position

    //update velocity - Predictor Corrector
    //acceleration and velocity have inter-dependency, so standard explicit verlet integration cannot apply
    
  }
}
