/*
For 
1. Position-dependent forces
  1. Gravity
  2. Springs
  3. Coloumb Attraction between particles
  4. Gravitational attraction between particles
2. Time-dependent forces
*/

import 'package:physics_simulation/math/vecs.dart';
import 'package:physics_simulation/particle.dart';
import '/environment_variable.dart';


void VerletIntegration(Particle p) {
  Vec2 vHalf = p.vel + p.acc * (0.5 * dt);
  p.coor = p.coor + (vHalf * dt);


  p.vel = p.vel + vHalf + ((p.coor) * (dt * 0.5));
}