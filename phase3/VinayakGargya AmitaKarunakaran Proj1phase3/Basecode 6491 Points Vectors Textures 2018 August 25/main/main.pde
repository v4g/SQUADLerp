// base code 01 for graphics class 2018, Jarek Rossignac

// **** LIBRARIES
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!
import java.awt.Toolkit;
import java.awt.datatransfer.*;


// **** GLOBAL VARIABLES

// COLORS
color // set more colors using Menu >  Tools > Color Selector
   black=#000000, grey=#5F5F5F, white=#FFFFFF, 
   red=#FF0000, green=#00FF01, blue=#0300FF,  
   yellow=#FEFF00, cyan=#00FDFF, magenta=#FF00FB, 
   orange=#FCA41F, dgreen=#026F0A, brown=#AF6E0B;

// FILES and COUNTERS
String PicturesFileName = "SixteenPoints";
int frameCounter=0;
int transition_n = 0;
int pictureCounterPDF=0, pictureCounterJPG=0, pictureCounterTIF=0; // appended to file names to avoid overwriting captured images

// PICTURES
PImage FaceStudent1, FaceStudent2; // picture of student's face as /data/XXXXX.jpg in sketch folder !!!!!!!!

// TEXT
PFont bigFont; // Font used for labels and help text

// KEYBOARD-CONTROLLED BOOLEAM TOGGLES AND SELECTORS 
int method=0; // selects which method is used to set knot values (0=uniform, 1=chordal, 2=centripetal)
boolean animating=true; // must be set by application during animations to force frame capture
boolean texturing=false; // fill animated quad with texture
//Amita Karunakaran
//Allows for multiple textures to be used
int multiTexturing = 0;
int gridLines = 1;
boolean showArrows=false;
boolean showInstructions=true;
boolean showLabels=true;
boolean showLERP=false;
boolean showLPM=true;
boolean fill=true;
boolean filming=false;  // when true frames are captured in FRAMES for a movie

// flags used to control when a frame is captured and which picture format is used 
boolean recordingPDF=false; // most compact and great, but does not always work
boolean snapJPG=false;
boolean snapTIF=false;   

// ANIMATION
float totalAnimationTime=3; // at 1 sec for 30 frames, this makes the total animation last 90 frames
float time=0;

//POINTS 
int pointsCountMax = 32;         //  max number of points
int nAuxLines = 90;         //  max number of points
int pointsCount=4;               // number of points used
PNT[] Point = new PNT[pointsCountMax];   // array of points
PNT A, B, C, D; // Convenient global references to the first 4 control points 
PNT P; // reference to the point last picked by mouse-click
EDGE[] AuxEdgeLPM = new EDGE[nAuxLines];   // array of points
EDGE[] AuxEdgeLERP = new EDGE[nAuxLines];   // array of points
int curCount = 0;


// **** SETUP *******
void setup()               // executed once at the begining LatticeImage
  {
  size(800, 800, P2D);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  bigFont = createFont("AdobeFanHeitiStd-Bold-32", 16); textFont(bigFont); // font used to write on screen
  FaceStudent1 = loadImage("data/student1.jpg");  // file containing photo of student's face
  FaceStudent2 = loadImage("data/student2.jpg");  // file containing photo of student's face
  declarePoints(Point); // creates objects for 
  readPoints("data/points.pts");
  A=Point[0]; B=Point[1]; C=Point[2]; D=Point[3]; // sets the A B C D pointers
  textureMode(NORMAL); // addressed using [0,1]^2
  for (int i = 0; i < nAuxLines; i++)
  {
    AuxEdgeLPM[i] = E(P(0,0),P(0,0));
    AuxEdgeLERP[i] = E(P(0,0),P(0,0));
  }
} // end of setup


