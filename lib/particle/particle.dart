import 'package:flutter/material.dart';

import '/environment_variable.dart';

class Coordinate {
  double xPos = 0;
  double yPos = 0;
  Coordinate(this.xPos, this.yPos);
}

class Velocity_ {
  double xVel = 0;
  double yVel = 0;
  Velocity_(this.xVel, this.yVel);
}

class Acceleration {
  double xAcc = 0;
  double yAcc = 0;
  Acceleration(this.xAcc, this.yAcc);
}

class Particle {

  double blockWidth = 50;
  
  int charge = 0;
  double mass = 1; //unit: kg
  double radius = 2;
  Color color = Colors.green;

  Coordinate coor;
  Velocity_ vel;
  Acceleration acc;

  void adjustScale() {
    vel.xVel /= scaleFactor;
    vel.yVel /= scaleFactor;
    acc.xAcc /= scaleFactor;
    acc.yAcc /= scaleFactor;
  }

  Particle(this.coor, this.vel, this.acc, this.mass, this.charge, this.radius, this.color);

  Widget buildWidget() {
    return Positioned(
      left: coor.xPos - radius,
      top: coor.yPos - radius,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
