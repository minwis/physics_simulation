/*
Boris Pusher calculates velocity 
*/

import '/environment_variable.dart';
import '../particle.dart';
import 'vecs.dart';

Vec2 borisPush(Particle p, Vec2 E, double B, Vec2 v) {
  
  double t = (p.q / p.m) * dt * 0.5 * B;

  //rotation scalar
  double s = (2 * t) / (1 + t * t);

  //half acceleration by E
  Vec2 vMinus = v + (E * ((p.q / p.m) * dt / 2.0));

  // Rotate vMinus in plane
  // v' = vMinus + vMinus × t (in 2D, cross with z is just rotate 90°)
  Vec2 vPrime = Vec2(
    vMinus.x + vMinus.y * t,
    vMinus.y - vMinus.x * t,
  );

  // vPlus = vMinus + vPrime × s
  Vec2 vPlus = Vec2(
    vMinus.x + vPrime.y * s,
    vMinus.y - vPrime.x * s,
  );

  // Step 3: half acceleration by E again
  return (vPlus + (E * t));

  // Step 4: position update
  //p.pos =(p.pos + (p.vel * dt.toDouble()));
}