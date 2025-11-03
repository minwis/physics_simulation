//import 'vecs.dart';


const double scaleFactor = 0.01; //scale factor 1: m/s; scale factor 1000: km/s

const double g = 9.8123;

const double dt = 0.01666666666667; //0.01666666666

double B = 0.01; //Unit: Tesla. 1.4 is avg. magneticc field strength of commercial available neodymium magnet

//const double vFluid = 30;

//const double dFluid = 1.29;

const double k = 0.1;



var isStop = false;

int printTime = 0;

double displayWidth = 200;

double K = 8.99e19;