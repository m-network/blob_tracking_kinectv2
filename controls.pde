int changeAmount = 20;

// ----------------------------------------------------------------------------
// Adjust the threshold with key presses
void keyPressed() {
  //int t = kinectView.getThreshold();
  //if (key == CODED) {
  //  if (keyCode == UP) {
  //    t+=50;
  //    kinectView.setThreshold(t);
  //  } else if (keyCode == DOWN) {
  //    t-=50;
  //    kinectView.setThreshold(t);
  //  }
  //} 
  if (key == ' ') {
    oscSetupNull();
  } else if (key == 'u') {
    p00+=changeAmount;  
    println(p00);
  } else if (key == 'j') {
    p00-=changeAmount;
    println(p00);
  } else if (key == 'i') {
    pW0+=changeAmount;
    println(pW0);
  } else if (key =='k') {
    pW0-=changeAmount;
    println(pW0);
  } else if (key == 'o') {
    p0H+=changeAmount;
    println(p0H);
  } else if (key =='l') {
    p0H-=changeAmount;
    println(p0H);
  } else if (key == 'p') {
    pWH+=changeAmount;
    println(pWH);
  } else if (key ==';') {
    pWH-=changeAmount;
    println(pWH);
  } 
  // then recalculate
  depthMap = calculateDepthMap(kWidth, kHeight, p00, pW0, p0H, pWH);
  if (key =='c') {
    depthMap = kinect.getRawDepth();
    println("captured blank slate");
  } else if (key == 'a') {
    oscSetupNull();
    println("clearing all osc messages");
  } else if (key == 'w') {
    // write calibration file out
    byte[] b = new byte[depthMap.length];
    for (int i = 0; i < depthMap.length; i++) {
      b[i] = byte(depthMap[i]);
    }
    saveBytes("calibration", b);
    println("calibration file written");
  }
}

//////////////////////////
// CONTROL P5 Functions
//////////////////////////

// ----------------------------------------------------------------------------
void initControls() {
  // Slider for contrast
  cp5.addSlider("contrast")
     .setLabel("contrast")
     .setColorLabel(0x00000000)
     .setPosition(20,20)
     .setRange(0.0,6.0)
     ;
   
  // Slider for threshold
  cp5.addSlider("threshold")
     .setLabel("threshold")
     .setColorLabel(0x00000000)
     .setPosition(20,40)
     .setRange(0,255)
     ;

  // Toggle to activae adaptive threshold
  cp5.addToggle("toggleAdaptiveThreshold")
     .setLabel("use adaptive threshold")
     .setColorLabel(0x00000000)
     .setSize(10,10)
     .setPosition(20,55)
     ;
   
  // Slider for adaptive threshold block size
  cp5.addSlider("thresholdBlockSize")
     .setLabel("a.t. block size")
     .setColorLabel(0x00000000)
     .setPosition(20,80)
     .setRange(1,700)
     ;
   
  // Slider for adaptive threshold constant
  cp5.addSlider("thresholdConstant")
     .setLabel("a.t. constant")
     .setColorLabel(0x00000000)
     .setPosition(20,100)
     .setRange(-100,100)
     ;

  // Slider for blur size
  cp5.addSlider("blurSize")
     .setLabel("blur size")
     .setColorLabel(0x00000000)
     .setPosition(20,120)
     .setRange(1,20)
     ;
   
  // Slider for minimum blob size
  cp5.addSlider("blobSizeThreshold")
     .setLabel("min blob size")
     .setColorLabel(0x00000000)
     .setPosition(20,140)
     .setRange(0,60)
     ;
   
  // Store the default background color, we gonna need it later
  buttonColor = cp5.getController("contrast").getColor().getForeground();
  buttonBgColor = cp5.getController("contrast").getColor().getBackground();
}

// ----------------------------------------------------------------------------
void toggleAdaptiveThreshold(boolean theFlag) {

  useAdaptiveThreshold = theFlag;

  if (useAdaptiveThreshold) {
  
    // Lock basic threshold
    setLock(cp5.getController("threshold"), true);
     
    // Unlock adaptive threshold
    setLock(cp5.getController("thresholdBlockSize"), false);
    setLock(cp5.getController("thresholdConstant"), false);
     
  } else {
  
    // Unlock basic threshold
    setLock(cp5.getController("threshold"), false);
     
    // Lock adaptive threshold
    setLock(cp5.getController("thresholdBlockSize"), true);
    setLock(cp5.getController("thresholdConstant"), true);
  }
}

// ----------------------------------------------------------------------------
void setLock(Controller theController, boolean theValue) {

  theController.setLock(theValue);

  if (theValue) {
    theController.setColorBackground(color(150,150));
    theController.setColorForeground(color(100,100));

  } else {
    theController.setColorBackground(color(buttonBgColor));
    theController.setColorForeground(color(buttonColor));
  }
}