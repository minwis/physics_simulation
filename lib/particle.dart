import 'package:flutter/material.dart';
import '/math/vecs.dart';
import '/environment_variable.dart';

class Particle {

  double blockWidth = 50;
  
  int q = 0;
  double m = 0; //unit: kg
  double r = 0;
  Color col = Colors.green;

  double dragCoeff = 0.47; //average drag coefficient of the object.

  Vec2 coor;
  
  Vec2 vel;
  Vec2 acc;

  Particle(this.coor, this.vel, this.acc, this.m, this.q, this.r, this.col);

  Widget buildWidget() {
    return Positioned(
      left: coor.x/scaleFactor - r,
      top: coor.y/scaleFactor - r,
      child: Container(
        width: r * 2,
        height: r * 2,
        decoration: BoxDecoration(
          color: col,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
