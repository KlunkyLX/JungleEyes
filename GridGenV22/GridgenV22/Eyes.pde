// Class to create an object of a pair of eyes with associated vrbles
// and functions.

// Class name.
class Eyes {

  //--------------------------------------------------------------------------------//
  //--------------------------- Instance Variables Start ---------------------------//
  //--------------------------------------------------------------------------------//
  PShape eyes, eyeL, eyeR;
  Polygon polygonL, polygonR;
  int bndngBox;  // no of pxls within frame
  int pxlArea;  // no of pxls within eyes PShape
  float[] xL, yL, xR, yR; 
  PVector xyL, xyR;
  float whL, whR, strtL, strtR, stopL, stopR;
  //--------------------------------------------------------------------------------//
  //---------------------------- Instance Variables End ----------------------------//
  //--------------------------------------------------------------------------------//

  //--------------------------------------------------------------------------------//
  //------------------------------ Constructor Start -------------------------------//
  //--------------------------------------------------------------------------------//

  Eyes(Rectangle frame) {

    // Create left and right eye PShapes.
    PShape[] eyeShapes = eyeShaper(frame);  // sep tab
    this.eyeL = eyeShapes[0];
    this.eyeR = eyeShapes[1];
    // Create parent PShape.
    this.eyes = createShape(GROUP);
    eyes.addChild(eyeL);
    eyes.addChild(eyeR); 

    // Init Java polygons for both eyes.
    this.polygonL = initPlygn(eyeL);
    this.polygonR = initPlygn(eyeR);

    // Init arrys for handy trngles.
    int nVrtices = eyeL.getVertexCount();
    this.xL = new float[nVrtices];
    this.yL = new float[nVrtices];
    this.xR = new float[nVrtices];
    this.yR = new float[nVrtices];
    for (int i = 0; i < nVrtices; i++) {
      PVector l = eyeL.getVertex(i);
      PVector r = eyeR.getVertex(i);
      xL[i] = l.x;
      yL[i] = l.y;
      xR[i] = r.x;
      yR[i] = r.y;
    }

    // Init handy eyes.
    // First define correct trigmtry parameters.
    if (yL[1] > yL[2]) {  // scnd crnr is lower than third crnr
      if (yL[0] >= yL[1]) {
        float adjA = yL[0] - yL[1];
        float oppA = xL[1] - xL[0];
        float adjB = yL[1] - yL[2];
        float oppB = xL[1] - xL[2];
        trigValsL(xL[1], yL[1], adjA, oppA, adjB, oppB, HALF_PI, PI + HALF_PI);
        adjA = yR[1] - yR[2];
        oppA = xR[2] - xR[1];
        adjB = yR[0] - yR[1];
        oppB = xR[0] - xR[1];
        trigValsR(xR[1], yR[1], adjA, oppA, adjB, oppB, 0 - HALF_PI, HALF_PI);
      } else if (xL[2] < xL[1]) {
        float adjA = xL[1] - xL[0];
        float oppA = yL[1] - yL[0];
        float adjB = yL[1] - yL[2];
        float oppB = xL[1] - xL[2];
        trigValsL(xL[1], yL[1], adjA, oppA, adjB, oppB, PI, PI + HALF_PI);
        adjA = yR[1] - yR[2];
        oppA = xR[2] - xR[1];
        adjB = xR[0] - xR[1];
        oppB = yR[1] - yR[0];
        trigValsR(xR[1], yR[1], adjA, oppA, adjB, oppB, 0 - HALF_PI, 0);
      } else {
        // Add a random alternating effect for this particular trngle shape.
        //--------------------------------------------------------------------------------//
        // Standard vals - both eyes bottom
        float adjAl = xL[1] - xL[0];
        float oppAl = yL[1] - yL[0];
        float adjBl = xL[2] - xL[1];
        float oppBl = yL[1] - yL[2];
        float adjAr = xR[1] - xR[2];
        float oppAr = yR[1] - yR[2];
        float adjBr = xR[0] - xR[1];
        float oppBr = yR[1] - yR[0];

        float pckr = round(random(1, 3));
        if (pckr == 1) {
          // Left eye - top
          adjAl = yL[1] - yL[2];
          oppAl = xL[2] - xL[1];
          adjBl = xL[2] - xL[0];
          oppBl = yL[0] - yL[2];
          trigValsL(xL[2], yL[2], adjAl, oppAl, adjBl, oppBl, HALF_PI, PI);
          trigValsR(xR[1], yR[1], adjAr, oppAr, adjBr, oppBr, PI, TWO_PI);
        } else if (pckr == 2) {
          // Right eye - top
          trigValsL(xL[1], yL[1], adjAl, oppAl, adjBl, oppBl, PI, TWO_PI);
          adjAr = xR[0] - xR[2];
          oppAr = yR[0] - yR[2];
          adjBr = yR[1] - yR[2];
          oppBr = xR[1] - xR[2];
          trigValsR(xR[2], yR[2], adjAr, oppAr, adjBr, oppBr, 0, HALF_PI);
        } else {
          // Standard vals
          trigValsL(xL[1], yL[1], adjAl, oppAl, adjBl, oppBl, PI, TWO_PI);
          trigValsR(xR[1], yR[1], adjAr, oppAr, adjBr, oppBr, PI, TWO_PI);
        }
        //--------------------------------------------------------------------------------//
      }
    } else if (yL[0] > yL[1]) {
      if (xL[2] < (xL[1] - ((xL[1] - xL[0]) / 2))) {
        float adjA = yL[2] - yL[1];
        float oppA = xL[1] - xL[2];
        float adjB = xL[1] - xL[0];
        float oppB = yL[0] - yL[1];
        trigValsL(xL[1], yL[1], adjA, oppA, adjB, oppB, HALF_PI, PI);
        adjA = xR[0] - xR[1];
        oppA = yR[0] - yR[1];
        adjB = yR[2] - yR[1];
        oppB = xR[2] - xR[1];
        trigValsR(xR[1], yR[1], adjA, oppA, adjB, oppB, 0, HALF_PI);
      } else {
        float adjA = xL[2] - xL[0];
        float oppA = yL[2] - yL[0];
        float adjB = yL[2] - yL[1];
        float oppB = xL[2] - xL[1];
        trigValsL(xL[2], yL[2], adjA, oppA, adjB, oppB, PI, PI + HALF_PI);
        adjA = yR[2] - yR[1];
        oppA = xR[1] - xR[2];
        adjB = xR[0] - xR[2];
        oppB = yR[2] - yR[0];
        trigValsR(xR[2], yR[2], adjA, oppA, adjB, oppB, 0 - HALF_PI, 0);
        text("third corner!", xR[2], yR[2] + 5);  // debug - delete
      }
    } else {
      float adjA = yL[2] - yL[1];
      float oppA = xL[1] - xL[2];
      float adjB = yL[1] - yL[0];
      float oppB = xL[1] - xL[0];
      trigValsL(xL[1], yL[1], adjA, oppA, adjB, oppB, HALF_PI, PI + HALF_PI);
      adjA = yR[1] - yR[0];
      oppA = xR[0] - xR[1];
      adjB = yR[2] - yR[1];
      oppB = xR[2] - xR[1];
      trigValsR(xR[1], yR[1], adjA, oppA, adjB, oppB, 0 - HALF_PI, HALF_PI);
    }

    // Delete frame pxls from global pxl list that are inside eye polygons.
    totPxls = deletePxls(frame);
  }  // cnstrctr enclsng crly brace
  //--------------------------------------------------------------------------------//
  //------------------------------- Constructor End --------------------------------//
  //--------------------------------------------------------------------------------//

