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

  double dragCoeff = 0; //average drag coefficient of the object.

  Vec2 acc = Vec2(0,0);
  
  Vec2 appliedAcc = Vec2(0,0);

  Vec2 pos = Vec2(0,0);

  Vec2 posPrev = Vec2(0,0);
  
  Vec2 vel = Vec2(0,0);

  Vec2 force = Vec2(0,0);

  bool accelerate = true;

  Vec2 vMinusHalf = Vec2(0,0);

  //Vec2 
  
  Particle(
    this.force, 
    this.acc, 
    this.appliedAcc, 
    this.pos, 
    this.posPrev, 
    this.vel, 
    this.vMinusHalf, 
    this.m, 
    this.q, 
    this.r, 
    this.col) {
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
