import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'particle.dart';
import '/environment_variable.dart';
import 'vecs.dart';
import '/boris_pusher.dart';

class SimulationPage extends StatefulWidget {
  const SimulationPage({super.key});

  @override
  SimulationPageState createState() => SimulationPageState();
}

class SimulationPageState extends State<SimulationPage> with TickerProviderStateMixin {
  static late Ticker ticker;

  static List<Particle> particles = [
    Particle(
      Vec2(0, 0), //force
      Vec2(0, 0), //acc
      Vec2(0, 0), //applicedAcc
      Vec2(1, 1), //pos
      Vec2(0, 0), //posPrev
      Vec2(0, 0), //vel
      Vec2(2, 0), //vMinusHalf
      0.5, // m
      -1, // q
      20, //r
      Colors.green, //col
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

  Vec2 force(Particle p) {
    //List<Particle> particles
    Vec2 force = gravity(p.m);
    //force -= drag(p.vel);
    //force += magnetic(p, p.vel);
    //force -= electric(p, E); //uniform E in current scenario
    //return force / p.m;
    return force;
  }

  void update(List<Particle> particles) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    for (var p in particles) { //iterate the "particles" list for all particles

      update_(p);//update position

      if (p.pos.x <= 0) { //particle going beyond left boundary
        p.pos.x = 0; //return the particle to the leftmost position
        p.accelerate = false; //prevent further acceleration
      } else if (p.pos.x >= screenWidth - 4 * p.r) { //particle going beyond right boundary
        p.pos.x = screenWidth - 4 * p.r; //return the particle to the rightmost position
        p.accelerate = false; //prevent further acceleration
      }

      if (p.pos.y <= 0) { //particle going beyond maximum height
        p.pos.y = 0; //return the particle to the maximum position
        p.accelerate = false; //prevent further acceleration
      } else if (p.pos.y >= screenHeight - 4 * p.r) { //particle going below minimum height
        p.pos.y = screenHeight - 4 * p.r; //return the particle to the minimum position
        p.accelerate = false; //prevent further acceleration
      }
      
    }
  }

  //explicit verlet integration
  void update_(Particle p) {
    // 1) first half-kick with force at current coordinate
    Vec2 v1 = p.vMinusHalf + force(p) * (dt / (2 * p.m));

    // 2) adjusting velocity with Boris push for Lorentz
    v1 = borisPush(p, E, B, v1);

    // 3) predict new position
    Vec2 posPred = p.pos + v1 * dt.toDouble();

    // 4) finalize position update
    p.pos = posPred;

    // 5) recompute force at predicted position
    Vec2 fPred = force(p);

    // 6) second half-kick for non-lorentz force
    Vec2 v2 = v1 + fPred * (dt / (2 * p.m));

    // 7) adjusting velocity with Boris push for Lorentz
    v2 = borisPush(p, E, B, v1);

    // 8) store velocity for next step
    p.vMinusHalf = v2;
  }
}
