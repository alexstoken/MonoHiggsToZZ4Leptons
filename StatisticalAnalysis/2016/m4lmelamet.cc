//-----------------------------------------------------------------------
// Function: m4lmelamet
//           Python module jetnet
//           JETNET Version 3.4
//
//                                           f_mass4l      175.55      434.54
//                                        f_D_bkg_kin        0.48        1.17
//                                            f_pfmet       72.27      144.64
//
// Created:  Thu Feb  2 22:39:27 2017
//-----------------------------------------------------------------------
#include <cmath>
#include <vector>
//-----------------------------------------------------------------------
inline
double sigmoid(double x)
{
  return tanh(x);
}
inline
double sigmoidout(double x)
{
  return 1.0/(1+exp(-2*x));
}

void jnm4lmelamet(double* in, double* out)
{
  double x;

  double x00 = (in[0]-(175.55))/434.54;
  double x01 = (in[1]-(0.48))/1.17;
  double x02 = (in[2]-(72.27))/144.64;
  // Layer 1, Node 0
  x =        -0.621072;
  x = x +     0.384919 * x00;
  x = x +    0.0834467 * x01;
  x = x +     0.060799 * x02;
  double x10 = sigmoid(x);
  // Layer 1, Node 1
  x =        -0.748968;
  x = x -     0.151314 * x00;
  x = x +     0.156841 * x01;
  x = x +      1.89694 * x02;
  double x11 = sigmoid(x);
  // Layer 1, Node 2
  x =          1.55012;
  x = x +      7.69233 * x00;
  x = x +     0.215883 * x01;
  x = x +     0.287119 * x02;
  double x12 = sigmoid(x);
  // Layer 1, Node 3
  x =        -0.517597;
  x = x -      10.8314 * x00;
  x = x -    0.0100523 * x01;
  x = x +    0.0115008 * x02;
  double x13 = sigmoid(x);
  // Layer 1, Node 4
  x =        -0.537802;
  x = x +     0.786459 * x00;
  x = x +    0.0812996 * x01;
  x = x +     0.514409 * x02;
  double x14 = sigmoid(x);
  // Layer 1, Node 5
  x =         0.323618;
  x = x -      1.02771 * x00;
  x = x -    0.0653955 * x01;
  x = x -     0.455536 * x02;
  double x15 = sigmoid(x);
  // Layer 2, Node 0
  x =         -2.09564;
  x = x +     0.859961 * x10;
  x = x +      2.86291 * x11;
  x = x +      6.53437 * x12;
  x = x +      6.58475 * x13;
  x = x +      1.70594 * x14;
  x = x -      1.54673 * x15;
  double x20 = sigmoidout(x);
  out[0] = x20;
}

//-----------------------------------------------------------------------
double m4lmelamet(double f_mass4l,
                  double f_D_bkg_kin,
                  double f_pfmet)
{
  double inp[3];
  double out[1];
  inp[0] = f_mass4l;
  inp[1] = f_D_bkg_kin;
  inp[2] = f_pfmet;
  jnm4lmelamet(inp, out);
  return out[0];
}

//----------------------------------------------------------------------
double m4lmelamet(std::vector<double>& inp)
{
  double out[1];
  jnm4lmelamet(&inp[0], out);
  return out[0];
}

//----------------------------------------------------------------------
extern "C" double m4lmelamet_dl(std::vector<double>& inp)
{
  double out[1];
  jnm4lmelamet(&inp[0], out);
  return out[0];
}
