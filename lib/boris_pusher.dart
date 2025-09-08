/*
Boris Pusher calculates velocity 
*/

import '/environment_variable.dart';
import '../particle.dart';
import 'vecs.dart';

Vec2 borisPush(Particle p, Vec2 E, double B, Vec2 vStar) {
  
  double qmdt2 = (p.q / p.m) * dt / 2.0;

  //half acceleration by E
  Vec2 vMinus = vStar + (E * qmdt2);

  //rotation due to B
  double t = qmdt2 * 2 * B; // Actually qB/m * dt/2, but factor 2 in s calc
  double tMag2 = t * t;
  double s = (2 * t) / (1 + tMag2);

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
  return (vPlus + (E * qmdt2));

  // Step 4: position update
  //p.pos =(p.pos + (p.vel * dt.toDouble()));
}