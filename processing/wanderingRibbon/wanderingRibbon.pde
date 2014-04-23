// Multi-colored vertical bars of random width 
// can handle up to 9 colors with current keyboard UI

EggbotCanvas preview;
EggbotCanvas canvas;

ArrayList<ArrayList> fillLines;
ArrayList<Point> baseLine;
ArrayList<Point> topLine;
ArrayList<Point> bottomLine; 
ArrayList<Point> nextFillLine;
    
void setup(){
  preview = new EggbotCanvas(this, false);
  canvas = new EggbotCanvas(this, true);
  
  fillLines = new ArrayList<ArrayList>();  // Create an empty ArrayList
  baseLine = new ArrayList<Point>();
  topLine = new ArrayList<Point>();
  bottomLine = new ArrayList<Point>(); 
  nextFillLine = new ArrayList<Point>(); 
  
  // First set the baseline
  int wanderX = 0;
  int maxX = wanderX + 1750 + round(random(500)); 
  int minY = 50;
  int maxY = 550;
  int wanderY = round(random(maxY));
  int maxVelX = 15;
  int maxVelY = 5;
  int minVelX = 3;
  int minVelY = -5;
  float velX = round(random(maxVelX - minVelX) + minVelX);
  float velY = round(random(maxVelY - maxVelY) + maxVelY);
  float accelX = .4;
  float accelY = .4;
  int directionAccelX;
  int directionAccelY;
  if (random(1.0) < .5) {
    directionAccelX = 1;
  }else {
    directionAccelX = -1;
  }
  if (random(1.0) < .5) {
    directionAccelY = 1;
  }else {
    directionAccelY = -1;
  }
  float probChangeDirectionAccelX = 0;
  float probChangeDirectionAccelY = 0;
  float probIncrement = .01;
  
  while (wanderX < maxX){
    velX += (accelX * directionAccelX);
    if (random(1.0) < probChangeDirectionAccelX) {
      directionAccelX *= -1;
      probChangeDirectionAccelX = 0;
    } else {
      probChangeDirectionAccelX += probIncrement;
    }
    
    velX = min(velX, maxVelX);
    velX = max(velX, minVelX);
    
    if (wanderY > maxY - 100 && directionAccelY == 1) {
      probChangeDirectionAccelY += .5;
      if (random(1.0) < probChangeDirectionAccelY) {
        directionAccelY = -1;
        probChangeDirectionAccelY = 0;
      }
    } else if (wanderY < minY + 100 && directionAccelY == -1) {
      probChangeDirectionAccelY += .5;
      if (random(1.0) < probChangeDirectionAccelY) {
        directionAccelY = 1;
        probChangeDirectionAccelY = 0;
      }
    } else if (random(1.0) < probChangeDirectionAccelY) {
      directionAccelY *= -1;
      probChangeDirectionAccelY = 0;
    } else {
      probChangeDirectionAccelY += probIncrement;
    }
    
    velY += (accelY * directionAccelY);
    
    velY = min(velY, maxVelY);
    velY = max(velY, minVelY);
    
    wanderY += round(velY);
    wanderX += round(velX);
    
    Point aPoint = new Point(wanderX, wanderY);
    baseLine.add(aPoint);
  }
  // END Draw baseline
    
  // Draw top and bottom lines
  int maxLines = 30;
  WanderingValue topWanderV = new WanderingValue(this);
  WanderingValue bottomWanderV = new WanderingValue(this);
  
  float maxTopWander = 0;
  float maxBottomWander = 0;
  
  float convergenceRange = baseLine.size() / 5;
  
  for (int ii = 0; ii < baseLine.size(); ii++){
    Point aPoint = new Point(0, 0);
    aPoint.x = baseLine.get(ii).x;
    int wanderingV = topWanderV.getValue();
    if (wanderingV > maxTopWander) maxTopWander = wanderingV;
    if (ii > baseLine.size() - convergenceRange) {
      float convergenceMultiple = (baseLine.size() - ii) / convergenceRange;
      aPoint.y = baseLine.get(ii).y + round(wanderingV * convergenceMultiple);
    } else {
      aPoint.y = baseLine.get(ii).y + wanderingV;
    }
    
    topLine.add(aPoint);
  }
  for (int ii = 0; ii < baseLine.size(); ii++){
    Point aPoint = new Point(0, 0);
    aPoint.x = baseLine.get(ii).x;
    int wanderingV = bottomWanderV.getValue();
    if (wanderingV > maxBottomWander) maxBottomWander = wanderingV;
    if (ii > baseLine.size() - convergenceRange) {
      float convergenceMultiple = (baseLine.size() - ii) / convergenceRange;
      aPoint.y = baseLine.get(ii).y - round(wanderingV * convergenceMultiple);
    } else {
      aPoint.y = baseLine.get(ii).y - wanderingV;
    }
    
    bottomLine.add(aPoint);
  }
  
  // fill in the top
  for (int i = 0; i < round(maxTopWander / 3); i++){
    nextFillLine = new ArrayList<Point>();
    for (int ii = 0; ii < baseLine.size(); ii++){
      Point aPoint = new Point(0, 0);
      aPoint.x = baseLine.get(ii).x;
      aPoint.y = baseLine.get(ii).y + round(((topLine.get(ii).y - baseLine.get(ii).y) * (i / (maxTopWander / 3))));
      nextFillLine.add(aPoint);
    }
    fillLines.add(nextFillLine);
  }
  // fill in the bottom
  for (int i = 0; i < round(maxBottomWander / 3); i++){
    nextFillLine = new ArrayList<Point>();
    for (int ii = 0; ii < baseLine.size(); ii++){
      Point aPoint = new Point(0, 0);
      aPoint.x = baseLine.get(ii).x;
      aPoint.y = baseLine.get(ii).y + round(((bottomLine.get(ii).y - baseLine.get(ii).y) * (i / (maxBottomWander / 3))));
      nextFillLine.add(aPoint);
    }
    fillLines.add(nextFillLine);
  }
 
  previewLine(topLine, 1);
  previewLine(bottomLine, 1); 
}

void draw() { 
  // keep draw() here to continue looping while waiting for keys
}

void previewLine(ArrayList<Point> line, int pen) {
  preview.setPen(pen);
  preview.penUp(true);
  preview.movePen(line.get(0).x, line.get(0).y);
  preview.penUp(false);
  for (int ii = 1; ii < line.size(); ii++){
     preview.movePen(line.get(ii).x, line.get(ii).y);
  }
  preview.penUp(true);
}

void drawLine(ArrayList<Point> line, int pen) {
  canvas.setPen(pen);
  canvas.penUp(true);
  canvas.movePen(line.get(0).x, line.get(0).y);
  canvas.penUp(false);
  for (int ii = 1; ii < line.size(); ii++){
     canvas.movePen(line.get(ii).x, line.get(ii).y);
  }
  canvas.penUp(true);
}

void keyPressed() {
  // draw baseline and fills in one color (this is the middle stuff)
  if (key == '1'){
    // draw baseline
    drawLine(baseLine, 0);
    
    // draw fill lines
    for (int i = 0; i < fillLines.size(); i++){
      drawLine(fillLines.get(i), 0);
    }
  }
  
  // draw the top and bottom in a second color
  if (key == '2'){
    // draw top
    drawLine(topLine, 1);
    // draw bottom
    drawLine(bottomLine, 1);
  }
}

void stop() {
  // disconnect from serial
  canvas.disconnect();
} 

class Point{
  int x, y;
  Point( int x, int y ){
   this.x = x;
   this.y = y; 
  }
}

