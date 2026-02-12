import 'particle.dart';
import 'vecs.dart';
import 'environment_variable.dart';

Vec2 zCrossProduct(Vec2 v1, double z2) {
    // assume v1 element is 0, z2 is v2's only z element
    return Vec2(v1.y * z2, -v1.x * z2);
}

Vec2 borisPush(Particle p, Vec2 E, double dt, Vec2 vel) {

  //Step 1 in Criterion C, 5-3 Flowchart
  double t = p.q / p.m * B * 0.5 * dt;

  //Step 2 in Criterion C, 5-3 Flowchart
  double s = 2 * t / (1 + t*t);

  //Step 3 in Criterion C, 5-3 Flowchart
  Vec2 vMinus = p.velPlusHalf + (E * ((p.q / p.m) * 0.5 * dt));

  //Step 4 in Criterion C, 5-3 Flowchart
  Vec2 vPrime = vMinus + zCrossProduct(vMinus, t);

  //Step 5 in Criterion C, 5-3 Flowchart
  Vec2 vPlus = vMinus + zCrossProduct(vPrime, s);

  //Step 6 + exit in Criterion C, 5-3 Flowchart
  return vPlus + (E * ((p.q / p.m) * 0.5 * dt));
}
