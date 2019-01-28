void  LERPquads(PNT A, PNT B, PNT C, PNT D, PNT[] Point, float time)
  {
  int i=0;
  
  A.setTo(LERP(Point[i],time,Point[12+i++]));
  B.setTo(LERP(Point[i],time,Point[12+i++]));
  C.setTo(LERP(Point[i],time,Point[12+i++]));
  D.setTo(LERP(Point[i],time,Point[12+i++]));
  }
  
  /**
  Created this method to compute multi quad LERP with multi quad SQUINT
  Amita Karunakaram
  */
void  LERPquadsMulti(PNT A, PNT B, PNT C, PNT D, PNT[] Point, float time, int n)
  {
  int i=0;
  n = n * 4;
  A.setTo(LERP(Point[i+n],time,Point[n+4+i++]));
  B.setTo(LERP(Point[i+n],time,Point[4+n+i++]));
  C.setTo(LERP(Point[i+n],time,Point[4+n+i++]));
  D.setTo(LERP(Point[i+n],time,Point[4+n+i++]));
  }
  
/** Create SQUINT using two quads*/ 
//Vinayak Gargya
void  SQUINTquads(PNT A, PNT B, PNT C, PNT D, PNT[] Point, float time)
{
  SIMILARITY[] s = new SIMILARITY[4];
  for (int i=0; i < 4; i++)
  {
    s[i] = S(Point[i],Point[(i+1)%4],Point[4 + i],Point[4 + ((i+1)%4)]);
  }
  PNT[] ps = new PNT[4];
  
  for ( int j = 0; j < 4; j++)
  {
    println("j = "+j + " "+((j-1)%4+4)%4);
    ps[j] = LERP(s[j].apply(Point[j],time),0.5,s[((j-1)%4+4)%4].apply(Point[j],time));
  }
  A.setTo(ps[0]);
  B.setTo(ps[1]);
  C.setTo(ps[2]);
  D.setTo(ps[3]);
}

// Create SQUINT using multiple quads
//Vinayak Gargya
void  SQUINTquadsMulti(PNT A, PNT B, PNT C, PNT D, PNT[] Point, float time,int transition_n)
{
  SIMILARITY[] s = new SIMILARITY[4];
  transition_n = transition_n * 4;
  for (int i=0; i < 4; i++)
  {
    s[i] = S(Point[transition_n + i],Point[transition_n + (i+1)%4],Point[transition_n + 4 + i],Point[transition_n + 4 + ((i+1)%4)]);
  
  }
  PNT[] ps = new PNT[4];
  
  for ( int j = 0; j < 4; j++)
  {
    ps[j] = LERP(s[j].apply(Point[transition_n + j],time),0.5,s[((j-1)%4+4)%4].apply(Point[transition_n + j],time)); //<>//
  }
  A.setTo(ps[0]);
  B.setTo(ps[1]);
  C.setTo(ps[2]);
  D.setTo(ps[3]);
}

//Need to create a method which will take a point A and convert to B based
//on two similarities. 
//These two similarities will be from AB to DC and AD to BC
//Step 1 calculate these two similarities
//Step 2 Use them to convert a point into B,C,D by going from 0 to 1 in both
//similarities
 void SQUINTMap(PNT A, PNT B, PNT C, PNT D,int n,PImage pix){
   SIMILARITY s1 = S(A,B,D,C);
   SIMILARITY s2 = S(A,D,B,C);
   int resolution = 50;
   for(int i = 0 ; i < resolution; i++)
   {
     for(int j = 0 ; j < resolution; j++)
     {
       
       noFill();noStroke();
       beginShape();
       if (texturing)
          texture(pix); //<>//
   
       float ta0 = (float)i/resolution;
       float ta1 = (float)(i+1)/resolution;
       float tb0 = (float)j/resolution;
       float tb1 = (float)(j+1)/resolution;
       
       PNT P1 = commuteAndApply(A,s1,ta0,s2,tb0);
       PNT P2 = commuteAndApply(A,s1,ta0,s2,tb1);
       PNT P3 = commuteAndApply(A,s1,ta1,s2,tb1);
       PNT P4 = commuteAndApply(A,s1,ta1,s2,tb0);
       //println("Point calculated : "+P.x + " " +P.y);
       vertex(P1.x,P1.y,ta0,1-tb0);
       vertex(P2.x,P2.y,ta0,1-tb1);
       vertex(P3.x,P3.y,ta1,1-tb1);
       vertex(P4.x,P4.y,ta1,1-tb0);
       endShape();
     }
   }
   if(fill)
   {
     stroke(brown);strokeWeight(1);
       
   for(int i = 0; i <= n; i++){
     float h = (float)i/n;
     drawSquintEdge(A,s1,s2,h,resolution);
     drawSquintEdge(A,s2,s1,h,resolution);
   }
   }
 }
 
 void drawSquintEdge(PNT A,SIMILARITY s1, SIMILARITY s2,float t1,int n){
   beginShape();
     for (int j = 0; j <= n; j++){
       float t2 = (float)j/n;
       PNT P = commuteAndApply(A,s1,t1,s2,t2);
       //println("Point calculated : "+P.x + " " +P.y);
         vertex(P.x,P.y);
       
     }
   endShape();
 }
