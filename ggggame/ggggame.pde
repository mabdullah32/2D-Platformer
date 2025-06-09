PImage bounding, bg;
ArrayList<Collider> boxes = new ArrayList<Collider>();
PVector pos = new PVector(100, 100);
PVector vel = new PVector(0, 0);
float gravity = 0.08;
float friction = 0.08;

boolean[] keys = new boolean[256];
;

Player player;

void setup() {
  size(1280, 640);

  bounding = loadImage("bounding.png");
  bg = loadImage("gamebg.png");
  bg.loadPixels();

  player = new Player(width/2, height/2);
}//setup

void draw() {
  imageMode(CORNER);
  image(bounding, 0, 0, width, height); //bounding boxes bg for debugging
  player.updatePos();
  image(bg, 0, 0, width, height); //full canvas bg

  float secondsElapsed = frameCount / frameRate;
  player.draw(secondsElapsed);
  println(player.clipping() + " " + player.vel.x + " " + player.vel.y + " " + player.jumpTimer);
  processInputs();
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
  if (keys['d'] && ((!keys['s'] && player.vel.x < 2.3) || player.vel.x < 1.3)) {
    player.vel.x += 0.15;
    player.sprite.facingLeft = false;
  }
  if (keys['a'] && ((!keys['s'] && player.vel.x > -2.3) || player.vel.x > -1.3)) {
    player.vel.x -= 0.15;
    player.sprite.facingLeft = true;
  }
  if (keys['w'] && player.jumpTimer <= 7) {//gives the player a very small frame to jump even after falling off a platform
    player.vel.y = -8;
    keys['w'] = false;
  }
  if (keys['s']) {
    player.vel.y += 0.2;
    if (player.clipping() == 1) {
      player.dropTimer = 0;
    }
  }
  if (keys['m']) {
    player.vel.y = 0;
  }
}//processInputs

int getIndex(PImage img, float x, float y) {
  return img.width * int(y) + int(x);
}//getIndex
