import 'dart:math';

import 'package:flutter/material.dart';
import 'vecs.dart';

import 'environment_variable.dart';

class Particle {
  double blockWidth = 50;

  double q =
      0.0; //for simplicity of calculation; it will only hold integer values
  double m = 0; //unit: kg
  double r = 0;
  Color col = Color.fromRGBO(76, 175, 80, 1);

  double A = 1.333333333333333 * pi; //3/4  * pi

  double dragCoeff = 0; //average drag coefficient of the object.

  Vec2 acc = Vec2(0, 0);

  Vec2 pos = Vec2(0, 0);

  Vec2 vel = Vec2(0, 0);

  bool accelerate = true;

  Vec2 vMinusHalf = Vec2(0, 0);

  double qd = 0;

  Vec2 E = Vec2(10, 10); //Unit: Newton / Columb.

  Particle(
    this.acc,
    this.pos,
    this.vel,
    this.vMinusHalf,
    this.m,
    this.q,
    this.r,
    this.col,
  ) {
    vMinusHalf = vel;
    A = pi * r * r;
    qd = dt * q / (2 * m);
  }

  //Particle(this.appliedAcc, this.coor, this.vel, this.acc, this.m, this.q, this.r, this.col);

  Widget toWidget() => Positioned(
    left: pos.x,
    top: pos.y,

    child: Container(
      width: r * 2,
      height: r * 2,
      decoration: BoxDecoration(color: col, shape: BoxShape.circle),
    ),
  );
}
