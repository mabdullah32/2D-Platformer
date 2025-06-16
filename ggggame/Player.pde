class Player {

  PVector pos;
  PVector vel;
  int jumpTimer;
  int dropTimer;
  boolean onWall;

  Sprite sprite;
  Sprite effect;
  float tint;

  int attackInProgress;
  int attackFrame;
  int[] resources;

  //combat vars
  ArrayList<Attack> activeAttacks;
  int comboCount;
  float comboTimer;
  float comboCooldown = 2.0;
  
  // attack hitboxes
  PVector attackHitbox1 = new PVector(30, 20); // light attack
  PVector attackHitbox2 = new PVector(40, 30); // heavy attack

  float maxHealth = 100;
  float health = 100;
  boolean invulnerable = false;
  float invulnerabilityTimer = 0;
  float invulnerabilityDuration = 1.0; // 1 sec invulnerable after taking damage

  Player(int x, int y) {
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    tint = 255;
    sprite = new Sprite();
    sprite.spritesheet = knightSprite;
    sprite.spriteFootOffset = 0;

    effect = new Sprite();
    effect.spritesheet = fx;
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
    
    activeAttacks = new ArrayList<Attack>();
    comboCount = 0;
    comboTimer = 0;
  }//constructah

  void draw(float secondsElapsed) {
    updatePos();
    updateHealth(secondsElapsed);
    updateAnimation(secondsElapsed);

    tint(255, tint, tint);
    sprite.draw(pos.x, pos.y, 0);
    noTint();
    effect.draw(-PI/2);
  }//draw


  void updateCombat(float secondsElapsed) {
     
    if (comboTimer > 0) {
       comboTimer -= secondsElapsed; 
       if(comboTimer <= 0) {
          comboCount = 0; 
       }
    }
    
    for(int i = activeAttacks.size() - 1; i >= 0; i--) {
        Attack attack = activeAttacks.get(i);
        attack.update(secondsElapsed);
        
        if(attack.isFinished()) {
          
          activeAttacks.remove(i);
          
          
        } else {
          //checkAttackCollisions(attack);
        }
    }
  }


  void updatePos() {

    PVector drag = new PVector(vel.x, vel.y);

    if (((keys['a'] && clipping(floor(pos.x + vel.x), pos.y, bounding) == 2) ||
      (keys['d'] && clipping(ceil(pos.x + vel.x), pos.y, bounding) == 3))
      && clipping() != 1 && bounding.pixels[getIndex(bounding, pos.x, pos.y)] != #00a8f3) {//blue, no-wallHang zones
      onWall = true;
    }

    if (onWall) {
      vel.y = vel.x = 0;
    }

    if (vel.mag() > 8) {
      tint = 240 - (vel.mag() - 8) * 50;
    } else if (tint < 255) {
      tint += 0.9;
    } else {
      tint = 255;
    }

    drag.mult(vel.mag()/400);
    vel.sub(drag);
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
    pos.add(vel);
    collisionCorrect();
    collisionCorrect(); //important that collisions are *double resolved*
  }//updatePos

  void collisionCorrect() {
    if (clipping() == 1) {
      if (vel.mag() > 8) {
        effect.secondsSinceAnimationStarted = 0;
        effect.position.x = pos.x;
        effect.position.y = pos.y;
        takeDamage((vel.mag() - 8) * 15);
      }
      while (sideClip(pos.x - 6, pos.y + 39, 12, 1) != 0) {
        pos.y --;
      }
      vel.y = 0;
    } else if (clipping() == 0) {
      while (sideClip(pos.x - 6, pos.y - 2, 12, 1) != 0) {
        pos.y ++;
      }
      vel.y = 0;
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
    return clipping(pos.x, pos.y, bounding);
  }//clipping

  int clipping(float x, float y, PImage map) { //which side of the player hitbox is most clipped inside of a wall?
    int[] clips = new int[4]; //0 = top, 1 = bottom, 2 = left, 3 = right
    int max;

    clips[0] = sideClip(x - 6, y, 12, 1, map);//top
    clips[1] = sideClip(x - 6, y + 40, 12, 1, map);//bottom
    clips[2] = sideClip(x - 10, y + 4, 1, 32, map);//left
    clips[3] = sideClip(x + 10, y + 4, 1, 32, map);//right

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

  int sideClip(float x, float y, int w, int h) {
    return sideClip(x, y, w, h, bounding);
  }//sideClip

  int sideClip(float x, float y, int w, int h, PImage map) { //returns the amount of pixels in a specified rectangle (or line) that is clipped into a wall
    int count = 0;
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        if (pixelClip(x + i, y + j, map)) {
          count++;
        }
      }
    }
    return count;
  }//sideClip

  boolean pixelClip(float x, float y, PImage map) {
    return map.pixels[getIndex(map, x, y)] == #EC1C24 || (map.pixels[getIndex(map, x, y)] == #ffca18 && dropTimer > 28);
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
    effect.updateAnimation(secondsElapsed);
  }//updateAnimation

  void drawHealthBar() {
    fill(255, 0, 0);
    rect(10, 10, 200, 20);
    fill(0, 255, 0);
    rect(10, 10, 200 * (health/maxHealth), 20);
    fill(255);
    textAlign(LEFT);
    fill(0);
    text("Health: " + int(health) + "/" + int(maxHealth), 15, 25);
  }

  void takeDamage(float damage) {
    if (!invulnerable) {
      health -= damage;
      invulnerable = true;
      invulnerabilityTimer = invulnerabilityDuration;

      if (health <= 0) {
        health = 0;

        println("Player died!");
      }
    }
  }

  void updateHealth(float secondsElapsed) {
    if (invulnerable) {
      invulnerabilityTimer -= secondsElapsed;
      if (invulnerabilityTimer <= 0) {
        invulnerable = false;
      }
    }
  }
}//Player
