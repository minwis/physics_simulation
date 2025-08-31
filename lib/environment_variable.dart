import 'vecs.dart';


const double scaleFactor = 0.01; //scale factor 1: m/s; scale factor 1000: km/s

const double g = 9.8123;

const double dt = 1/60; //60 FPS. 1 being maximum. < 1 --> slow down
//const double dt = 1;

const double B = 1.4; //Unit: Tesla. 1.4 is avg. magneticc field strength of commercial available neodymium magnet

Vec2 E = Vec2(0,2); //Unit: Newton / Columb. 

const double vFluid = 0;

const double dFluid = 997;