import 'dart:math';

import 'package:flutter/material.dart';
import 'vecs.dart';

class Particle {

  double blockWidth = 50;
  
  double q = 0.0; //for simplicity of calculation; it will only hold integer values
  double m = 0; //unit: kg
  double r = 0;
  Color col = Colors.green;

  double A = 1.333333333333333 * pi; //3/4  * pi

  double dragCoeff = 0.47; //average drag coefficient of the object.

  Vec2 appliedAcc;

  Vec2 pos;

  Vec2 posPrev;
  
  Vec2 vel;

  Vec2 force;

  bool accelerate = true;

  //Vec2 
  
  Particle(this. force, this.appliedAcc, this.pos, this.posPrev, this.vel, this.m, this.q, this.r, this.col) {
    A = pi * r * r;
  }
  
  //Particle(this.appliedAcc, this.coor, this.vel, this.acc, this.m, this.q, this.r, this.col);

  Widget buildWidget() {
    return Positioned(
      
      left: pos.x,
      top: pos.y,
      
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
