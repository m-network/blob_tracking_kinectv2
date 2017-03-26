Kinect2 kinect;

// Depth image
PImage depthOutput;

// Added depthMap
int[] depthMap;

// Which pixels do we care about?
int minDepth =  100;
int maxDepth =  3600; //4.5m
int[] rawDepth;

// All points start at 1300
int p00 = 3340, pW0 = 4620, p0H = 3600, pWH = 4600;

int kWidth, kHeight;

void kinectSetup() {
  kinect = new Kinect2(this);
  kinect.initDepth();
  kinect.initDevice();

  kWidth = kinect.depthWidth;
  kHeight = kinect.depthHeight;
  // Blank image
  depthOutput = new PImage(kWidth, kHeight);
  
  // Added second map to compare incoming data to
  depthMap = new int[kWidth*kHeight];
  
  // load calibration if it exists
  try {
    byte b[] = loadBytes("calibration");
    for (int i = 0; i < b.length; i++) {
      depthMap[i] = b[i];
    }
  } catch (NullPointerException e) {
    println("NO CALIBRATION FILE FOUND USING DEFAULT VALUES");
    depthMap = calculateDepthMap(kWidth, kHeight, p00, pW0, p0H, pWH);
  }
}

void kinectUpdate() {
  background(255);
  // Draw the raw image
  //image(kinect2.getDepthImage(), 0, 50);

  // Threshold the depth image
  rawDepth = kinect.getRawDepth();
  
  for (int i=0; i < rawDepth.length; i++) {
    if (rawDepth[i] >= minDepth && rawDepth[i] <= depthMap[i]) {
      depthOutput.pixels[i] = color(0);
    } else {
      depthOutput.pixels[i] = color(255);
    }
  }
  // Draw the thresholded image
  depthOutput.updatePixels();
  //image(depthImg, kinect2.depthWidth, 0);
  
  image(depthOutput, 0, 0);
  //filter(BLUR, 1);
  //filter(DILATE);
  //filter(ERODE);
}

// Calculating the depth map and returning it to sender for comparison
int[] calculateDepthMap(int dW, int dH, int p1, int p2, int p3, int p4) {
  // p1 is 0,0 and subsequent goes clockwise
  int[] dMap = new int[dW*dH];
  float o_p1p2, o_p3p4;
  for (int x = 0; x < dW; x++) {
    // for every x step, calculate depthThreshold value first
    // p1 - p2 width calculation
    o_p1p2 = map(x, 0, dW, p1, p2);
    o_p3p4 = map(x, 0, dW, p3, p4);

    for (int y = 0; y < dH; y++) {
      int offset =  x + y*dW;
      // Grabbing the raw depth
      dMap[offset] = (int) map(y, 0, dH, o_p1p2, o_p3p4);
    }
  }
  return dMap;
}