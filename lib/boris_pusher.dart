import 'particle.dart';
import 'vecs.dart';
import 'environment_variable.dart';

Vec2 zCrossProduct(Vec2 v1, double z2) {
    // assume v1 element is 0, z2 is v2's only z element
    return Vec2(v1.y * z2, -v1.x * z2);
}

Vec2 borisPush(Particle p, Vec2 E, double dt, Vec2 vel) {

  double t = p.q / p.m * B * 0.5 * dt; // z element only (0,0,t)
  double s = 2 * t / (1 + t*t); // z element only (0,0,s)

  Vec2 vMinus = p.vel + (E * ((p.q / p.m) * 0.5 * dt));

  Vec2 vPrime = vMinus + zCrossProduct(vMinus, t);

  Vec2 vPlus = vMinus + zCrossProduct(vPrime, s);

  return vPlus + (E * ((p.q / p.m) * 0.5 * dt));
}
