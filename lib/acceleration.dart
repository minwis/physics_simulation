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
  late Ticker ticker;

  static List<Particle> particles = [
    Particle(
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

  Vec2 drag(Particle p, Vec2 velVec) {
    Vec2 vFluidVec = Vec2(vFluid, vFluid);
    Vec2 relativeVel = vFluidVec - velVec;
    Vec2 relativeVelSquared = relativeVel^2;
    return relativeVelSquared * (-0.5 * dFluid * p.A / p.m);
    //return Vec2(0, 0);
  }

  Vec2 magnetic(Particle p, Vec2 velVec) {
    Vec2 lorentzForce = velVec * (B * p.q); //assumes sin(theta) = 1
    return lorentzForce;
  }

  Vec2 electric(Particle p, Vec2 E) {
    Vec2 electricForce = E * p.q;
    return electricForce;
  }

  Vec2 acceleration(Particle p) {
    //List<Particle> particles
    Vec2 force = gravity(p.m);
    force += drag(p, p.vel);
    force += magnetic(p, p.vel);
    force += electric(p, E); //uniform E in current scenario
    return force / p.m;
  }

  void update(List<Particle> particles) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    for (var p in particles) {
      Vec2 acc = acceleration(p);
      p.vel = p.vel + (acc * dt);
      p.pos = p.pos + p.vel * dt;

      // boundaries
      if (p.pos.x <= 0) {
        p.pos.x = 0;
        p.vel.x = 0;
        p.maxVel = p.vel;
      } else if (p.pos.x >= screenWidth - 4 * p.r) {
        p.pos.x = screenWidth - 4 * p.r;
        p.vel.x = 0;
        p.maxVel = p.vel;
      }

      if (p.pos.y <= 0) {
        p.pos.y = 0;
        p.vel.y = 0;
        p.maxVel = p.vel;
      } else if (p.pos.y >= screenHeight - 4 * p.r) {
        p.pos.y = screenHeight - 4 * p.r;
        //print(p.vel.y);
        p.vel.y = 0;
        
      }
    }
  }

  void velocityVerlet(Particle p) {
    //update position
    Vec2 acc = acceleration(p);
    p.pos = p.pos + (p.pos - p.posPrev) + acc * (dt) * (dt);

    //update velocity and acceleration
    //Vec2 velNew = p.vel + 0.5 * (acc + )

    //p.vel = p.vel + ()
  }
}
