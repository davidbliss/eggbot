// Multi-colored horizontal bars of random width 
// can handle up to 9 colors with current keyboard UI
import controlP5.*;
ControlP5 cp5;
Textarea myTextarea;

EggbotCanvas canvas;
EggbotCanvas printCanvas;

ArrayList<Bar> bars;

int totalHeight = 700;
int maxBarHeight = 13;
int minBarHeight = 1;
int numberOfPens = 6;

boolean update = true;

void setup(){
  size(1001, 401);
  translate(20, 20);
  canvas = new EggbotCanvas(this, false);
  printCanvas = new EggbotCanvas(this, true);
  
  
  translate(0, 0);
  cp5 = new ControlP5(this);
  
  cp5.addSlider("maxBarHeight")
    .setPosition(20,210)
    .setRange(1,50)
    .setValue(20);
    ;
    
  cp5.addSlider("minBarHeight")
    .setPosition(20,225)
    .setRange(1,25)
    .setValue(5);
    ;
    
  cp5.addSlider("numberOfPens")
    .setPosition(20,240)
    .setRange(1,9)
    .setValue(6);
    ;
  
  myTextarea = cp5.addTextarea("txt")
    .setPosition(20,300)
    .setFont(createFont("arial",12))
    .setSize(225,20)
    .setLineHeight(14)
    .setColor(color(128))
    .setColorBackground(color(255,100))
    .setColorForeground(color(255,100));
    ;
  myTextarea.setText("Use keys 1-9 to print each pen color" );
  
 // General tools
 cp5.addButton("releaseMotors")
    .setPosition(750,300)
    ;
    
  cp5.addButton("raisePen")
    .setPosition(750,325)
    ;
  
  cp5.addButton("lowerPen")
    .setPosition(750,350)
    ; 
    
}

void draw() { 
  // keep draw() here to continue looping while waiting for keys
  
  if (update){
    background(200);
    translate(20, 20);
    canvas.drawBackground();
    translate(-20, -20);
    
    bars = new ArrayList<Bar>();  // Create an empty ArrayList
    
    Bar aBar;
    
    while (totalHeight > maxBarHeight) {
      int h = minBarHeight+round(random(maxBarHeight-minBarHeight));
      println(h);
      aBar = new Bar();
      aBar.y = totalHeight-h;
      aBar.height = h;
      aBar.pen = 1+round(random(numberOfPens-1));
      bars.add(aBar);
      totalHeight -= h;
    }
    
    aBar = new Bar();
    aBar.y = 0;
    aBar.height = totalHeight;
    aBar.pen = 1+round(random(numberOfPens-1));
    bars.add(aBar);
    
    for (int b=1; b<=numberOfPens; b++){
      drawBar(b, false);
    }  
  
    update=false;
  }
}

void drawBar(int k, boolean print){
  EggbotCanvas canvasToUse;
  if (print){
    canvasToUse = printCanvas;
  } else {
    canvasToUse = canvas;
  }
  translate(20, 20);
  
  for (int i = 0; i < bars.size(); i++){
    canvas.setPen(k-1);
    if (bars.get(i).pen == k-0) {
        canvasToUse.drawFilledRect(0, bars.get(i).y, 2000, bars.get(i).height);
    }
  }
  translate(-20, -20);
}

void keyPressed() {
  // draw every bar of each color (to minimize pen changes)
  
  int keyIndex = -1;
  if (key >= '1' && key <= '9'){
    int k=key-'0';
    drawBar(k, true);
  }
}

void controlEvent(ControlEvent theEvent) {
  totalHeight=700;
  update=true;
}

void stop() {
  // disconnect from serial
  canvas.disconnect();
} 

class Bar {
  int height;
  int y;
  int pen;
  
  Bar(){}
}

void raisePen(){
  println("raisePen called");
  printCanvas.penUp(true);
}

void lowerPen(){
  println("lowerPen called");
  printCanvas.penUp(false);
}

void releaseMotors(){
  println("releaseMotors called");
  printCanvas.releaseMotors();
}
