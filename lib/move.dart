import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'particle.dart';
import '/environment_variable.dart';
import 'vecs.dart';
import 'boris_pusher.dart';
import 'dart:math';

class SimulationPage extends StatefulWidget {
  const SimulationPage({super.key});

  @override
  SimulationPageState createState() => SimulationPageState();
}

class SimulationPageState extends State<SimulationPage> with TickerProviderStateMixin {
  static late Ticker ticker;

  static List<Particle> particles = [];


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
      body: Stack(children: particles.map((p) => p.toWidget()).toList()),
    );
  }

  void update(List<Particle> particles) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    for (int i = 0; i < particles.length; i++ ) { //iterate the "particles" list for all particles
      
      if (particles[i].pos.x <= 0) { //particle going beyond left boundary
        particles[i].pos.x = 1; //return the particle to the leftmost position
        particles[i].accelerate = false; //prevent further acceleration
      } else if (particles[i].pos.x >= screenWidth - 4 * particles[i].r - displayWidth) { //particle going beyond right boundary
        particles[i].pos.x = screenWidth - 4 * particles[i].r - 1; //return the particle to the rightmost position
        particles[i].accelerate = false; //prevent further acceleration
      }

      if (particles[i].pos.y <= 0) { //particle going beyond maximum height
        particles[i].pos.y = 1; //return the particle to the maximum position
        particles[i].accelerate = false; //prevent further acceleration
      } else if (particles[i].pos.y >= screenHeight - 4 * particles[i].r) { //particle going below minimum height
        particles[i].pos.y = screenHeight - 4 * particles[i].r - 1; //return the particle to the minimum position
        particles[i].accelerate = false; //prevent further acceleration
      }

      updatePosition(particles[i], i); //update position
      
    }
  }

    Vec2 gravityAcc(double mass) { //gravitational force
    return Vec2(0, g);
  }

  Vec2 drag(Vec2 velVec) {
    /*Vec2 vFluidVec = Vec2(vFluid, vFluid);
    Vec2 relativeVel = vFluidVec - velVec;
    //Vec2 relativeVelSquared = relativeVel^2;
    Vec2 dragForce = relativeVel * (0.5 * dFluid * p.A);
    return Vec2(dragForce.x.abs(), dragForce.y.abs());*/
    return velVec * k;
  }

  Vec2 calculateAcc(Particle p) {
    Vec2 acc = p.acc;
    acc += gravityAcc(p.m);
    
    return acc;
  }

  //explicit verlet integration
  void updatePosition(Particle p, int n) {
    if ( !p.accelerate || isStop ) return;

    double d = 0;
    double degree = 0;
    double f = 0;
    Vec2 fVec = Vec2(0,0);
    for ( int i = 0; i < particles.length; i++ ) {
      if ( i == n && (particles[i].vel.x == 0 || particles[i].vel.y == 0) ) continue;

      d = (((particles[i].pos.x - p.pos.x) * (particles[i].pos.x - p.pos.x)) + ((particles[i].pos.y - p.pos.y) * (particles[i].pos.y - p.pos.y)) );
      degree = atan((particles[i].pos.y - p.pos.y) / (particles[i].pos.x - p.pos.x));
      f = particles[i].q * K / (d*d);
      fVec.x = f * cos(degree);
      fVec.y = f * sin(degree);

      p.E = p.E + fVec;
    }
  }
}

