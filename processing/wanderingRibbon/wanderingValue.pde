class WanderingValue {
  PApplet parent;
  
  private int v = 0;
  private int maxV = 100;
  private int minV = 0;
  private int maxVelV = 5;
  private int minVelV = -5;
  private float velV = 0;
  private int directionAccelV;
  private float probChangeDirectionAccelV = 0;
  private float probIncrement =.01;
  private float accelV = .3;
  
  WanderingValue(PApplet p){
    if (random(1.0) < .5) {
      directionAccelV = 1;
    } else {
      directionAccelV = -1;
    }
  }
  
  int getValue(){
    if (v > maxV-30 && directionAccelV ==1) {
      probChangeDirectionAccelV += .5;
      if (random(1.0) < probChangeDirectionAccelV) {
        directionAccelV=-1;
        probChangeDirectionAccelV = 0;
      }
    } else if (v < 10 && directionAccelV == -1) {
      probChangeDirectionAccelV += .5;
      if (random(1.0)<probChangeDirectionAccelV) {
        directionAccelV = 1;
        probChangeDirectionAccelV = 0;
      }
    } else if (random(1.0) < probChangeDirectionAccelV) {
      directionAccelV *= -1;
      probChangeDirectionAccelV = 0;
    } else {
      probChangeDirectionAccelV += probIncrement;
    }
    
    velV += (accelV * directionAccelV);
    velV = min(velV, maxVelV);
    velV = max(velV, minVelV);
    
    v += velV;
    
    v=min(v, maxV);
    v=max(v, minV);
    
    return Math.round(v);
  }
}
