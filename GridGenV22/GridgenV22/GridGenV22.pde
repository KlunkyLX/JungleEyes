// Sketch to generate a list of text files. //<>// //<>//
// Ea file is a list of random PShapes that fit within
// a JunleEyes sketch to be read into objects for the
// JungleEyes application.

// Tristan Skinner
// 05/11/2016

// Attributes
//--------------------------------------------------------------------------------//
// Visualizingizing Data by Ben Fry. Copyright 2008 Ben Fry, 978-0-596-51455-6.
//--------------------------------------------------------------------------------//

// Import libraries
//--------------------------------------------------------------------------------//
import processing.pdf.*;
import java.util.HashSet;
import java.awt.Rectangle;
import java.awt.Polygon;
import org.gicentre.handy.*;
//--------------------------------------------------------------------------------//

// Global variables
//--------------------------------------------------------------------------------//
final float uom  = 8.0;  // unit of measure
final float pddng = 1.0;  // pxls
final float nose = uom;  // pxls btween eyes

HashSet<PVector> totPxls;
ArrayList<Eyes> eyes = new ArrayList<Eyes>();
HandyRenderer hndy;
int bckgrnd = 64;  // colour
//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//
//--------------------------------- Setup Start ----------------------------------//
//--------------------------------------------------------------------------------//
void setup() {
  size(1200, 800);
  beginRecord(PDF, "sketch.pdf");
  frameRate(4);
  background(bckgrnd);  // *** Refactor!!! ***
  stroke(255, 0, 0);  // *** Refactor!!! ***
  strokeWeight(1);  // *** Refactor!!! ***

  // Local variables
  //--------------------------------------------------------------------------------//
  final float maxRectW = 0.5;  // frctn proportion of whole plane
  final float maxWtoH = 4.0;  // frctn proportion of width
  final float minWtoH = 1.5;  // frctn proportion of width
  //--------------------------------------------------------------------------------//

  // Establish list of all potential frame sizes.
  ArrayList <PVector> rectSizes = rectDmns(maxRectW, maxWtoH, minWtoH);
  //println("No of potential rect sizes: " + rectSizes.size());  // debug

  // Create eye objects.
  //--------------------------------------------------------------------------------//
  hndy = new HandyRenderer(this);
  totPxls = popPxls();  // *** Could be a lrge no of pxls! ***
  //println("Begin totPxls: " + totPxls.size());  // debug
  // Create eye objects.
  plotEyes(rectSizes);
  //println("Final totPxls: " + totPxls.size());  // debug
  //println("no eyes: " + eyes.size());  // debug
  //--------------------------------------------------------------------------------//

  endRecord();  // pdf file
  //exit();
}  // setup enclsng brce
//--------------------------------------------------------------------------------//
//---------------------------------- Setup End -----------------------------------//
//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//
//---------------------------------- Draw Start ----------------------------------//
//--------------------------------------------------------------------------------//
void draw() {
  //Debug, draw eyes.
  strokeJoin(ROUND);
  strokeCap(SQUARE);
  for (Eyes e : eyes) {
    e.displayNrml();
    //e.display();
    noLoop();
    e.blink();
  }
  
  endRecord();  // pdf file
}  // draw enclsng brce
//--------------------------------------------------------------------------------//
//----------------------------------- Draw End -----------------------------------//
//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//
//----------------------------- Functionality Start ------------------------------//
//--------------------------------------------------------------------------------//

// Create a Java rectangle with correctly casted parameters.
//--------------------------------------------------------------------------------//
Rectangle javRect(float _x, float _y, float _w, float _h) {
  int x = (int) _x; 
  int y = (int) _y; 
  int w = (int) _w; 
  int h = (int) _h;
  Rectangle r = new Rectangle(x, y, w, h);
  return r;
}  // mthd enclsng brce
//--------------------------------------------------------------------------------//

// Pop hshset with every pxl in the plane.
//--------------------------------------------------------------------------------//
HashSet<PVector> popPxls() {
  HashSet<PVector> totPxls = new HashSet<PVector>();
  for (int i = 0; i < width; i++) {
    for (int ii = 0; ii < height; ii++) {
      PVector coord = new PVector(i, ii);
      totPxls.add(coord);
    }
  }
  return totPxls;
} // mthd enclsng brce
//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//
void plotFrstEye(ArrayList <PVector> rectSizes) {
  // Pick a rndm first rect from the last quartile to create frst pair of eyes.
  int q4 = (round(random(rectSizes.size() * 0.75, rectSizes.size()))) - 1;
  PVector q4wh = rectSizes.get(q4);
  Rectangle r = javRect(random(width - q4wh.x), random(height - q4wh.y), 
    rectSizes.get(q4).x, rectSizes.get(q4).y);
  Eyes frstEyes = new Eyes(r);
  eyes.add(frstEyes);
} // mthd enclsng brce
//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//
//------------------------------ Functionality End -------------------------------//
//--------------------------------------------------------------------------------//