  //--------------------------------------------------------------------------------//
  //----------------------------- Functionality Start ------------------------------//
  //--------------------------------------------------------------------------------//

  // Draw PShape
  //--------------------------------------------------------------------------------//
  // *** Refactor!!! ***
  void drawEyes() {
    shape(eyes);
  }  // mthd enclsng crly brace
  void drawEyeL() {
    shape(eyeL);
  }  // mthd enclsng crly brace
  void drawEyeR() {
    shape(eyeR);
  }  // mthd enclsng crly brace
  //--------------------------------------------------------------------------------//

  // Make eyes blink.
  //--------------------------------------------------------------------------------//  
  void blink() {
    if (keyPressed) {
    if (key == ' ') {
    stroke(bckgrnd);
    strokeWeight(10);
    //line(xL[1], yL[1],xL[0], yL[0]);
    float lngthX = abs(xR[0] - xR[2]);
    float lngthY = abs(yR[2] - yR[0]);
    int lngthC = round(sqrt(sq(lngthX) + sq(lngthY)));
    float xUnit = lngthX / lngthY;
    float x = xR[0];
    for (int y = int(yR[0]); y < lngthC; y++) {
    line(xR[1], yR[1], x, y);
    x = x + xUnit;
    }
    stroke(255);
  }
    }
  }  // mthd enclsng crly brace
    //--------------------------------------------------------------------------------//
  
  // Draw eyes with Handy renderer.
  //--------------------------------------------------------------------------------//
  void display() {
    strokeWeight(1);
    stroke(bckgrnd);
    fill(255);  // white
    hndy.shape(xL, yL, true);
    fill(0);  // black
    hndy.arc(xyL.x, xyL.y, whL, whL, strtL, stopL);
    noFill();
    stroke(bckgrnd);
    fill(255);  // white
    hndy.shape(xR, yR, true);
    fill(0);  // black
    hndy.arc(xyR.x, xyR.y, whR, whR, strtR, stopR);
    noFill();
  }  // mthd enclsng crly brace
  //--------------------------------------------------------------------------------//

