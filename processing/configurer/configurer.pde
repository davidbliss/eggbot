import controlP5.*;
ControlP5 cp5;

EggbotCanvas canvas;

int penMin;
int penMax;

void setup(){
  size(1001, 401);
  translate(20, 20);
  
  canvas = new EggbotCanvas(this, true);
  canvas.penUp(true);
  
  translate(0, 0);
  cp5 = new ControlP5(this);
  
  cp5.addSlider("penUpPosition")
    .setPosition(20,210)
    .setRange(50,100)
    .setValue(74);
    ;
    
  cp5.addSlider("penDownPosition")
    .setPosition(20,225)
    .setRange(50,100)
    .setValue(66);
    ;
    
  cp5.addButton("releaseMotors")
    .setPosition(100,300)
    ;
    
  cp5.addButton("spinMotors")
    .setPosition(100,325)
    ;
     
  cp5.addButton("raisePen")
    .setPosition(20,300)
    ;
  
  cp5.addButton("lowerPen")
    .setPosition(20,325)
    ;
}

void draw() { 
}

void raisePen(){
  println("raisePen called");
  canvas.penUp(true);
}

void lowerPen(){
  println("lowerPen called");
  canvas.penUp(false);
}

void releaseMotors(){
  println("releaseMotors called");
  canvas.releaseMotors();
}

void spinMotors(){
  canvas.movePenBy(10, 10);
}

void controlEvent(ControlEvent theEvent) {
  println("controlEvent called");
  if (theEvent.getName() == "penUpPosition"){
    canvas.setPenMin(round(theEvent.getValue()));
    println("penup");
  } else if (theEvent.getName() == "penDownPosition"){
    println("pendown");
    canvas.setPenMax(round(theEvent.getValue()));
  }
}
