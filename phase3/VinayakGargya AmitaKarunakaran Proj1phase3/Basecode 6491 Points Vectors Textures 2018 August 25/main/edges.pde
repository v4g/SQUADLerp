class EDGE // POINT
  { 
  PNT A=P(), B=P(); // Start and End vertices
  EDGE (PNT P, PNT Q) {A.setTo(P); B.setTo(Q);}; // Creates edge
  PNT PNTnearB() {return P(B,20,Normalized(V(A,B)));}
  }
EDGE E (PNT P, PNT Q) {return new EDGE(P,Q);}

void drawEdge(EDGE E) {drawEdge(E.A,E.B);} 
void drawEdgeAsArrow(EDGE E) {arrow(E.A,E.B);} 

EDGE LERP(EDGE E0, float t, EDGE E1) // LERP between EDGE endpoints
  {
  PNT At = LERP(E0.A,time,E1.A); 
  PNT Bt = LERP(E0.B,time,E1.B);
  return E(At,Bt);
  }

// **** You must replace this code by the correct solution ***
//Amita Karunakaran
EDGE LPM(EDGE E0, float t, EDGE E1) // LERP between EDGE endpoints 
  {
  VCT V0 = V(E0.A,E0.B);
  VCT V1 = V(E1.A,E1.B);
  //VCT Vt = LPM(V0,t,V1);
  // COMPUTE THE FIXED POINT F AND USE IT
  SIMILARITY s = S(E0.A,E0.B,E1.A,E1.B);
  PNT At = s.apply(E0.A,time); 
  PNT Bt = s.apply(E0.B,time); // Bt = At + Vt (Point + Vector)
  //PNT At = LERP(E0.A,time,E1.A); 
  //PNT Bt = P(At,Vt); // Bt = At + Vt (Point + Vector)
  return E(At,Bt);
  }

EDGE NevilleLPM(float a, EDGE A,float b, EDGE B, float c, EDGE C, float d, EDGE D, float t) //creates a neville curve using LPM instead of LERP
{
  EDGE EAB = LERP(A,(t-a)/(b-a),B);
  EDGE EBC = LERP(B,(t-b)/(c-b),C);
  EDGE ECD = LERP(C,(t-c)/(d-c),D);
  
  EDGE EABC = LERP(EAB,(t-a)/(c-a),EBC);
  EDGE EBCD = LERP(EBC,(t-b)/(d-b),ECD);
  
  return LERP(EABC,(t-a)/(d-a),EBCD);
}
PNT NevilleQuadraticPNT(float a, PNT A,float b, PNT B, float c, PNT C, float t) //creates a neville curve using LPM instead of LERP
{
  //First try Neville quadratic
  PNT EAB = LERP(A,(t-a)/(b-a),B);
  PNT EBC = LERP(B,(t-b)/(c-b),C);
  PNT ABC = LERP(EAB,(t-a)/(c-a),EBC);
  
  return ABC;
}
/*PNT NevilleQuadraticPNTLPM(float a, PNT A,float b, PNT B, float c, PNT C, float t) //creates a neville curve using LPM instead of LERP
{
  //First try Neville quadratic
  PNT EAB = LPM(A,(t-a)/(b-a),B);
  PNT EBC = LPM(B,(t-b)/(c-b),C);
  PNT ABC = LPM(EAB,(t-a)/(c-a),EBC);
  
  return ABC;
}*/
EDGE NevilleQuadraticEdge(float a, EDGE A,float b, EDGE B, float c, EDGE C, float t) //creates a neville curve using LPM instead of LERP
{
  //First try Neville quadratic
  PNT ABC = NevilleQuadraticPNT(a,A.A,b,B.A,c,C.A,t);
  PNT A2B2C2 = NevilleQuadraticPNT(a,A.B,b,B.B,c,C.B,t);
  
  return E(ABC,A2B2C2);
} //<>//
PNT NevilleCubicPNT(float a, PNT A,float b, PNT B, float c, PNT C, float d, PNT D, float t) //creates a neville curve using LPM instead of LERP
{
  //Interpolate between two quadtratic points
  //That is two constant accelerations
  PNT ABC = NevilleQuadraticPNT(a,A,b,B,c,C,t);
  PNT BCD = NevilleQuadraticPNT(b,B,c,C,d,D,t);
  
  return LERP(ABC,(t-a)/(d-a),BCD);
}

EDGE NevilleCubicEdge(float a, EDGE A,float b, EDGE B, float c, EDGE C, float d, EDGE D, float t) //creates a neville curve using LPM instead of LERP
{
  //Interpolate between two quadtratic points
  //That is two constant accelerations
  PNT ABCD = NevilleCubicPNT(a,A.A,b,B.A,c,C.A,d,D.A,t);
  PNT A2B2C2D2 = NevilleCubicPNT(a,A.B,b,B.B,c,C.B,d,D.B,t);
  
  return E(ABCD,A2B2C2D2);
}
PNT NevilleCubicLPMPNT(float a, PNT A,float b, PNT B, float c, PNT C, float d, PNT D, float t) //creates a neville curve using LPM instead of LERP
{
  //Start with similarity between edge A and B
  //Do the same for the other similarity between Edges B and C
  //Interpolate the point obtained between these similarities using LERP
  
  PNT ABC = NevilleQuadraticPNT(a,A,b,B,c,C,t);
  PNT BCD = NevilleQuadraticPNT(b,B,c,C,d,D,t);
  
  return LERP(ABC,(t-a)/(d-a),BCD);
}

EDGE NevilleQuadraticEdgeLPM(float a, EDGE A,float b, EDGE B, float c, EDGE C, float t) //creates a neville curve using LPM instead of LERP
{
  //Start with similarity between edge A and B
  //Do the same for the other similarity between Edges B and C
  //Interpolate the point obtained between these similarities using LERP
  
  SIMILARITY SAB = S(A.A,A.B,B.A,B.B);
  SIMILARITY SBC = S(B.A,B.B,C.A,C.B);
  PNT AB1 = SAB.apply(A.A,(t-a)/(b-a));
  PNT AB2 = SAB.apply(A.B,(t-a)/(b-a));
  PNT BC1 = SBC.apply(B.A,(t-b)/(c-b));
  PNT BC2 = SBC.apply(B.B,(t-b)/(c-b));
  
  PNT ABC1 = LERP(AB1,(t-a)/(c-a),BC1);
  PNT ABC2 = LERP(AB2,(t-a)/(c-a),BC2);
  
  return E(ABC1,ABC2);
}

EDGE NevilleCubicEdgeLPM(float a, EDGE A,float b, EDGE B, float c, EDGE C, float d, EDGE D, float t) //creates a neville curve using LPM instead of LERP
{
  //Interpolate between two quadtratic points
  //That is two constant accelerations
  EDGE ABC = NevilleQuadraticEdgeLPM(a,A,b,B,c,C,t);
  EDGE BCD = NevilleQuadraticEdgeLPM(b,B,c,C,d,D,t);
  PNT ABCD1 = LERP(ABC.A,(t-a)/(d-a),BCD.A);
  PNT ABCD2 = LERP(ABC.B,(t-a)/(d-a),BCD.B);
  return E(ABCD1,ABCD2);
}
