class Player {
  PVector pos;
  PVector vel;
  Sprite sprite;
  
  Player(int x, int y) {
    pos = new PVector(x,y);
    vel = new PVector(0,0);
    sprite = new Sprite();
  sprite.spritesheet = loadImage("FreeKnight_v1/Colour1/Outline/120x80_PNGSheets/AllAnims.png");
  sprite.spriteFootOffset = 120;

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
    0.1, // frame duration in seconds
    true               // should loop
    );

  sprite.animations.put("idle", idle);
  sprite.changeAnimation("idle");
    
  }//constructah
  
  void draw(float secondsElapsed) {
    updatePos();
    updateAnimation(secondsElapsed);
    sprite.draw(pos.x, pos.y);
  }//draw
  
  void updatePos() {
    vel.y += 0.08;//gravity
    if (vel.mag() > 20) { //terminal velocity calculation
      vel.div(vel.mag());
      vel.mult(20);
    }
    pos.add(vel);
  }//updatePos
  
  void updateAnimation(float secondsElapsed) {
    if (abs(vel.x) > 0.05) {
      sprite.changeAnimation("walk");
    } else {
      sprite.changeAnimation("idle");
    }
    //if (vel.x > 0) {
    //  sprite.facingLeft = false;
    //} else {
    //  sprite.facingLeft = true;
    //}
    sprite.updateAnimation(secondsElapsed);
  }//updateAnimation
}//Player
