// Tracking Blobs from a Kinect v2 mounted on the ceiling
// Includes methods for sending OSC, and calibrating the floor distance with four corners

// ----------------------------------------------------------------------------
void setup() {
  size(920, 600, P2D);

  kinectSetup();

  opencv = new OpenCV(this, kWidth, kHeight);
  contours = new ArrayList<Contour>();

  // Blobs list
  blobList = new ArrayList<Blob>();

  // Init Controls
  cp5 = new ControlP5(this);
  initControls();

  // Set thresholding
  //toggleAdaptiveThreshold(useAdaptiveThreshold);

  // load calibration if it exists
  try {
    byte b[] = loadBytes("calibration");
    for (int i = 0; i < b.length; i++) {
      depthMap[i] = b[i];
    }
  } 
  catch (NullPointerException e) {
    println("NO CALIBRATION FILE FOUND DEFAULTING");
    depthMap = calculateDepthMap(kWidth, kHeight, p00, pW0, p0H, pWH);
  }

  oscSetup();
  oscSetupNull() ;
}

// ----------------------------------------------------------------------------
void draw() {
  background(255);

  // Kinect Updates
  kinectUpdate();
  //image(kinectView.depthOutput,0,0);

  // Kinect into openCV
  openCvProcess();
  //displayContours();
  //displayImages();

  // Flow Capture and OSC sending
  getAvgFlowPerBlob();
}

///////////////////////
// Display Functions
///////////////////////
// ----------------------------------------------------------------------------
void displayImages() {

  pushMatrix();
  scale(0.5);
  image(depthOutput, 0, 0);
  //image(preProcessedImage, kWidth, 0);
  image(processedImage, 0, kHeight);
  //translate(0, kHeight);
  //stroke(0, 255, 0);
  //opencv.drawOpticalFlow();
  //translate(0, -kHeight);
  image(depthOutput, kWidth, kHeight);
  popMatrix();

  stroke(255);
  fill(255);
  textSize(12);
  text("Source", 10, 25); 
  text("Pre-processed Image", kWidth/2 + 10, 25); 
  text("Processed Image", 10, kHeight/2 + 25);
}

// ----------------------------------------------------------------------------
void displayBlobs() {
  for (Blob b : blobList) {
    strokeWeight(1);
    b.display();
  }
}

// ----------------------------------------------------------------------------
void displayContours() {
  // Contours
  for (int i=0; i<contours.size(); i++) {
    Contour contour = contours.get(i);
    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    contour.draw();
  }
}
// ----------------------------------------------------------------------------
void displayContoursBoundingBoxes() {
  for (int i=0; i<contours.size(); i++) {
    Contour contour = contours.get(i);
    Rectangle r = contour.getBoundingBox();

    if (//(contour.area() > 0.9 * kinect.width * kinect.height) ||
      (r.width < blobSizeThreshold || r.height < blobSizeThreshold))
      continue;

    stroke(255, 0, 0);
    fill(255, 0, 0, 150);
    strokeWeight(2);
    rect(r.x, r.y, r.width, r.height);
  }
}