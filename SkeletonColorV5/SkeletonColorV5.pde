// Sketch to map distance between shoulder points and mid point to determine
// portrait or profile states. In turn to subsequently trigger appropriate
// events.

// Tristan Skinner
// 23/06/2017

// Attributes
//--------------------------------------------------------------------------------//
// Thomas Sanchez Lengeling.
// http://codigogenerativo.com/ 
// https: //github.com/ThomasLengeling/KinectPV2
//--------------------------------------------------------------------------------//

// Import libraries
//--------------------------------------------------------------------------------//
import KinectPV2.KJoint;
import KinectPV2.*;
//--------------------------------------------------------------------------------//

// Global variables
//--------------------------------------------------------------------------------//
KinectPV2 kinect;
PVector xy1, xy2, xyL, xyR;
PVector xy4L, xy4R;
float minPxls = 50;  // no of pxls before event is triggered
//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//
//--------------------------------- Setup Start ----------------------------------//
//--------------------------------------------------------------------------------//
void setup() {
  size(1024, 768);  // Acer monitor: 1280 x 1024
  frameRate(10);  // debug - delete  

  kinect = new KinectPV2(this);
  kinect.enableColorImg(true);
  kinect.enableSkeletonColorMap(true); 
  kinect.init();

  this.xy1 = new PVector();  // SpineShldr
  this.xy2 = new PVector();  // Spine Mid
  this.xyL = new PVector();  // LftShldr
  this.xyR = new PVector();  // RghtShldr
}  // setup enclsng brce
//--------------------------------------------------------------------------------//
//---------------------------------- Setup End -----------------------------------//
//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//
//---------------------------------- Draw Start ----------------------------------//
//--------------------------------------------------------------------------------//
void draw() {
  background(0);

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();
  color col  = 255;  // white
  fill(col);
  stroke(col);

  // Plot image points
  //--------------------------------------------------------------------------------//
  pushMatrix();
  scale(0.25f);
  image(kinect.getColorImage(), 0, 0);
  // Individual joints
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      strokeWeight(10);
      drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
      drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
      drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_SpineShoulder);
      drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_SpineShoulder);
      drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineShoulder);
      drawJoint(joints, KinectPV2.JointType_SpineShoulder);
    }
  }  // loop enclsng brce
  popMatrix();
  //--------------------------------------------------------------------------------//

  // Plot skeleton points
  //--------------------------------------------------------------------------------//
  // Individual joints
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      strokeWeight(2);
      drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
      drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
      drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineShoulder);
      xy1 = drawJointPV(joints, KinectPV2.JointType_SpineShoulder, "SpineShldr", col);
      xy2 = drawJointPV(joints, KinectPV2.JointType_SpineMid, "SpineMid", col);
      col = color(255, 0, 0);  // port
      xyL = drawJointPV(joints, KinectPV2.JointType_ShoulderLeft, "LftShldr", color(255, 0, 0));
      col = color(0, 255, 0);  // starboard
      xyR = drawJointPV(joints, KinectPV2.JointType_ShoulderRight, "RghtShldr", color(0, 255, 0));
    }
  }  // loop enclsng brce
  //--------------------------------------------------------------------------------//

  // Calculate xy4
  //--------------------------------------------------------------------------------//
  float lftLngth = (xy2.x - xy1.x) * (xyL.y - xy1.y) / (xy2.y - xy1.y);
  float rghtLngth = (xy1.x - xy2.x) * (xyR.y - xy1.y) / (xy2.y - xy1.y);
  this.xy4L = new PVector(xy1.x + lftLngth, xyL.y);  // horizontal core line coords
  this.xy4R = new PVector(xy1.x - rghtLngth, xyR.y);  // horizontal core line coords
  stroke(255);  // white
  line(xyL.x, xyL.y, xy4L.x, xy4L.y);  // left
  line(xy4R.x, xy4R.y, xyR.x, xyR.y);  // right
  float leftPxls = xy4L.x - xyL.x;
  float rghtPxls = xyR.x - xy4R.x;
  println("left: " + leftPxls + " rght: " + rghtPxls);  // debug - delete
  //--------------------------------------------------------------------------------//

  // Event listerner
  //--------------------------------------------------------------------------------//
  textSize(50);
  fill(255);
  if (leftPxls < minPxls || rghtPxls < minPxls) {
    text("Trigger profile event!", 50, 600);
  } else {
    text("Trigger portrait event!", 50, 600);
  }
  //--------------------------------------------------------------------------------//

  saveFrame("frames/frame-######.png");
}  // draw enclsng brce
//--------------------------------------------------------------------------------//
//----------------------------------- Draw End -----------------------------------//
//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//
//----------------------------- Functionality Start ------------------------------//
//--------------------------------------------------------------------------------//

// Mthd to draw joint node and connector
//--------------------------------------------------------------------------------//
//draw bone #1
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY());
  ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType2].getX(), joints[jointType2].getY());
}  // mthd enclsng brce

//draw bone #2
void drawBone(KJoint[] joints, int jointType1, int jointType2, String joint) {
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY());
  ellipse(0, 0, 25, 25);  
  text(joint, 10, -15);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType2].getX(), joints[jointType2].getY());
}  // mthd enclsng brce
//--------------------------------------------------------------------------------//

// Mthd to draw joint node
//--------------------------------------------------------------------------------//
void drawJoint(KJoint[] joints, int jointType) {
  noStroke();
  pushMatrix();
  translate(joints[jointType].getX(), joints[jointType].getY());
  ellipse(0, 0, 25, 25);
  popMatrix();
  stroke(255);  // white
}  // mthd enclsng brce
//--------------------------------------------------------------------------------//

// Mthd to draw joint node and return xy vals
//--------------------------------------------------------------------------------//
PVector drawJointPV(KJoint[] joints, int jointType, String joint, color col) {
  PVector xy = new PVector(joints[jointType].getX(), joints[jointType].getY());

  noStroke();
  fill(col);
  pushMatrix();
  translate(xy.x, xy.y);
  ellipse(0, 0, 35, 35);
  textSize(14);
  text(joint, 10, -20);
  text("pos x: " + xy.x + "\npos y: " + xy.y, 10, 25);
  popMatrix();

  return xy;
}  // mthd enclsng brce
//--------------------------------------------------------------------------------//

//--------------------------------------------------------------------------------//
//------------------------------ Functionality End -------------------------------//
//--------------------------------------------------------------------------------//