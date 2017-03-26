// Initialize sending variables
float xPos = 0, xNeg = 0, yPos = 0, yNeg = 0;
float lerpAmount =.1;
float maxValue = .1;
int flowOffset = 20;

// ----------------------------------------------------------------------------
void getAvgFlowPerBlob() {
  // No reset
  xPos = 0;
  xNeg = 0;
  yPos = 0;
  yNeg = 0;
  
  for (Blob b : blobList) {
    Rectangle r = b.getBoundingBox();
    int rx, ry, rh, rw;
    rx = constrain(r.x-flowOffset, 0, kWidth);
    ry = constrain(r.y-flowOffset, 0, kHeight);
    rw = constrain(r.width+flowOffset, 0, kWidth);
    rh = constrain(r.height+flowOffset, 0, kHeight);
    
    // constrain values within camera view
    PVector flow = opencv.getAverageFlowInRegion(rx, ry, rw, rh);
    //println("Blob "+b.id+" Flow: ("+flow.x+", "+flow.y+")");
    //println("Blob "+b.id+": ("+r.x+", "+r.y+", "+r.width+", "+r.height+")");
    
    // Separate variables depending on where they belong
    
    //println("flow x =" + flow.x);
    
    // Draw flow
    
    float opacity = map(b.timer, 0, b.initTimer, 0, 127);
    fill(0,0,255,opacity);
    stroke(0,0,255);
    float x = r.x;
    float y = r.y;
    rect(x, y, r.width, r.height);
    fill(255,2*opacity);
    textSize(26);
    text(""+b.id, x+10, y+30);
    
    if (flow.x > 0) {
      // check against threshold
      flow.x = flow.x > maxValue ? flow.x : 0;
      xPos = flow.x;
    } else {
      flow.x = abs(flow.x);
      flow.x = flow.x > maxValue ? flow.x : 0;
      xNeg = flow.x;
    }

    if (flow.y > 0) {
      flow.y = flow.y > maxValue ? flow.y : 0;
      yPos = flow.y;
    } else {
      flow.y = abs(flow.y);
      flow.y = flow.y > maxValue ? flow.y : 0;
      yNeg = flow.y;
    }
    
    // Send the data out
    sendData(b.bodyId);
  }
}