PImage bounding, bg;
ArrayList<Collider> boxes = new ArrayList<Collider>();
PVector pos = new PVector(100, 100);
PVector vel = new PVector(0, 0);
float gravity = 0.16;
float friction = 0.08;

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
  //println(player.clipping() + " " + player.vel.x + " " + player.vel.y + " " + player.jumpTimer);
}//draw

void keyPressed() {
  if (key < 256) {
    keys[key] = true;
  }
}//keyPressed

void keyReleased() {
  if (key < 256) {
    keys[key] = false;
  }
}//keyReleased

void processInputs() {
  if (keys['d'] && !player.onWall && ((!keys['s'] && player.vel.x < 2.3) || player.vel.x < 1.3)) {
    if (keys['n']) {
      player.vel.y += 0.15;
    } else {
      player.vel.x += 0.15;
    }
    player.sprite.facingLeft = false;
  }
  if (keys['a'] && !player.onWall && ((!keys['s'] && player.vel.x > -2.3) || player.vel.x > -1.3)) {
    if (keys['n']) {
      player.vel.y -= 0.15;
    } else {
      player.vel.x -= 0.15;
    }
    player.sprite.facingLeft = true;
  }
  if (keys['w'] && player.jumpTimer <= 7) {//gives the player a very small frame to jump even after falling off a platform
    player.vel.y = -6.6;
    player.jumpTimer = 8;
  }
  if (keys['w'] && player.onWall) {//walljumps
    player.vel.y = -3.8;
    player.vel.x = (player.sprite.facingLeft) ? 1.8: -1.8;
    player.jumpTimer = 8;
    player.onWall = false;
    player.sprite.facingLeft = !player.sprite.facingLeft;
  }
  if (keys['s']) {
    player.vel.y += 0.12;
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

int getIndex(PImage img, float x, float y) {
  return img.width * int(y) + int(x);
}//getIndex
