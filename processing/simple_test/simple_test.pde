EggbotCanvas canvas;

void setup(){
  // new canvas creates serial connection if true is passed to it.
  canvas = new EggbotCanvas(this, true);
  
  // put pen down
  canvas.penUp(false);
  
  // draw some lines while pen is down
  canvas.movePen(100,350);
  canvas.movePen(1000,200);
  
  canvas.movePenBy(25,25);
  canvas.movePenBy(-40,10);
  
  // pick up pen
  canvas.penUp(true);
  
  // return to 0 (not required, just an example of moving the pen while up.)
  canvas.movePen(1000,350);
  
  canvas.drawCircle(1000,350, 200, 50, false);
  
  canvas.drawThickCircle(1500, 400, 150, 40, 25);
  
  canvas.drawFilledCircle(700, 100, 75, 50);
  
  canvas.drawRect(50, 50, 50, 100, false);
  
  canvas.drawLine(500, 50, 50, 500);
  
  canvas.drawFilledRect(200, 50, 50, 200);
  
  println("test complete");
}

void draw() {
  // nothing
} 

void stop() {
  // Hmm, does not get called
  // disconnect from serial
  canvas.disconnect();
} 
