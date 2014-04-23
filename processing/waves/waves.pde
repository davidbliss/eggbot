// sine and cos waves

import controlP5.*;

// TODO: Add pulldowns for color setting.

ControlP5 cp5;
EggbotCanvas canvas;
EggbotCanvas printCanvas;
CheckBox wave1draw;
CheckBox wave2draw;
CheckBox wave3draw;
CheckBox wave4draw;

boolean print = false;

int wave1Spacer;
int wave1NumberWaves;
int wave1WaveHeight;

int wave2Spacer;
int wave2NumberWaves;
int wave2WaveHeight;
int wave2offsetX;

int wave3Spacer;
int wave3PeriodMultiplier;

int wave4Spacer;
int wave4offset;
int wave4PeriodMultiplier;

boolean update = true;
void setup(){
  // new canvas creates serial connection if true is passed to it.
  size(1001, 401);
  
  translate(20, 20);
  
  canvas = new EggbotCanvas(this, false);
  canvas.penUp(true);
  canvas.movePen(0, 0);
  canvas.penUp(false);
  
  printCanvas = new EggbotCanvas(this, true);
  printCanvas.penUp(true);
  printCanvas.movePen(0, 0);
  
  translate(0, 0);
  cp5 = new ControlP5(this);
  cp5.addSlider("wave1Spacer")
    .setPosition(20,210)
    .setRange(1,255)
    .setValue(47);
    ;
  cp5.addSlider("wave1NumberWaves")
    .setPosition(20,225)
    .setRange(0,100)
    .setValue(6);
    ;
  cp5.addSlider("wave1WaveHeight")
    .setPosition(20,240)
    .setRange(0,125)
    .setValue(35);
    ;
  wave1draw = cp5.addCheckBox("wave1Draw")
    .setPosition(20, 255)
    .addItem("draw 1", 0)
    ;
  wave1draw.getItem(0).setState(true);
  
  cp5.addButton("print")
     .setPosition(20,300)
     ;
    
  cp5.addSlider("wave2Spacer")
    .setPosition(220,210)
    .setRange(1,255)
    .setValue(47);
    ;
  cp5.addSlider("wave2NumberWaves")
    .setPosition(220,225)
    .setRange(0,100)
    .setValue(6);
    ;
  cp5.addSlider("wave2WaveHeight")
    .setPosition(220,240)
    .setRange(0,125)
    .setValue(50);
    ;
  cp5.addSlider("wave2offsetX")
    .setPosition(220,255)
    .setRange(0,100)
    .setValue(0);
    ;
  wave2draw = cp5.addCheckBox("wave2Draw")
    .setPosition(220, 270)
    .addItem("draw 2", 0)
    ;
  wave2draw.getItem(0).setState(true);
  
  
  cp5.addSlider("wave3Spacer")
    .setPosition(420,210)
    .setRange(20,200)
    .setValue(30);
    ;
  cp5.addSlider("wave3PeriodMultiplier")
    .setPosition(420,225)
    .setRange(0,15)
    .setValue(2);
    ;
  wave3draw = cp5.addCheckBox("wave3Draw")
    .setPosition(420, 240)
    .addItem("draw 3", 0)
    ;
  wave3draw.getItem(0).setState(true);
  
  cp5.addSlider("wave4Spacer")
    .setPosition(620,210)
    .setRange(20,200)
    .setValue(30);
    ;
  cp5.addSlider("wave4PeriodMultiplier")
    .setPosition(620,225)
    .setRange(0,15)
    .setValue(2);
    ;
   cp5.addSlider("wave4offset")
    .setPosition(620,240)
    .setRange(0,100)
    .setValue(3);
    ;
  wave4draw = cp5.addCheckBox("wave4Draw")
    .setPosition(620, 255)
    .addItem("draw 4", 0)
    ;
  wave4draw.getItem(0).setState(true);
  
}


