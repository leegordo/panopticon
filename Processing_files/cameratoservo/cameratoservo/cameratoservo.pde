import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import java.awt.Rectangle;  //A rectangle class which keeps track of the face coordinates.
import processing.serial.*; //The serial library is needed to communicate with the Arduino.

Capture video;
OpenCV opencv;

Serial arduinoPort; // The serial port

//Variables for keeping track of the current servo positions.
char servoTiltPosition = 90;
char tiltChannel = 0;


//These variables hold the x and y location for the middle of the detected face.
int midFaceY=0;
int midFaceX=0;

//The variables correspond to the middle of the screen, and will be compared to the midFace values
int midScreenY = (height/2);
int midScreenX = (width/2);
int midScreenWindow = 10;  //This is the acceptable 'error' for the center of the screen. 

//The degree of change that will be applied to the servo each time we update the position.
int stepSize=3;


void setup() {
  size(640, 480);
  //video = new Capture(this, 640/2, 480/2);
    String Vid = "USB2.0 Camera";
  video = new Capture(this, 640/2, 480/2, Vid);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
  
  println(Serial.list()); // List COM-ports (Use this to figure out which port the Arduino is connected to)

  //select first com-port from the list (change the number in the [] if your sketch fails to connect to the Arduino)
  arduinoPort = new Serial(this, Serial.list()[2], 9600);   //Baud rate is set to 57600 to match the Arduino baud rate.

 //Send the initial pan/tilt angles to the Arduino to set the device up to look straight forward.
  arduinoPort.write(tiltChannel);    //Send the Tilt Servo ID
  arduinoPort.write(servoTiltPosition);  //Send the Tilt Position (currently 90 degrees)
}

void draw() {

  
  scale(2);
  opencv.loadImage(video);

  image(video, 0, 0 );

  noFill();
  stroke(192, 0, 0);
  strokeWeight(2);
  Rectangle[] faces = opencv.detect();
  println(faces.length);

 for( int i=0; i<faces.length; i++ ) {
        rect( faces[i].x, faces[i].y, faces[i].width, faces[i].height ); 
    
    if(faces[i].x  < 80){
     println("Left"); 
     arduinoPort.write("e");
   }
     
   if(faces[i].x + faces[i].width > 240){
    println("Right"); 
    arduinoPort.write("d");
   }
  
  if(faces[i].y + faces[i].height > 180){
    println("Bottom"); 
    arduinoPort.write("q");
   }

  if(faces[i].y < 60){
   println("Top"); 
   arduinoPort.write("a");
  }

  }
   
  // line(0, 180, 320, 180);  //top boundary
  // line(0, 60, 320, 60);  //bottom boundary
  // line(80, 0, 80, 240);  //left boundary
  // line(240, 0, 240, 240);  //right boundary
}


void captureEvent(Capture c) {
  c.read();
}

