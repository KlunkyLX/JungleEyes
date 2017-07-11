// Method to calculate PShape eye vals.

//--------------------------------------------------------------------------------//
//--------------------------------- Method Start ---------------------------------//
//--------------------------------------------------------------------------------//

PShape[] eyeShaper(Rectangle frame) {
  PShape eyeL = new PShape();
  PShape eyeR = new PShape();

  int frmeX = (int) (frame.getX() + pddng);
  int frmeY = (int) (frame.getY() + pddng);
  int wdth = round((float)((frame.getWidth() / 2) - pddng - (nose / 2)));
  int hght = (int) (frame.getHeight() - (pddng * 2));
  float frmeMddle = (((frmeX + wdth + nose + wdth) - frmeX) / 2) + frmeX;

  // Create left eye shape.
  Rectangle l = new Rectangle(frmeX, frmeY, wdth, hght);
  eyeL = eyeShaperL(l);

  // Calculate eyeR coords.
  eyeR = createShape();
  eyeR.beginShape();
  for (int i = 0; i < eyeL.getVertexCount(); i++) {
    PVector left = eyeL.getVertex(i);
    eyeR.vertex(frmeMddle + (frmeMddle - left.x), left.y);
  }
  eyeR.endShape(CLOSE);

  PShape[] eyeShapes = {eyeL, eyeR};
  return eyeShapes;
}  // mthd enclsng brce
//--------------------------------------------------------------------------------//
//---------------------------------- Method End ----------------------------------//
//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//
//----------------------------- Functionality Start ------------------------------//
//--------------------------------------------------------------------------------//

// Calculate left eye vals.
//--------------------------------------------------------------------------------//
PShape eyeShaperL(Rectangle r) {
  PShape eye = new PShape();
  float w = (float) r.getWidth(); 
  float h = (float) r.getHeight();
  ArrayList <PVector> upSideDwnTrngle1 = new ArrayList <PVector>();
  ArrayList <PVector> upSideDwnTrngle2 = new ArrayList <PVector>();
  ArrayList <PVector> nrrwTrngle1 = new ArrayList <PVector>();
  ArrayList <PVector> nrrwTrngle2 = new ArrayList <PVector>();
  ArrayList <PVector> vrtces = new ArrayList <PVector>();

  // Generate a triangle.
  //--------------------------------------------------------------------------------//
  pushMatrix();  // save crrnt coord ststm to the stack
  float rX = (float) r.getX();
  float rY = (float) r.getY();
  translate(rX, rY);

  upSideDwnTrngle1.add(new PVector(0, random(0, (h / 4) - 1)));  // vctr A
  upSideDwnTrngle1.add(new PVector(w, random(0, (h * 0.75) - 1)));  // vctr B
  upSideDwnTrngle1.add(new PVector(random(0, w), h));  // vctr C
  upSideDwnTrngle2.add(new PVector(0, random(h * 0.75, h)));  // vctr A
  upSideDwnTrngle2.add(new PVector(w, random(h / 4, h)));  // vctr B
  upSideDwnTrngle2.add(new PVector(random(0, w), 0));  // vctr C

  nrrwTrngle1.add(new PVector(0, random(h * 0.75, h)));  // vctr A
  nrrwTrngle1.add(new PVector(random(w / 2, w), (h / 4) - 1));  // vctr B
  nrrwTrngle1.add(new PVector(w, h));  // vctr C
  nrrwTrngle2.add(new PVector(0, random(0, (h / 4) - 1)));  // vctr A
  nrrwTrngle2.add(new PVector(random(w / 2, w), (h * 0.75) - 1));  // vctr B
  nrrwTrngle2.add(new PVector(w, 0));  // vctr C

  // Pick a triangle shape.
  int optn = round(random(0, 10));
  if (optn == 0) {
    vrtces = upSideDwnTrngle1;
  } else if (optn == 2) {
    vrtces = upSideDwnTrngle1;  // wght more for this shape
  } else if (optn == 3) {
    vrtces = upSideDwnTrngle1;  // wght more for this shape
  } else if (optn == 4) {
    vrtces = upSideDwnTrngle1;  // wght more for this shape
  } else if (optn == 5) {
    vrtces = upSideDwnTrngle2;
  } else if (optn == 6) {
    vrtces = upSideDwnTrngle2;  // wght more for this shape
  } else if (optn == 7) {
    vrtces = upSideDwnTrngle2;  // wght more for this shape
  } else if (optn == 8) {
    vrtces = nrrwTrngle1;
  } else {
    vrtces = nrrwTrngle2;
  }
  popMatrix();  // restore prior coord systm
  //--------------------------------------------------------------------------------//

  // Create PShape
  //--------------------------------------------------------------------------------//
  eye = createShape();
  eye.beginShape();
  stroke(255);  // triangle outline colour
  eye.vertex(round(vrtces.get(0).x + rX), round(vrtces.get(0).y + rY));
  eye.vertex(round(vrtces.get(1).x + rX), round(vrtces.get(1).y + rY)); 
  eye.vertex(round(vrtces.get(2).x + rX), round(vrtces.get(2).y + rY));
  eye.endShape(CLOSE);
  //--------------------------------------------------------------------------------//

  return eye;
}  // eyeShaperL mthd enclsng crly brace
//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//
//------------------------------ Functionality End -------------------------------//
//--------------------------------------------------------------------------------//