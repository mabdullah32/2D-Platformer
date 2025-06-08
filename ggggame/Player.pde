class Player {
  PVector pos;
  PVector vel;
  int jumpTimer;
  Sprite sprite;
  
  Player(int x, int y) {
    pos = new PVector(x,y);
    vel = new PVector(0,0);
    sprite = new Sprite();
  sprite.spritesheet = loadImage("FreeKnight_v1/Colour1/Outline/120x80_PNGSheets/AllAnims.png");
  sprite.spriteFootOffset = 0;

  Animation walk = new Animation(
    0, 80 * (21 - 1), // topLeftX, topLeftY of the first frame
    120, 80, // frame width and height
    10, // number of frames
    0.1, // frame duration in seconds
    true               // should loop
    );

  sprite.animations.put("walk", walk);
  
  Animation idle = new Animation(
    0, 80 * (17 - 1), // topLeftX, topLeftY of the first frame
    120, 80, // frame width and height
    10, // number of frames
    0.8, // frame duration in seconds
    true               // should loop
    );

  sprite.animations.put("idle", idle);
  
  Animation jump = new Animation(
    0, 80 * (18 - 1), // topLeftX, topLeftY of the first frame
    120, 80, // frame width and height
    3, // number of frames
    0.1, // frame duration in seconds
    true               // should loop
    );

  sprite.animations.put("jump", jump);
  
  Animation fall = new Animation(
    0, 80 * (15 - 1), // topLeftX, topLeftY of the first frame
    120, 80, // frame width and height
    3, // number of frames
    0.1, // frame duration in seconds
    true               // should loop
    );

  sprite.animations.put("fall", fall);
  
  sprite.changeAnimation("idle");
    
  }//constructah
  
  void draw(float secondsElapsed) {
    updateAnimation(secondsElapsed);
    sprite.draw(pos.x, pos.y);
  }//draw
  
  void updatePos() {
    
    PVector drag = new PVector(vel.x, vel.y); 
    drag.mult(vel.mag()/100);
    
    vel.sub(drag);
    pos.add(vel);
    if (clipping() == 0) {
      vel.y += 0.08;//gravity
      jumpTimer++;
    } else if (clipping() >= 1 && clipping() < 2) {
      vel.y = 0;
      player.jumpTimer = 0;
      if ((bounding.pixels[getIndex(bounding, pos.x, pos.y + 35)] == #0ED145 && vel.x < 0.5) || //green, left-up inclines
          (bounding.pixels[getIndex(bounding, pos.x, pos.y + 35)] == #b83dba && vel.x > 0.5)) { //purple, right-up inclines
        vel.y = -1.2;
      }
      while (bounding.pixels[getIndex(bounding, pos.x, pos.y + 35)] == #EC1C24 || bounding.pixels[getIndex(bounding, pos.x, pos.y + 35)] == #ffca18) { //red, hard boundaries
        pos.y --;
      }
      while (bounding.pixels[getIndex(bounding, pos.x, pos.y)] == #EC1C24 || bounding.pixels[getIndex(bounding, pos.x, pos.y)] == #ffca18) {
        pos.y ++;
      }
    } else {
      if (!keys['s']) {
        if (vel.x > 0) {
          while (clipping() > 2) {
            pos.x --;
          }
        } else {
          while (clipping() > 2) {
            pos.x ++;
          }
        }
      }
      vel.x = 0;
      
    }
  }//updatePos
  
  int clipping() {
    int clipPoints = 0;
    for (int i = 0; i < 10; i++) {
      if (bounding.pixels[getIndex(bounding, pos.x, pos.y + 5 * i)] == #EC1C24 || (bounding.pixels[getIndex(bounding, pos.x, pos.y + 5 * i)] == #ffca18 && !keys['s'])) { //bounding color
        clipPoints++;
      }
    }
    return clipPoints;
  }//clipping
  
  void updateAnimation(float secondsElapsed) {
    if (vel.y < -1.2) {
      sprite.changeAnimation("jump");
      println("jump");
    } else if (vel.y > 0.1) {
      sprite.changeAnimation("fall");
      println("fall");
    } else if (abs(vel.x) > 0.05) {
      sprite.changeAnimation("walk");
      println("walk " + vel.y + " " + vel.x);
    } else {
      sprite.changeAnimation("idle");
      println("idle");
    }
    //if (vel.x > 0) {
    //  sprite.facingLeft = false;
    //} else {
    //  sprite.facingLeft = true;
    //}
    sprite.updateAnimation(secondsElapsed);
  }//updateAnimation
}//Player