  // Draw eyes conventionally.
  //--------------------------------------------------------------------------------//
  void displayNrml() {
    stroke(255);  // white
    fill(0);  // black
    shape(eyes);
    arc(xyL.x, xyL.y, whL, whL, strtL, stopL, PIE);
    arc(xyR.x, xyR.y, whR, whR, strtR, stopR, PIE);
  }  // mthd enclsng crly brace
  //--------------------------------------------------------------------------------//

  // Mthd to calculate adjcnt and opposite vals for trig params - left eye.
  //--------------------------------------------------------------------------------//
  void trigValsL(float x, float y, float adjA, float oppA, float adjB, float oppB, 
    float strt, float stop) {      
    this.xyL = new PVector(x, y);
    float lngthA = sqrt(sq(oppA) + sq(adjA));
    float lngthB = sqrt(sq(oppB) + sq(adjB));
    if (lngthA < lngthB) {
      this.whL = lngthA;
    } else {
      this.whL = lngthB;
    }
    float thetaA = atan(oppA / adjA);
    this.strtL = strt + thetaA;
    float thetaB = atan(oppB / adjB);
    this.stopL = stop - thetaB;
  }  // mthd enclsng crly brace
  //--------------------------------------------------------------------------------//

  // Mthd to calculate adjcnt and opposite vals for trig params - right eye.
  //--------------------------------------------------------------------------------//
  void trigValsR(float x, float y, float adjA, float oppA, float adjB, float oppB, 
    float strt, float stop) {      
    this.xyR = new PVector(x, y);
    float lngthA = sqrt(sq(oppA) + sq(adjA));
    float lngthB = sqrt(sq(oppB) + sq(adjB));
    if (lngthA < lngthB) {
      this.whR = lngthA;
    } else {
      this.whR = lngthB;
    }
    float thetaA = atan(oppA / adjA);
    this.strtR = strt + thetaA;
    float thetaB = atan(oppB / adjB);
    this.stopR = stop - thetaB;
  }  // mthd enclsng crly brace
  //--------------------------------------------------------------------------------//

  // Mthd to check whether parent PShape intersects with incoming rect.
  //--------------------------------------------------------------------------------//
  boolean intrscts(float _x, float _y, float _w, float _h) {
    int x = (int) _x; 
    int y = (int) _y; 
    int w = (int) _w; 
    int h = (int) _h; 
    boolean overlaps = true;
    boolean lft = polygonL.intersects(x, y, w, h);
    boolean rght = polygonR.intersects(x, y, w, h);
    if (lft != true && rght != true) {
      overlaps = false;
    }
    return overlaps;
  }  // mthd enclsng crly brace
  //--------------------------------------------------------------------------------//

  // Init Java polygons for both eyes.
  //--------------------------------------------------------------------------------//
  Polygon initPlygn(PShape shape) {
    Polygon polygon;      
    int nVrtices = shape.getVertexCount();
    int[] xVctrs = new int[nVrtices];
    int[] yVctrs = new int[nVrtices];
    for (int i = 0; i < nVrtices; i++) {
      PVector v = shape.getVertex(i);
      xVctrs[i] = (int) v.x;
      yVctrs[i] = (int) v.y;
    }    
    polygon = new Polygon(xVctrs, yVctrs, nVrtices);
    return polygon;
  }  // mthd enclsng crly brace
  //--------------------------------------------------------------------------------//

  // Delete frame pxls from global pxl list that are inside eye polygons.
  //--------------------------------------------------------------------------------//
  HashSet<PVector> deletePxls(Rectangle frame) {
    HashSet<PVector> allPxls = totPxls;

    int x1 = (int) frame.getX();
    int x2 = x1 + (int) frame.getWidth();
    int y1 = (int) frame.getY();
    int y2 = y1 + (int) frame.getHeight();
    // Loop all wdth pxls.
    for (int i = x1; i < x2 + 1; i++) {  // frme wdth
      for (int ii = y1; ii < y2 + 1; ii++) {  // frme hght
        boolean lft = polygonL.contains(i, ii);
        boolean rght = polygonR.contains(i, ii);
        if (lft == true || rght == true) {
          PVector v = new PVector(i, ii);
          allPxls.remove(v);  // remove coord from pxl list.
        }
      }  // hght enclsng crly brace
    }  // wdth enclsng crly brace

    return allPxls;
  }  // mthd enclsng crly brace
  //--------------------------------------------------------------------------------//

  //--------------------------------------------------------------------------------//
  //------------------------------ Functionality End -------------------------------//
  //--------------------------------------------------------------------------------//

  //--------------------------------------------------------------------------------//
  //-------------------------------- Getters Start ---------------------------------//
  //--------------------------------------------------------------------------------//
  //--------------------------------------------------------------------------------//
  //--------------------------------- Getters End ----------------------------------//
  //--------------------------------------------------------------------------------//

  //--------------------------------------------------------------------------------//
  //-------------------------------- Setters Start ---------------------------------//
  //--------------------------------------------------------------------------------//
  //--------------------------------------------------------------------------------//
  //--------------------------------- Setters End ----------------------------------//
  //--------------------------------------------------------------------------------//

  // Class enclsng crly brace
}