// Method to create and place PShape triangle Eye objects.
//--------------------------------------------------------------------------------//
//--------------------------------- Method Start ---------------------------------//
//--------------------------------------------------------------------------------//
// Loop thrgh some randomly picked coords, create new triangle objects
// for any rects that fit the plane and don't overlap existing eyes.
void plotEyes(ArrayList <PVector> rectSizes) {
  // Start with trying arbtry larger sizes first.
  PVector v1 = new PVector(200, rectSizes.size() - 1);
  PVector v2 = new PVector(50, v1.y);
  PVector v3 = new PVector(20, v2.x * 2);
  PVector[] diffRnges = {v1, v2, v3};
  int rndm = round(random(0, diffRnges.length - 1));
  int noLoops = round(random(50, 250));  // no of times to perform while loop.
  rectTestScope(rectSizes, diffRnges[rndm].x, diffRnges[rndm].x, noLoops);

  rectTestScope(rectSizes, 0, rectSizes.size() - 1, 1000);
}  // mthd enclsng brce
//--------------------------------------------------------------------------------//
//---------------------------------- Method End ----------------------------------//
//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//
//----------------------------- Functionality Start ------------------------------//
//--------------------------------------------------------------------------------//

// Define no of times to attempt picking rndm coord and size to fit plane and
// perform the while loop.
//--------------------------------------------------------------------------------//
void rectTestScope(ArrayList <PVector> rectSizes, 
  float minRectSize, float maxRectSize, int noLoops) {
  int i = 0;
  while (i < noLoops) {
    int sizeScope = round(random(minRectSize, maxRectSize));
    testSomeRects(rectSizes, sizeScope);
    i++;
  }  // while pxl enclsng brce
}  // mthd enclsng brce
//--------------------------------------------------------------------------------//

// Test to see if found frame overlaps any existing eyes.
//--------------------------------------------------------------------------------//
void testSomeRects(ArrayList <PVector> rectSizes, int sizeScope) {
  // Pick a random rect size.
  PVector rndmWH = rectSizes.get(sizeScope);
  // Pick a random coord from plane that will fit the rect size.
  float rndmX = round(random(0, width - rndmWH.x));
  float rndmY = round(random(0, height - rndmWH.y));
  PVector coord = new PVector(rndmX, rndmY);
  if (totPxls.contains(coord)) {
    // Fitable rect found, test if rect overlaps any existing eyes.
    Rectangle r = javRect(coord.x, coord.y, rndmWH.x, rndmWH.y);
    boolean overlap = overLapChecker(r);
    // If no overlaps, add new eye object.
    if (overlap == false) {  // no overlaps
      removeCoord(coord);
      Eyes e = new Eyes(r);
      eyes.add(e);
      //rect(coord.x, coord.y, rndmWH.x, rndmWH.y);  // debug - delete
    }
  }
}  // mthd enclsng brce
//--------------------------------------------------------------------------------//

// Test to see if found frame overlaps any existing eyes.
//--------------------------------------------------------------------------------//
boolean overLapChecker(Rectangle r) {
  boolean overlaps = false;
  int x = (int) r.getX();
  int y = (int) r.getY();
  int w = (int) r.getWidth();
  int h = (int) r.getHeight();
  // Loop thrgh ea exstng eye pair to test if currnt rect intrscts.
  for (Eyes e : eyes) {
    // Test if rect size intrscts with any exstng eyes.
    if (e.intrscts(x, y, w, h) == true) {
      overlaps = true;
      break;
    }
  }  // eyes enclsng brce

  return overlaps;
}  // mthd enclsng brce
//--------------------------------------------------------------------------------//

// Delete coords that were tested to fit a rect.
//--------------------------------------------------------------------------------//
HashSet<PVector> removeCoord(PVector coord) {
  HashSet<PVector> allPxls = totPxls;
  allPxls.remove(coord);
  return allPxls;
} // mthd enclsng brce
//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//
//------------------------------ Functionality End -------------------------------//
//--------------------------------------------------------------------------------//