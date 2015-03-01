#include <Servo.h>

// Sweep
// by BARRAGAN <http://barraganstudio.com> 
// This example code is in the public domain.

 
Servo ShoulderServo;  // create servo object to control a servo 
Servo ElbowServo;                // a maximum of eight servo objects can be created 
Servo WristServo;  
Servo BaseServo;
int height = 180;    // variable to store the servo heightition 
int tilt = 90;
int pan = 90;
void setup() 
{ 
  Serial.begin(9600);
  ShoulderServo.attach(9);  // attaches the servo on pin 9 to the servo object 
  ElbowServo.attach(10);
  WristServo.attach(11);
  BaseServo.attach(12);
  ShoulderServo.write(height);             
  ElbowServo.write(height);
  WristServo.write(tilt);  
  BaseServo.write(pan);  
} 
 
   
void loop() 
{ 
  if(Serial.available() > 0)  //checks to see if the serial communication is avaliable
  {
    int data = Serial.read();  //read the incoming bytes
    switch(data)
    {
      case 'w' : if(height > 90) {height -=1;} break;
      case 's' : if (height <180) {height +=1;} break;
      case 'q' : if (tilt > 0) {tilt -=1;} break;
      case 'a' : if (tilt < 180) {tilt +=1;} break;
      case 'e' : if (pan > 0) {pan -=1;} break;
      case 'd' : if (pan < 180) {pan +=1;} break;
      default  : break;
    }
    
  }
                            
    ShoulderServo.write(height);             
    ElbowServo.write(height);
    WristServo.write(tilt);
    BaseServo.write(pan);
    Serial.println(pan);
                       
  
} 
