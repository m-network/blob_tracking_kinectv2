import oscP5.*;
import netP5.*;

// Messages
OscP5 oscP5;
NetAddress myRemoteLocation;

int outPort= 8001;
int inPort= 9000;
String ip="10.0.1.4";

void oscSetup() {
  oscP5 = new OscP5(this, inPort);
  myRemoteLocation = new NetAddress(ip, outPort);
}

void sendData(int c) {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/body" + c);

  myMessage.add(xPos);
  myMessage.add(xNeg);
  myMessage.add(yPos);
  myMessage.add(yNeg);

  //println(myMessage);

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
}

void oscSendEmpty(int v) {
  OscMessage myMessage = new OscMessage("/body" + v);
  myMessage.add(0);
  myMessage.add(0);
  myMessage.add(0);
  myMessage.add(0);
  oscP5.send(myMessage, myRemoteLocation);
}

void oscSetupNull() {
  for (int i = 0; i < 4; i++) {
    oscSendEmpty(i);
  }
}