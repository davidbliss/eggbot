// Multi-colored horizontal bars of random width 
// can handle up to 9 colors with current keyboard UI

EggbotCanvas canvas;
ArrayList<Bar> bars;

void setup(){
  // new canvas creates serial connection if true is passed to it.
  canvas = new EggbotCanvas(this, true);
  
  // randomly pick heights for bars up to 700 height
  int totalHeight = 700;
  int maxBarHeight = 13;
  int minBarHeight = 1;
  int numberOfPens = 6;
  
  bars = new ArrayList<Bar>();  // Create an empty ArrayList
  
  Bar aBar;
  while (totalHeight > maxBarHeight) {
    int h = minBarHeight+round(random(maxBarHeight-minBarHeight));
    aBar = new Bar();
    aBar.y = totalHeight;
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
}

void draw() { 
  // keep draw() here to continue looping while waiting for keys
}

void keyPressed() {
  // draw every bar of each color (to minimize pen changes)
  
  int keyIndex = -1;
  if (key >= '1' && key <= '9'){
    for (int i = 0; i < bars.size(); i++){
      canvas.setPen(key-'1');
      if (bars.get(i).pen == key-'0') {
          canvas.drawFilledRect(0, bars.get(i).y, 2000, bars.get(i).height);
      }
    }
  }
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
