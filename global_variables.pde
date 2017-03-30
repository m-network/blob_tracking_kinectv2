import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

import gab.opencv.*;
import java.awt.Rectangle;
import controlP5.*;

import oscP5.*;
import netP5.*;

int outPort= 8001;
int inPort= 9000;
String ip="169.254.249.73";

// IMPORTANT FOR BODY NUMBER CALIBRATION --------------
int BODY_NUM = 2;
boolean[] bodyExists = new boolean[BODY_NUM];

OpenCV opencv;
PImage src, preProcessedImage, processedImage, contoursImage;

ArrayList<Contour> contours;

// List of detected contours parsed as blobs (every frame)
ArrayList<Contour> newBlobContours;

// List of my blob objects (persistent)
ArrayList<Blob> blobList;


// Number of blobs detected over all time. Used to set IDs.
int blobCount = 0;

float contrast = 1.03;
int brightness = 0;
int threshold = 75;
boolean useAdaptiveThreshold = true; // use basic thresholding
int thresholdBlockSize = 671;
int thresholdConstant = -3;
int blobSizeThreshold = 24;
int blurSize = 7;

// Control vars
ControlP5 cp5;
int buttonColor;
int buttonBgColor;