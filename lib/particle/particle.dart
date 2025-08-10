import 'package:flutter/material.dart';
import '/math/vecs.dart';
import '/environment_variable.dart';

class Particle {

  double blockWidth = 50;
  
  int q = 0;
  double m = 1; //unit: kg
  double r = 2;
  Color col = Colors.green;

  PosVec coor;
  VelVec vel;
  AccVec acc;

  void adjustScale() {
    vel.xVel /= scaleFactor;
    vel.yVel /= scaleFactor;
    acc.xAcc /= scaleFactor;
    acc.yAcc /= scaleFactor;
  }

  Particle(this.coor, this.vel, this.acc, this.m, this.q, this.r, this.col);

  Widget buildWidget() {
    adjustScale();
    return Positioned(
      left: coor.xPos - r,
      top: coor.yPos - r,
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