void drawWaves(EggbotCanvas canvas, int yOffset, int xOffset, int numberWaves, float waveHeight){
  ArrayList<Point> plotPoints = new ArrayList<Point>(); ; 
  
  float maxDegrees = 360 * numberWaves;
  float maxPlotX = 2000; // width of the canvas
  
  for (int plotX=0; plotX<=maxPlotX; plotX++) {
    float degrees = maxDegrees/maxPlotX*plotX;
    
    Point tPoint = new Point();
    tPoint.x = plotX+xOffset;
    tPoint.y = yOffset + Math.round(sin(radians(degrees)) * waveHeight);
    plotPoints.add(tPoint);
    
  }
  
  canvas.penUp(true);
  canvas.movePen(plotPoints.get(0).x, plotPoints.get(0).y);
  canvas.penUp(false);
  for (int i=1; i<plotPoints.size(); i++){
    canvas.movePen(plotPoints.get(i).x, plotPoints.get(i).y);
  }

  canvas.penUp(true);
}

void print(){
  println("print called");
  print=true;
  update=true;
}

void drawCosWave(EggbotCanvas canvas, int xOffset, int yOffset, float periodMultiplier, float ampMultiplier, int subSection){
  ArrayList<Point> plotPoints = new ArrayList<Point>(); ; 
  
  for (int i=0; i<subSection; i++){
    Point tPoint = new Point();
    tPoint.x = xOffset + Math.round(i * periodMultiplier);
    tPoint.y = yOffset + Math.round(cos(radians(i)) * ampMultiplier);
    plotPoints.add(tPoint);
  }
  
  canvas.penUp(true);
  canvas.movePen(plotPoints.get(0).x, plotPoints.get(0).y);
  canvas.penUp(false);
  for (int i=1; i<plotPoints.size(); i++){
    canvas.movePen(plotPoints.get(i).x, plotPoints.get(i).y);
  }
  canvas.penUp(true);
}

void drawSinWave(EggbotCanvas canvas, int xOffset, int yOffset, float periodMultiplier, float ampMultiplier){
  ArrayList<Point> plotPoints = new ArrayList<Point>(); ; 
  
  for (int i=0; i<360; i++){
    Point tPoint = new Point();
    tPoint.x = xOffset + Math.round(i * periodMultiplier);
    tPoint.y = yOffset + Math.round(sin(radians(i)) * ampMultiplier);
    plotPoints.add(tPoint);
  }
  
  canvas.penUp(true);
  canvas.movePen(plotPoints.get(0).x, plotPoints.get(0).y);
  canvas.penUp(false);
  for (int i=1; i<plotPoints.size(); i++){
    canvas.movePen(plotPoints.get(i).x, plotPoints.get(i).y);
  }
  canvas.penUp(true);
}

void draw() { 
  if(update){
    EggbotCanvas canvasToUse;
    if (print){
      canvasToUse = printCanvas;
    } else {
      canvasToUse = canvas;
    }
    
    background(200);
    translate(20, 20);
    canvasToUse.drawBackground();
    
    int startYOffset;
    startYOffset=wave1Spacer;
    
    if (wave1draw.getItem(0).getState()){
      canvasToUse.setPen(3);
      for (int yOffset=startYOffset;yOffset<=700; yOffset+=wave1Spacer){
        drawWaves(canvasToUse, yOffset, 0, wave1NumberWaves, wave1WaveHeight);
      }
    }
    
    if (wave2draw.getItem(0).getState()){
      canvasToUse.setPen(3);
      for (int yOffset=startYOffset;yOffset<=700; yOffset+=wave2Spacer){
        drawWaves(canvasToUse, yOffset, wave2offsetX, wave2NumberWaves, wave2WaveHeight);
      }
    }
    
    if (wave3draw.getItem(0).getState()){
      canvasToUse.setPen(1);
      for (int xOffset=0;xOffset<2000; xOffset+=wave3Spacer){
        drawCosWave(canvasToUse, xOffset, 350, wave3PeriodMultiplier, 350, 180);
      }
    }
    
    if (wave4draw.getItem(0).getState()){
      canvasToUse.setPen(1);
      for (int xOffset=0;xOffset<2000; xOffset+=wave4Spacer){
        drawCosWave(canvasToUse, xOffset+wave4offset, 350, wave4PeriodMultiplier, 350, 180);
      }
    }
    
    translate(-20, -20);
    update=false;
    print=false;
  }
}

void controlEvent(ControlEvent theEvent) {
  update=true;
}

void stop() {
  // disconnect from serial
  canvas.disconnect();
  printCanvas.disconnect();
} 

class Point{
  int x, y;
  Point( ){
  }
  Point( int x, int y ){
   this.x = x;
   this.y = y; 
  }
}
