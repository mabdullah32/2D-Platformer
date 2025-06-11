class Player {

  PVector pos;
  PVector vel;
  int jumpTimer;
  int dropTimer;
  boolean onWall;

  Sprite sprite;
  Sprite effect;

  int attackInProgress;
  int attackFrame;
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
    effect.position = new PVector(-777, -777);

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
      0, 80 * (9 - 1), // topLeftX, topLeftY of the first frame
      120, 80, // frame width and height
      3, // number of frames
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

    Animation att = new Animation(
      0, 80 * (1 - 1), // topLeftX, topLeftY of the first frame
      120, 80, // frame width and height
      4, // number of frames
      0.15, // frame duration in seconds
      true               // should loop
      );

    sprite.animations.put("att", att);

    Animation crouchAtt = new Animation(
      0, 80 * (8 - 1), // topLeftX, topLeftY of the first frame
      120, 80, // frame width and height
      4, // number of frames
      0.1, // frame duration in seconds
      true               // should loop
      );

    sprite.animations.put("crouchAtt", crouchAtt);

    Animation att2 = new Animation(
      0, 80 * (3 - 1), // topLeftX, topLeftY of the first frame
      120, 80, // frame width and height
      6, // number of frames
      0.2, // frame duration in seconds
      true               // should loop
      );

    sprite.animations.put("att2", att2);

    Animation roll = new Animation(
      0, 80 * (20 - 1), // topLeftX, topLeftY of the first frame
      120, 80, // frame width and height
      12, // number of frames
      0.1, // frame duration in seconds
      true               // should loop
      );

    sprite.animations.put("roll", roll);

    Animation shockwave = new Animation(
      256 * 4, 256 * 6, // topLeftX, topLeftY of the first frame
      256, 256, // frame width and height
      5, // number of frames
      0.1, // frame duration in seconds
      false               // should loop
      );

    effect.animations.put("shockwave", shockwave);

    sprite.changeAnimation("idle");
    effect.changeAnimation("shockwave");
  }//constructah

  void draw(float secondsElapsed) {
    updateAnimation(secondsElapsed);
    //rect(pos.x - 10, pos.y, 20, 40);
    sprite.updateAnimation(secondsElapsed);
    effect.updateAnimation(secondsElapsed);
    sprite.draw(pos.x, pos.y, 0);
    effect.draw(-PI/2);
  }//draw

  void updatePos() {

    PVector drag = new PVector(vel.x, vel.y);

    if (((keys['a'] && clipping(floor(pos.x + vel.x), pos.y) == 2) ||
      (keys['d'] && clipping(ceil(pos.x + vel.x), pos.y) == 3))
      && clipping() != 1 && bounding.pixels[getIndex(bounding, pos.x, pos.y)] != #00a8f3) {//blue, no-wallHang zones
      onWall = true;
    }

    if (onWall || (attackInProgress != 0 && attackInProgress != 3)) {
      vel.y = vel.x = 0;
    }

    drag.mult(vel.mag()/400);
    vel.sub(drag);
    pos.add(vel);
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
      while (sideClip(pos.x - 6, pos.y + 39, 12, 1) != 0) {
        pos.y --;
      }
    } else if (clipping() == 0) {
      vel.y = 0;
      while (sideClip(pos.x - 6, pos.y - 2, 12, 1) != 0) {
        pos.y ++;
      }
    } else if (clipping() == 3) {
      while (sideClip(pos.x + 10, pos.y + 4, 1, 32) != 0) {
        pos.x --;
      }
      vel.x = 0;
    } else if (clipping() == 2) {
      while (sideClip(pos.x - 10, pos.y + 4, 1, 32) != 0) {
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

  int sideClip(float x, float y, int w, int h) { //returns the amount of pixels in a specified rectangle (or line) that is clipped into a wall
    int count = 0;
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        if (pixelClip(x + i, y + j)) {
          count++;
        }
      }
    }
    return count;
  }//sideClip

  boolean pixelClip(float x, float y) {
    return bounding.pixels[getIndex(bounding, x, y)] == #EC1C24 || (bounding.pixels[getIndex(bounding, x, y)] == #ffca18 && dropTimer > 28);
  }

  void updateAnimation(float secondsElapsed) {

    if (attackInProgress == 1) {
      sprite.changeAnimation("att");
    } else if (attackInProgress == 2) {
      sprite.changeAnimation("att2");
    } else if (attackInProgress == 3) {
      sprite.changeAnimation("roll");
    } else if (attackInProgress == 4) {
      sprite.changeAnimation("crouchAtt");
    } else if (onWall) {
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
    if (attackFrame > 0) {
      attackFrame--;
    } else {
      attackInProgress = 0;
    }
    sprite.updateAnimation(secondsElapsed);
    println(sprite.secondsSinceAnimationStarted);
  }//updateAnimation
}//Player
