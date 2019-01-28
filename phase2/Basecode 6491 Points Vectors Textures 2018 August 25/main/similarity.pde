//Amita Karunakaran
class SIMILARITY{
  float angle;
  float scale;
  PNT F = P();
  SIMILARITY(float angle_p, float scale_p, PNT F_p){
    angle = angle_p;
    scale = scale_p;
    F = F_p;
  }
//Vinayak Gargya  
  PNT apply(PNT P, float t){
    VCT AP = V(F,P);
    VCT APmod = Scaled(pow(scale,t),(Rotated(AP,angle * t)));
    PNT newP = P(F,APmod);
    return newP;
  }
}
//Amita Karunakaran
SIMILARITY S(PNT A0, PNT B0, PNT A1, PNT B1){
  VCT AB0 = V(A0,B0); //<>//
  VCT AB1 = V(A1,B1);
  VCT A0A1 = V(A1,A0);
  float LenAB0 = normOf(AB0);
  float LenAB1 = normOf(AB1);
  float scale = LenAB1/LenAB0;
  float angle = angle(AB0,AB1);
  VCT w = V(scale * cos(angle) - 1, scale * sin(angle));
  float d = dot(w,w);
  if(d == 0.0f)
    d = 0.01f;
  VCT iv = V(dot(w,A0A1), dot(Rotated(w),A0A1));
  iv = Divided(iv,d);
  PNT F = P(A0,iv);
  return new SIMILARITY(angle, scale, F);
}


PNT commuteAndApply(PNT p, SIMILARITY s1, float t1,SIMILARITY s2, float t2){
  VCT AP = V(s1.F, p);
  float scale = pow(s1.scale,t1) * pow(s2.scale,t2);
  float angle = s1.angle * t1 + s2.angle * t2;
  VCT APNew = Scaled(scale,Rotated(AP, angle));
  PNT FPNew = P(s1.F,APNew);
  return FPNew;
}