// **** DRAW
void draw()      // executed at each frame (30 times per second)
  {
  if(recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF
  
  if(showInstructions) showHelpScreen(); // display help screen with student's name and picture and project title

  else // display frame
    {
    background(white); // erase screen
    A=Point[0]; B=Point[1]; C=Point[2]; D=Point[3]; // sets the A B C D pointers
        
    // Update animation time
    if(animating) 
      {
      if(time<1) time+=1./(totalAnimationTime*frameRate); // advance time
      else{
        curCount = 0;
        time=0; // reset time to the beginning
        transition_n = (transition_n + 1 )%3;
      }
    }
    
   // WHEN USING 4 CONTROL POINTS:  Use this for morphing edges (in 6491)
   if(pointsCount==4)
      {
      EDGE E0 = new EDGE(A,B);
      EDGE E1 = new EDGE(D,C);
      
      if(showArrows)         // Draw edges as arrows
        {
        stroke(grey); strokeWeight(5); 
        drawEdgeAsArrow(E0); drawEdgeAsArrow(E1); 
        }
      
      if(showLERP)         // Draw lerp of endpoints (as a reference of a bad morph)
        {
        EDGE Et = LERP(E0,time,E1);
        stroke(blue); strokeWeight(3); fill(blue);
        drawEdgeAsArrow(Et);
        writeLabel(Et.PNTnearB()," LERP");
        noFill();
        } 

      if(showLPM)         // Draw LMP: This is a place holder with the wrong solution. 
        {
        SQUINTMap(A,B,C,D,gridLines,FaceStudent1,FaceStudent2);
        //EDGE Et = LPM(E0,time,E1); // You must change this code (see TAB edges)
        //stroke(red); strokeWeight(3); fill(red);
        //drawEdgeAsArrow(Et);
        //writeLabel(Et.PNTnearB()," LPM");
        noFill();
        }
          
      // Draw and label control points
      if(showLabels) // draw names of control points
        {
        textAlign(CENTER, CENTER); // to position the label around the point
        stroke(black); strokeWeight(1); // attribute of circle around the label
        showLabelInCircle(A,"A"); showLabelInCircle(B,"B"); showLabelInCircle(C,"C"); showLabelInCircle(D,"D"); 
         }
      else // draw small dots at control points
        {
        fill(brown); stroke(brown); 
        drawCircle(A,4); drawCircle(B,4); drawCircle(C,4); drawCircle(D,4);
        }
      noFill(); 
      
      } // end of when 4 points
      
    if(pointsCount==8)
    {
      EDGE E0 = new EDGE(Point[0],Point[1]);
      EDGE E1 = new EDGE(Point[2],Point[3]);
      EDGE E2 = new EDGE(Point[4],Point[5]);
      EDGE E3 = new EDGE(Point[6],Point[7]);
      
      stroke(grey); strokeWeight(4); 
      drawEdge(E0); drawEdge(E1); drawEdge(E2); drawEdge(E3);
      
      if(showLabels) // draw names of control points
       {
        textAlign(CENTER, CENTER); // to position the label around the point
        stroke(black); strokeWeight(1); // attribute of circle around the label
        showLabelInCircle(Point[0],"A");
        showLabelInCircle(Point[1],"B");
        showLabelInCircle(Point[2],"C");
        showLabelInCircle(Point[3],"D");
        showLabelInCircle(Point[4],"E");
        showLabelInCircle(Point[5],"F");
        showLabelInCircle(Point[6],"G");
        showLabelInCircle(Point[7],"H");   
      }
      
      
      stroke(red); strokeWeight(2);
      
      /*
      for(int i = 0; i < 1; i+=0.1)
      {
        EDGE Ei = NevilleLPM(0,E0,0.33,E1,0.66,E2,1,E3,i);
        drawEdge(Ei);
      }
      */
      //EDGE Et = NevilleLPM(0f,E0,1f,E1,2f,E2,3f,E3,time);
      EDGE ENeville = NevilleCubicEdge(0f,E0,0.33f,E1,0.66f,E2,1f,E3,time);
      EDGE ELPM = NevilleCubicEdgeLPM(0f,E0,0.33f,E1,0.66f,E2,1f,E3,time);
      if(time > (float)curCount/nAuxLines)
      {
         //record this edge
         AuxEdgeLERP[curCount] = ENeville;
         AuxEdgeLPM[curCount] = ELPM;
         curCount++;
         if(curCount == nAuxLines)
           curCount = 0;
      }
      //EDGE Et = NevilleQuadraticEdge(0f,E0,0.50,E1,1.0f,E2,time);
      //EDGE Et = NevilleQuadraticEdgeLPM(0f,E0,0.50,E1,1.0f,E2,time);
      if(showLERP)
        drawEdge(ENeville);
      stroke(blue); strokeWeight(2);
      if(fill)
        drawEdge(ELPM);
      for ( int i = 0; i < nAuxLines; i++)
      {
        if(showLERP)
        { 
          stroke(red); strokeWeight(1);
          drawEdge(AuxEdgeLERP[i]);
        }
        if(fill)
        {
          stroke(blue); strokeWeight(1);
          drawEdge(AuxEdgeLPM[i]);
        }
      }
      
      
    }

    
    // WHEN USING 16 CONTROL POINTS (press '4' to make them or 'R' to load them from file) 
    if(pointsCount==16)
      {
      noFill(); strokeWeight(6); 
      for(int i=0; i<4; i++) {stroke(50*i,200-50*i,0); drawQuad(Point[i*4],Point[i*4+1],Point[i*4+2],Point[i*4+3]);}
      strokeWeight(2); stroke(grey,100); for(int i=0; i<4; i++) drawOpenQuad(Point[i],Point[i+4],Point[i+8],Point[i+12]);
 
 
      // Draw control points
      if(showLabels) // draw names of control points
        {
        textAlign(CENTER, CENTER); // to position the label around the point
        stroke(black); strokeWeight(1); // attribute of circle around the label
        for(int i=0; i<pointsCount; i++) showLabelInCircle(Point[i],Character.toString((char)(int)(i+65)));
        }
      else // draw small dots at control points
        {
        fill(blue); stroke(blue); strokeWeight(2);  
        for(int i=0; i<pointsCount; i++) drawCircle(Point[i],4);
        }
        
      // Animate quad
      strokeWeight(20); stroke(red,100); // semitransparent
       // *** replace {At,Bt..} by QUAD OBJECT in the code below
       PNT At=P(), Bt=P(), Ct=P(), Dt=P();
       if(showLERP) 
         {
         //LERPquads(At,Bt,Ct,Dt,Point,time); // *** change this to compute the current quad from 2 quads 
         /*LERPquads(At,Bt,Ct,Dt,Point,time); // *** change this to compute the current quad from 2 quads 
         noFill(); noStroke(); 
         if(texturing) 
           drawQuadTextured(At,Bt,Ct,Dt,FaceStudent1); // see ``points'' TAB for implementation
         else
           {
           noFill(); 
           if(fill) fill(yellow);
           strokeWeight(20); stroke(red,100); // semitransparent
           drawQuad(At,Bt,Ct,Dt);
           }*/
         }
       if(showLPM) 
         {
         // Amita Karunakaran
         //SQUINTquadsMulti(At,Bt,Ct,Dt,Point,time,transition_n); // SQUINT using multiple quads
         SQUINTquadsNevilles(At,Bt,Ct,Dt,Point,time,transition_n); // SQUINT using multiple quads
         //SQUINTquads(At,Bt,Ct,Dt,Point,time);  //SQUINT using two quads
         
         noFill(); noStroke(); 
         SQUINTMap(At,Bt,Ct,Dt,gridLines,FaceStudent1,FaceStudent2);
        /*if(texturing) 
           drawQuadTextured(At,Bt,Ct,Dt,FaceStudent1); // see ``points'' TAB for implementation
         else
           {
           noFill(); 
           if(fill) fill(cyan);
           strokeWeight(20); stroke(red,100); // semitransparent
           drawQuad(At,Bt,Ct,Dt);
           }
         */
         }

      } // end of when 16 points
     
        
      
    } // end of display frame
    
    
    
  // snap pictures or movie frames
  if(recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas
  if(snapTIF) snapPictureToTIF();   
  if(snapJPG) snapPictureToJPG();   
  if(filming) snapFrameToTIF(); // saves image on canvas as movie frame 
  
  } // end of draw()
