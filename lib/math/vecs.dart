class Vec2 {
  double x, y;

  Vec2(this.x, this.y);

  Vec2 operator +(Vec2 o) => Vec2(x + o.x, y + o.y);
  Vec2 operator -(Vec2 o) => Vec2(x - o.x, y - o.y);
  Vec2 operator *(double s) => Vec2(x * s, y * s);
  Vec2 operator /(double s) => Vec2(x / s, y / s);
}

class PosVec extends Vec2 {
  PosVec(double xPos, double yPos) : super(xPos, yPos);
  double get xPos => x;
  set xPos(double value) => x = value;
  double get yPos => y;
  set yPos(double value) => y = value;
}

class VelVec extends Vec2 {
  VelVec(double xVel, double yVel) : super(xVel, yVel);
  double get xVel => x;
  set xVel(double value) => x = value;
  double get yVel => y;
  set yVel(double value) => y = value;

}

class AccVec extends Vec2 {
  AccVec(double xAcc, double yAcc) : super(xAcc, yAcc);
  double get xAcc => x;
  set xAcc(double value) => x = value;
  double get yAcc => y; 
  set yAcc(double value) => y = value;
}
