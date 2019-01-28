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
