/*
Boris Pusher calculates velocity 
*/

import 'particle.dart';
import 'vecs.dart';
import 'environment_variable.dart';

Vec2 zCrossProduct(Vec2 v1, double z2) {
    // assume v1 element is 0, z2 is v2's only z element
    return Vec2(v1.y * z2, -v1.x * z2);
}

void borisPush(Particle p, Vec2 E, double dt) {

  Vec2 vMinus;
  Vec2 vPrime;
  Vec2 vPlus;
  double t;
  double s;

  t = p.q / p.m * B * 0.5 * dt; // z element only (0,0,t)
  s = 2 * t / (1 + t*t); // z element only (0,0,s)

  vMinus = p.vel + (E * ((p.q / p.m) * 0.5 * dt));

  vPrime = vMinus + zCrossProduct(vMinus, t);

  vPlus = vMinus + zCrossProduct(vPrime, s);

  p.vel = vPlus + (E * ((p.q / p.m) * 0.5 * dt));
}
