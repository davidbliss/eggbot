// Multi-colored vertical bars of random width 
// can handle up to 9 colors with current keyboard UI

// to reduce jitters, place the drawing arm as close to the egg as possible (near the end of the pen)

EggbotCanvas canvas;
int rotations = 35;    // 35 rotations is a nice tight spiral

void setup(){
  // new canvas creates serial connection if true is passed to it.
  canvas = new EggbotCanvas(this, true);  
}

void draw() { 
  // keep draw() here to continue looping while waiting for keys
}

void keyPressed() {
  // draw every bar of each color (to minimize pen changes)
 
  int keyIndex = -1;
  if (key == '1'){
    canvas.penUp(true);
    canvas.movePen(round(canvas.penX/1.6), 0);
    canvas.penUp(false);
    
    //TODO: might eliminate jitters by drawing shorter lines (e.g. in increments where deltay=1)
    for (int i = 0; i < rotations; i++) {
      canvas.movePenBy(2000, 700/rotations);
    }
  } else if (key == '2'){
    
    canvas.penUp(true);
    canvas.movePen(round(canvas.penX/1.6), 700);
    canvas.penUp(false);
    for (int i = 0; i < rotations; i++) {
      canvas.movePenBy(2000, -700/rotations);
    }
  }
  canvas.penUp(true);
}


void stop() {
  // disconnect from serial
  canvas.disconnect();
} 
