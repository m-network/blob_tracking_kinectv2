// The kinect stuff is happening in another class
KinectThresh tracker;
Kinect2 kinect;

void kinectSetup() {
  kinect = new Kinect2(this);
  tracker = new KinectThresh();
}

void kinectDraw() {
  // Run the tracking analysis
  tracker.kinectThresh();

  // Display some info
  int t = tracker.getThreshold();
  //fill(0);
  println("threshold: " + t + "    " +  "framerate: " + int(frameRate) + "    " + 
    "UP increase threshold, DOWN decrease threshold");
}

// Adjust the threshold with key presses
void keyPressed() {
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=200;
      tracker.setThreshold(t);
    } else if (keyCode == DOWN) {
      t-=200;
      tracker.setThreshold(t);
    }
  }
}