import 'vecs.dart';


const double scaleFactor = 0.01; //scale factor 1: m/s; scale factor 1000: km/s

const double g = 9.8123;

const int dt = 1000; //in miliseconds. * 1000. dt = 1000 --> 1 sec

const double B = 1.4; //Unit: Tesla. 1.4 is avg. magneticc field strength of commercial available neodymium magnet

Vec2 E = Vec2(0,2); //Unit: Newton / Columb. 

//const double vFluid = 30;

//const double dFluid = 1.29;

const double k = 0.1;
