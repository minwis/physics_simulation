import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'particle.dart';
import '/environment_variable.dart';
import 'vecs.dart';
//import 'dart:math';
import 'boris_pusher.dart';

class SimulationPage extends StatefulWidget {
  const SimulationPage({super.key});

  @override
  SimulationPageState createState() => SimulationPageState();
}

class SimulationPageState extends State<SimulationPage>
    with TickerProviderStateMixin {
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
    for (int i = 0; i < particles.length; i++) {
      //iterate the "particles" list for all particles

      
      if (particles[i].pos.x <= 0) {
        //particle going beyond left boundary
        particles[i].pos.x = 1; //return the particle to the leftmost position
        particles[i].accelerate = false; //prevent further acceleration
      } else if (particles[i].pos.x >=
          screenWidth - 4 * particles[i].r - displayWidth) {
        //particle going beyond right boundary
        particles[i].pos.x =
            screenWidth -
            4 * particles[i].r -
            1; //return the particle to the rightmost position
        particles[i].accelerate = false; //prevent further acceleration
      }

      if (particles[i].pos.y <= 0) {
        //particle going beyond maximum height
        particles[i].pos.y = 1; //return the particle to the maximum position
        particles[i].accelerate = false; //prevent further acceleration
      } else if (particles[i].pos.y >= screenHeight - 4 * particles[i].r) {
        //particle going below minimum height
        particles[i].pos.y =
            screenHeight -
            4 * particles[i].r -
            1; //return the particle to the minimum position
        particles[i].accelerate = false; //prevent further acceleration
      }

      if ( particles[i].accelerate && !isStop ) {
        updatePosition(particles[i], i);
      }
    }
  }

  Vec2 gravityAcc(double mass) {
    //gravitational force
    return Vec2(0, g);
  }

  Vec2 drag(Vec2 velVec) {
    return velVec * k;
  }

  Vec2 calculateAcc(Particle p) {
    Vec2 acc = p.acc;
    acc += gravityAcc(p.m);

    return acc;
  }

  void updatePosition(Particle p, int n) {
    //Step 1 in Criterion C, 5-2-2 Flowchart
    Vec2 acc = calculateAcc(p);
    p.velPlusHalf = p.vel + acc * (dt / 2);

    //Step 2 in Criterion C, 5-2-2 Flowchart
    p.velPlusHalf = borisPush(p, p.E, B, p.velPlusHalf);

    //Step 3 in Criterion C, 5-2-2 Flowchart
    p.pos = p.pos + p.velPlusHalf * dt.toDouble();

    //Step 4 in Criterion C, 5-2-2 Flowchart
    Vec2 accPredict = calculateAcc(p);
    p.vel = p.velPlusHalf + accPredict * (dt / (2));
  }

}
