import 'dart:math';

class Vec2 {
  double x, y;

  Vec2(this.x, this.y);

  Vec2 operator +(Vec2 o) => Vec2(x + o.x, y + o.y);
  Vec2 operator -(Vec2 o) => Vec2(x - o.x, y - o.y);
  Vec2 operator *(double s) => Vec2(x * s, y * s);
  Vec2 operator /(double s) => Vec2(x / s, y / s);
  Vec2 operator ^(double s) => Vec2(pow(x, s).toDouble(), pow(x, y).toDouble());
}