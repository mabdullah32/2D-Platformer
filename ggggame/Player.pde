class Player {
  
  PVector pos;
  PVector vel;
  int jumpTimer;
  int dropTimer;
  boolean onWall;
  
  Sprite sprite;
  Sprite effect;
  
  float health;
  int[] resources;

  Player(int x, int y) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    sprite = new Sprite();
    sprite.spritesheet = loadImage("FreeKnight_v1/Colour1/Outline/120x80_PNGSheets/AllAnims.png");
    sprite.spriteFootOffset = 0;
    
    effect = new Sprite();
    effect.spritesheet = loadImage("Zweihander_Combat/Spritesheet/Zweihander_Spritesheet_Fx.png");
    effect.spriteFootOffset = 45;
    effect.position = new PVector();

    Animation walk = new Animation(
      0, 80 * (21 - 1), // topLeftX, topLeftY of the first frame
      120, 80, // frame width and height
      10, // number of frames
      0.2, // frame duration in seconds
      true               // should loop
      );

    sprite.animations.put("walk", walk);

    Animation idle = new Animation(
      0, 80 * (17 - 1), // topLeftX, topLeftY of the first frame
      120, 80, // frame width and height
      10, // number of frames
      0.3, // frame duration in seconds
      true               // should loop
      );

    sprite.animations.put("idle", idle);

    Animation jump = new Animation(
      0, 80 * (18 - 1), // topLeftX, topLeftY of the first frame
      120, 80, // frame width and height
      3, // number of frames
      0.3, // frame duration in seconds
      true               // should loop
      );

    sprite.animations.put("jump", jump);

    Animation fall = new Animation(
      0, 80 * (15 - 1), // topLeftX, topLeftY of the first frame
      120, 80, // frame width and height
      3, // number of frames
      0.3, // frame duration in seconds
      true               // should loop
      );

    sprite.animations.put("fall", fall);

    Animation transition = new Animation(
      0, 80 * (19 - 1), // topLeftX, topLeftY of the first frame
      120, 80, // frame width and height
      2, // number of frames
      0.3, // frame duration in seconds
      true               // should loop
      );

    sprite.animations.put("transition", transition);

    Animation crouch = new Animation(
      0, 80 * (7 - 1), // topLeftX, topLeftY of the first frame
      120, 80, // frame width and height
      1, // number of frames
      0.3, // frame duration in seconds
      true               // should loop
      );

    sprite.animations.put("crouch", crouch);

    Animation crouchWalk = new Animation(
      0, 80 * (11 - 1), // topLeftX, topLeftY of the first frame
      120, 80, // frame width and height
      8, // number of frames
      0.3, // frame duration in seconds
      true               // should loop
      );

    sprite.animations.put("crouchWalk", crouchWalk);

    Animation wallSlide = new Animation(
      0, 80 * (30 - 1), // topLeftX, topLeftY of the first frame
      120, 80, // frame width and height
      3, // number of frames
      0.3, // frame duration in seconds
      true               // should loop
      );

    sprite.animations.put("wallSlide", wallSlide);
    
    Animation def = new Animation(
      256 * 4, 256 * 6, // topLeftX, topLeftY of the first frame
      256, 256, // frame width and height
      5, // number of frames
      0.1, // frame duration in seconds
      false               // should loop
      );

    effect.animations.put("default", def);

    sprite.changeAnimation("idle");
    effect.changeAnimation("default");
  }//constructah

  void draw(float secondsElapsed) {
    updateAnimation(secondsElapsed);
    //rect(pos.x - 10, pos.y, 20, 40);
    sprite.draw(pos.x, pos.y, 0);
    effect.updateAnimation(secondsElapsed);
    effect.draw(-PI/2);
  }//draw

  void updatePos() {

    PVector drag = new PVector(vel.x, vel.y);
    drag.mult(vel.mag()/400);

    if (((keys['a'] && clipping(floor(pos.x + vel.x), pos.y) == 2) ||
      (keys['d'] && clipping(ceil(pos.x + vel.x), pos.y) == 3)) 
      && clipping() != 1 && bounding.pixels[getIndex(bounding, pos.x, pos.y)] != #00a8f3) {//blue, no-wallHang zones
      onWall = true;
    }

    vel.sub(drag);
    if (!onWall) {
      pos.add(vel);
    }
    dropTimer++;
    if (clipping() != 1 && !onWall) { //in air
      vel.y += gravity;
      jumpTimer++;
    } else { //on ground
      if (clipping() == 1) {
        jumpTimer = 0;
      }
      if (abs(vel.x) > 0.1) {
        vel.x += (vel.x > 0) ? -friction: friction;
      } else {
        vel.x = 0; //for smoothness
      }
    }
    collisionCheck();
    collisionCheck(); //important that collisions are *double checked*
  }//updatePos

  void collisionCheck() {
    if (clipping() == 1) {
      if (vel.mag() > 8) {
        effect.secondsSinceAnimationStarted = 0;
        effect.position.x = pos.x;
        effect.position.y = pos.y;
      }
      vel.y = 0;
      if ((bounding.pixels[getIndex(bounding, pos.x, pos.y + 35)] == #0ED145 && vel.x < 0.5) || //green, left-up inclines
        (bounding.pixels[getIndex(bounding, pos.x, pos.y + 35)] == #b83dba && vel.x > 0.5)) { //purple, right-up inclines
        vel.y = -0.6;
      }
      while (pixelClip(pos.x, pos.y + 39)) {
        pos.y --;
      }
    } else if (clipping() == 0) {
      vel.y = 0;
      int counter = 1;
      while (counter != 0) {
        counter = 0;
        for (int i = 0; i < 12; i++) {
          if (pixelClip(pos.x - 6 + i, pos.y - 2)) {
            counter++;
          }
        }
        pos.y ++;
      }
    } else if (clipping() == 3) {
      int counter = 1;
      while (counter != 0) {
        counter = 0;
        for (int i = 0; i < 32; i++) {
          if (pixelClip(pos.x + 10, pos.y + 4 + i)) {
            counter++;
          }
        }
        pos.x --;
      }
      vel.x = 0;
    } else if (clipping() == 2) {
      int counter = 1;
      while (counter != 0) {
        counter = 0;
        for (int i = 0; i < 32; i++) {
          if (pixelClip(pos.x - 10, pos.y + 4 + i)) {
            counter++;
          }
        }
        pos.x ++;
      }
      vel.x = 0;
    }
  }

  int clipping() {
    return clipping(pos.x, pos.y);
  }//clipping

  int clipping(float x, float y) { //which side of the player hitbox is most clipped inside of a wall?
    int[] clips = new int[4]; //0 = top, 1 = bottom, 2 = left, 3 = right
    int max;

    for (int i = 0; i < 12; i++) {
      if (pixelClip(x - 6 + i, y)) { //top
        clips[0]++;
      }
    }
    for (int i = 0; i < 12; i++) {
      if (pixelClip(x - 6 + i, y + 40)) { //bottom
        clips[1]++;
      }
    }
    for (int i = 0; i < 32; i++) {
      if (pixelClip(x - 10, y + 4 + i)) { //left
        clips[2]++;
      }
    }
    for (int i = 0; i < 32; i++) {
      if (pixelClip(x + 10, y + + 4 + i)) { //right
        clips[3]++;
      }
    }

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

  boolean pixelClip(float x, float y) {
    return bounding.pixels[getIndex(bounding, x, y)] == #EC1C24 || (bounding.pixels[getIndex(bounding, x, y)] == #ffca18 && dropTimer > 28);
  }

  void updateAnimation(float secondsElapsed) {
    if (onWall) {
      sprite.changeAnimation("wallSlide");
    } else if (vel.y < -0.65) {
      sprite.changeAnimation("jump");
    } else if (vel.y > 0.13) {
      sprite.changeAnimation("fall");
    } else if (clipping() == -1) {
      sprite.changeAnimation("transition");
    } else if (keys['d'] || keys['a']) {
      if (keys['s']) {
        sprite.changeAnimation("crouchWalk");
      } else {
        sprite.changeAnimation("walk");
      }
    } else if (keys['s']) {
      sprite.changeAnimation("crouch");
    } else {
      sprite.changeAnimation("idle");
    }
    //println(sprite.currentAnimationName);
    sprite.updateAnimation(secondsElapsed);
  }//updateAnimation
}//Player
