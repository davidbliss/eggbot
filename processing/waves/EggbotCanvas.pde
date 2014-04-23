import processing.serial.*;
// this version of the canvas is meant to be embeded in a larger window to accomidate additional tools.
// also this version won't move backward, moving backward (on my bot at least) is less accurate

class EggbotCanvas {
  PApplet parent;
  int eggWidth=2000; //bot width is 3200, but we scale by 1.6 to account for egg shape
  int eggHeight=700;
  float eggWidthMult = 1.6;
  
  int stageWidth=round(eggWidth/4*eggWidthMult);
  int stageHeight=eggHeight/4;
  
  boolean isPenUp;
  int penX = 0; 
  int penY = 350; // center vertically
  
  Serial controller;  
  boolean isConnected;
  
  color[] pens = {#FAAE74, #EF6000, #FC2700, #F1F1C1, #FAD961, #FFFC0C, #7797FF, #0040C4, #003299};
     
  //Constructor
  EggbotCanvas(PApplet p, boolean drawOnEgg){
    // println("------EggbotCanvas------");
    parent = p;
    isConnected = drawOnEgg; 
    drawBackground();
   
    if (drawOnEgg){
      // find and open the serial port
      String[] ports = Serial.list();
      
      isConnected=false;
      
      for (int i = 0; i < ports.length; i = i+1){
        if (ports[i].indexOf("/dev/tty.usbmodem")==0){
          // this is an arduino port
          println("connecting to: "+ports[i]);
          
          controller = new Serial(parent, ports[i], 9600);
          isConnected=true;
          break;
        }
      }
      
      if (isConnected!=true){
        println("Could not find a port that looked like the eggbot");
      } 
      
      penUp(true);
    }
  }
  
  public void drawBackground(){
    // make the canvas white
    color c = color(255, 255, 255);  // Define color 'c'
    fill(c);  // Use color variable 'c' as fill color
    noStroke();  // Don't draw a stroke around shapes
    rect(0, 0, stageWidth+1, stageHeight+1);  // Draw rectangle
  }
    
  void test(){
    // println("------test------");
    // draw square to test stage dimensions
    noFill();
    setPen(3);
    rect(0, 0, stageWidth, stageHeight);
  }
  
  void disconnect(){
    // println("------disconect------");
    controller.stop();
  }
  
  void setPen(int p) {
    // println("------setPen------");
    stroke(pens[p]);
  }
  
  void penUp(boolean b){
    // println("------penUp:"+b+"------");
    //println("penUp:"+b);
    isPenUp = b;
    
    if (isConnected){
      if (b){
        controller.write("SP,1,300\n");
        controller.write("SM,300,0,0\n");
      } else {
        controller.write("SP,0,300\n");
        controller.write("SM,300,0,0\n");
      }
    }
    /*
    http://www.schmalzhaus.com/EBB/EBBCommands.html
    Format: "SP,<value>,<duration><CR>"
    <value> is 0 (for up) or 1 (for down)
    <duration> (optional parameter - if no value then 500 is used internally) is a value from 1 to 65,535 and is in milliseconds. 
    It represents the total length of time between when the pen move is started, and when the next command will be executed. 
    Note that this does not have anything to do with how fast the pen moves (which is set with the SC command). 
    The <duration> parameter is to force the EBB not to execute the next command (normally an SM) for some length of time, 
    which gives the system time to allow the pen move to complete and then some extra time before moving the motors 
    (if you set up the pen speed and this duration parameter properly).
    */
  }
  
  void movePen(int x, int y){
    // println("------movePen------");
    x =  round(x*eggWidthMult); //adjust for egg shape
    
    if (!isPenUp){
      //println("drawing x:"+x+" y:"+y);
      line(penX/4, penY/4, x/4, y/4); //virtual canvas is quarter resolution
    } else {
      //println("moving x:"+x+" y:"+y);
    }
    
    int deltaX = x - penX;
    int deltaY = penY - y;
    
    while (deltaX<0 && isPenUp) {
      // moving backward it causes calibration to go off
      deltaX=deltaX+3200;
    }
      
    long duration = 9*Math.round(Math.pow(Math.max(Math.abs(deltaX), Math.abs(deltaY)),.66));    
    String command = "SM,"+duration+","+deltaY+","+deltaX+"\n";
    if (isConnected) controller.write(command);
    
    
    
    // For the eggbott, move pen actually moves the servo motors that spin the egg(x) or move the arm holding the pen (y)
    /*
    http://www.schmalzhaus.com/EBB/EBBCommands.html
    Format: "SM,<duration>,<axis1>,<axis2><CR>"
    <duration> is a value from 1 to 65,535 and is in milliseconds. It represents the total length of time you want this move to take.
    <axis1> and <axis2> are values from -32,767 to +32,767 and represent the number of steps for each motor to take in <duration> milliseconds.
    If both <axis1> and <axis2> are zero, then a delay of <duration> ms is executed. <axis2> is an optional value, and if it is not included 
    in the command, zero steps are assumed for axis 2.
    */
    
    
    penX=x;
    penY=y;
    
  }
  
  void movePenBy(int x, int y){
    // println("------movePenBy------");
    // move pen regardless of space (as a vector)
    
    x =  round(x*eggWidthMult); //adjust for egg shape
    
    if (!isPenUp){
      //println("drawing x:"+x+" y:"+y);
      line(penX/4, penY/4, (penX+x)/4, (penY+y)/4); //virtual canvas is quarter resolution
    } else {
      //println("moving x:"+x+" y:"+y);
    }
    
    long duration = 9*Math.round(Math.pow(Math.max(Math.abs(x), Math.abs(y)),.66));
    
    String command = "SM,"+duration+","+-y+","+x+"\n";
    
    if (isConnected) controller.write(command);
    
    penX=penX+x;
    penY=penY+y;
  }
  
  void drawCircle(int cx, int cy, int r, int num_segments, Boolean keepPenDown){ 
    // println("------drawCircle------");
    double theta = 2 * Math.PI / num_segments; // angle to rotate for each line
    
    int x1 = cx+r;
    int x2 = x1;
    int y1 = cy;
    int y2 = y1;
    
    if (!keepPenDown){
      penUp(true);
    }
    
    movePen(x1, y1);
    
    penUp(false);
    //trace("moving pen to start of circle, x:", x1, "y:",y1)
    for(int i = 1; i <= num_segments; i++) { 
      x2 = cx+round((float)(Math.cos(theta*i)*r));
      y2 = cy+round((float)(Math.sin(theta*i)*r));
      if (i==1) {
        //trace("drawing first point, x:", x2, "y:",y2)
        movePen(x2, y2);
      } else if (i==num_segments) {
        //trace("drawing last point, x:", x2, "y:",y2)
        movePen(x2, y2);
      } else {
        movePen(x2, y2);
      }
      
      x1=x2;
      y1=y2;
    } 
    movePen(x1, y1);
    if (!keepPenDown) penUp(true);
  }
  
  void drawThickCircle(int cx, int cy, int outerRadius, int innerRadius, int num_segments){ 
    // println("------drawThickCircle------");
    for(int i = outerRadius; i >= innerRadius; i=i-4) { 
      drawCircle(cx, cy, i, num_segments, true);
    } 
    penUp(true);
    
  }
  
  void drawFilledCircle(int cx, int cy, int r, int num_segments){ 
    // println("------drawFilledCircle------");
    // to prevent calibration problems when moving backward, roll always roll forward
    //while (cx+r < penX/1.6) cx+= 2000;
    
    if(r!=0){
      for(int i = r; i >= 0; i=i-4) { 
        drawCircle(cx, cy, i, num_segments, true);
      } 
      penUp(true);
    }
  }
  
  void drawRect(int x, int y, int w, int h, Boolean keepPenDown){  
    // println("------drawRect------");       
    if (!keepPenDown){
      penUp(true);
    }
    movePen(x, y);
    penUp(false);
    
    movePen(x+w, y);
    movePen(x+w, y+h);
    movePen(x, y+h);
    movePen(x, y);
      
    if (!keepPenDown) penUp(true);
  }
  
  void drawLine(int x, int y, int x2, int y2){
    // println("------drawLine------");       
    penUp(true);
    movePen(x, y);
    penUp(false);
    movePen(x2, y2);
    penUp(true);
  }
  
  void drawFilledRect(int x, int y, int w, int h){ 
    // println("------drawFilledRect------");
    int steps = Math.min(w,h)/2;
    int stepOffset = 4;
    
    penUp(true);
    movePen(x, y);
    penUp(false);
    for(int i = 0; i<steps; i=i+stepOffset) { 
      drawRect(x+(i), y+(i), w-(2*i), h-(2*i), true);
    } 
    penUp(true);
  }
}
