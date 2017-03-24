// Initialize sending variables
float xPos = 0, xNeg = 0, yPos = 0, yNeg = 0;
float lerpAmount =.3;
float maxValue = .3;

void getAvgFlowPerBlob() {
  // No reset
  xPos = 0;
  xNeg = 0;
  yPos = 0;
  yNeg = 0;
  
  int counter = 0;
  for (Blob b : blobList) {
    Rectangle r = b.getBoundingBox();
    PVector flow = opencv.getAverageFlowInRegion(r.x, r.y, r.width, r.height);
    //println("Blob "+b.id+" Flow: ("+flow.x+", "+flow.y+")");
    //println("Blob "+b.id+": ("+r.x+", "+r.y+", "+r.width+", "+r.height+")");
    
    // Separate variables depending on where they belong
    flow.x = abs(flow.x);
    flow.x = flow.x > maxValue ? flow.x : 0;
    //println("flow x =" + flow.x);
    
    if (flow.x > 0) {
      xPos = flow.x;
    } else {
      xNeg = flow.x;
    }
    flow.y = abs(flow.y);
    flow.y = flow.y > maxValue ? flow.y : 0;
    //println("flow y = " + flow.y);
    if (flow.y > 0) {
      yPos = flow.y;
    } else {
      yNeg = flow.y;
    }
    
    // Send the data out
    sendData(counter);
    counter++;
  }
}