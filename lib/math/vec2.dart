class FinalVec {
  double horizontal = 0;
  double vertical = 0;

  FinalVec(this.horizontal, this.vertical);
}

class vec2 { //calculates 
  FinalVec vectorAdd2D(double vel1_h, double vel1_v, double vel2_h, double vel2_v) {
    return FinalVec(vel1_h+vel2_h, vel1_v+vel2_v);
  }
}