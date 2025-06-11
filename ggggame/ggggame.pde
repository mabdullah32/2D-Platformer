PImage bounding, bg;
float gravity = 0.16;
float friction = 0.2;

boolean[] keys = new boolean[256];

Player player;

void setup() {
  frameRate(50);
  size(1280, 640);

  bounding = loadImage("bounding.png");
  bg = loadImage("gamebg.png");
  bg.loadPixels();

  player = new Player(width/2, height/2);
}//setup

void draw() {
  imageMode(CORNER);
  image(bounding, 0, 0, width, height); //bounding boxes bg for debugging
  image(bg, 0, 0, width, height); //full canvas bg

  float secondsElapsed = 1.0 / frameRate;
  player.updatePos();
  processInputs();
  player.draw(secondsElapsed);
  println(player.clipping() + " " + player.vel.x + " " + player.vel.y + " " + player.jumpTimer);
}//draw

void keyPressed() {
  if (key < 256) {
    keys[key] = true;
  }
  if (key == '1') {
    reset(1);
  } else if (key == '2') {
    reset(2);
  }
}//keyPressed

void keyReleased() {
  if (key < 256) {
    keys[key] = false;
  }
}//keyReleased

void mouseWheel() {
  player.attackInProgress = 3;
  player.attackFrame = 28;
  if (keys['d']) {
        player.vel.x = 6.9;
      } else if (keys['a']) {
        player.vel.x = -6.9;
      }
}

void mousePressed() {
  if (player.attackInProgress == 0 && player.clipping() == 1) {
    if (mouseButton == LEFT) {
      if (!keys['s']) {
        player.attackInProgress = 1;
        player.attackFrame = 13;
      } else {
        player.attackInProgress = 4;
        player.attackFrame = 8;
      }
    } else if (mouseButton == RIGHT) {
      player.attackInProgress = 2;
      player.attackFrame = 28;
      keys['s'] = false;
    } else if (mouseButton == CENTER) {
      player.attackInProgress = 3;
      player.attackFrame = 28;
      if (player.vel.x > 0.1) {
        player.vel.x = 6.9;
      } else if (player.vel.x < -0.1) {
        player.vel.x = -6.9;
      }
    }
  }
}

void processInputs() {
  if (keys['d'] && !player.onWall && ((!keys['s'] && player.vel.x < 2.3) || player.vel.x < 1.3)) {
    if (keys['n']) {
      player.vel.y += 0.27;
    } else {
      if (player.clipping() == -1) {
        player.vel.x += 0.15;
      } else {
        player.vel.x += 0.27;
      }
    }
    player.sprite.facingLeft = false;
  }
  if (keys['a'] && !player.onWall && ((!keys['s'] && player.vel.x > -2.3) || player.vel.x > -1.3)) {
    if (keys['n']) {
      player.vel.y -= 0.27;
    } else {
      if (player.clipping() == -1) {
        player.vel.x -= 0.15;
      } else {
        player.vel.x -= 0.27;
      }
    }
    player.sprite.facingLeft = true;
  }
  if (keys['w']) {
    if (player.jumpTimer <= 7) {//gives the player a very small frame to jump even after falling off a platform
      player.vel.y = -6.6;
    } else if (player.onWall) {//walljumps
      player.vel.y = -3.8;
      player.vel.x = (player.sprite.facingLeft) ? 1.8: -1.8;
      player.onWall = false;
      player.sprite.facingLeft = !player.sprite.facingLeft;
    } else if (bounding.pixels[getIndex(bounding, player.pos.x, player.pos.y + 38)] == #ff7f27) {//orange, areas where the player can hop
      player.vel.y = -3.6;
    } 
    player.jumpTimer = 8;
  }
  if (keys['s']) {
    player.vel.y += 0.12;
    player.onWall = false;
    if (player.clipping() == 1) {
      player.dropTimer = 0;
    }
  }
  if (keys['m']) {
    player.vel.y = 0;
  }
  if (keys['n']) {
    player.vel.x = 0;
  }
  if (keys['b'] || keys['n']) {
    player.vel.y -= gravity;
  }
}//processInputs

void reset(int map) {
  if (map == 1) {
    if (player.clipping(player.pos.x, player.pos.y, loadImage("bounding.png")) == -1) {
      bounding = loadImage("bounding.png");
      bg = loadImage("gamebg.png");
      player.onWall = false;
    }
    //player = new Player(width/2, height/2);
  } else if (map == 2) {
    if (player.clipping(player.pos.x, player.pos.y, loadImage("bounding2.png")) == -1) {
      bounding = loadImage("bounding2.png");
      bg = loadImage("gamebg2.png");
      player.onWall = false;
    }
    //player = new Player(width/2 -50, height/2);
  }
}

int getIndex(PImage img, float x, float y) {
  return img.width * int(y) + int(x);
}//getIndex

//int sideClip(float x, float y, int w, int h) { //returns the amount of pixels in a specified rectangle (or line) that is clipped into a wall
//  int count = 0;
//  for (int i = 0; i < w; i++) {
//    for (int j = 0; j < h; j++) {
//      if (pixelClip(x + i, y + j)) {
//        count++;
//      }
//    }
//  }
//  return count;
//}//sideClip

//boolean pixelClip(float x, float y) {
//  return bounding.pixels[getIndex(bounding, x, y)] == #EC1C24 || bounding.pixels[getIndex(bounding, x, y)] == #ffca18;
//}
