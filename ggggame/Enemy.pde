class Enemy {
  Sprite sprite;

  PVector pos;
  PVector vel;
  float health;
  
  void draw(float secondsElapsed) {
    updatePos();
    sprite.updateAnimation(secondsElapsed);
    sprite.draw(pos.x, pos.y, 0);
  }
  
  void updatePos() {
    
    
   if (clipping() != 1) { //in air
      vel.y += gravity;
    } 
    pos.add(vel);
    collisionCorrect();
    collisionCorrect(); //important that collisions are *double resolved*
  }//updatePos
  
  void collisionCorrect() {
    if (clipping() == 1) {
      vel.y = 0;
      while (sideClip(pos.x - 10, pos.y + 29, 20, 1) != 0) {
        pos.y --;
      }
    } else if (clipping() == 0) {
      vel.y = 0;
      while (sideClip(pos.x - 10, pos.y - 2, 20, 1) != 0) {
        pos.y ++;
      }
    } else if (clipping() == 3) {
      while (sideClip(pos.x + 10, pos.y, 1, 30) != 0) {
        pos.x --;
      }
      vel.y = -5;
    } else if (clipping() == 2) {
      while (sideClip(pos.x - 10, pos.y, 1, 30) != 0) {
        pos.x ++;
      }
      vel.y = -5;
    }
  }
  
  int clipping() { //which side of the player is most clipped inside of a wall?
    int[] clips = new int[4]; //0 = top, 1 = bottom, 2 = left, 3 = right
    int max;

    clips[0] = sideClip(pos.x - 10, pos.y, 20, 1);//top
    clips[1] = sideClip(pos.x - 10, pos.y + 30, 20, 1);//bottom
    clips[2] = sideClip(pos.x - 10, pos.y, 1, 30);//left
    clips[3] = sideClip(pos.x + 10, pos.y, 1, 30);//right

    max = max(clips);

    if (max == 0) {
      return -1;
    }
    if (max == clips[0]) {
      return 0;
    } else if (max == clips[1]) {
      return 1;
    } else if (max == clips[2]) {
      return 2;
    } else {
      return 3;
    }
  }
  
}
