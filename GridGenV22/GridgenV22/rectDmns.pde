// Establish list of all potential frame sizes. //<>// //<>//
// ArrayList must be ordered frame size ascending!
//--------------------------------------------------------------------------------//
//--------------------------------- Method Start ---------------------------------//
//--------------------------------------------------------------------------------//

ArrayList <PVector> rectDmns(float maxRectW, float maxWtoH, float minWtoH) {
  ArrayList <PVector> rectSizes = new ArrayList <PVector>();  // w, h
  final float maxW = width * maxRectW;
  final float pddngH = pddng * 2;
  final float pddngW = pddngH + nose;

  // Loop thrgh ea itrtn of hght.
  final float maxH = maxW / minWtoH;
  for (float i = uom + pddngH; i <= maxH; i = i + uom) {
    // Loop thrgh ea itrtn of wdth.
    float iW = i * maxWtoH;
    if (iW > maxW) {
      iW = maxW;
    }
    for (float ii = (((i - pddngH) * minWtoH) * 2) + pddngW; ii <= iW; 
      ii = ii + uom) {
      PVector wH = new PVector(ii, i);
      rectSizes.add(wH);
    }  // wdth enclsng brce
  }  // hght enclsng brce

  // Debug
  if (rectSizes.size() == 0) {
    println("Soz, no rectSizes appear to fit!\n" +
      "Maybe the nose gap is too large for the minWtoH,\n" +
      "try decreasing the nose gap or increasing the minWtoH ratio.");
  }
  return rectSizes;
}  // mthd enclsng brce
//--------------------------------------------------------------------------------//
//---------------------------------- Method End ----------------------------------//
//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//
//----------------------------- Functionality Start ------------------------------//
//--------------------------------------------------------------------------------//
//--------------------------------------------------------------------------------//
//------------------------------ Functionality End -------------------------------//
//--------------------------------------------------------------------------------//