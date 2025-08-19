import 'dart:math';

import 'package:flutter/material.dart';
import 'vecs.dart';
import '/environment_variable.dart';

class Particle {

  double blockWidth = 50;
  
  int q = 0;
  double m = 0; //unit: kg
  double r = 0;
  Color col = Colors.green;

  double A = 1.333333333333333 * pi; //3/4  * pi

  double dragCoeff = 0.47; //average drag coefficient of the object.

  Vec2 appliedAcc;

  Vec2 coor;
  
  Vec2 vel;
  Vec2 acc;
  
  Particle(this.appliedAcc, this.coor, this.vel, this.acc, this.m, this.q, this.r, this.col) {
    A = r*r*r;
  }
  
  //Particle(this.appliedAcc, this.coor, this.vel, this.acc, this.m, this.q, this.r, this.col);

  Widget buildWidget() {
    return Positioned(
      
      left: (coor.x - r) * scaleFactor,
      top: (coor.y - r) * scaleFactor,
      
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
