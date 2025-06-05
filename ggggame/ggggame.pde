PImage bg;
ArrayList<Collider> boxes = new ArrayList<Collider>();
PVector pos = new PVector(100, 100);
PVector vel = new PVector(0, 0);
float gravity = 0.5;
boolean grounded = false;

boolean[] keys = new boolean[256];;

Player player;

void setup() {
  size(1280, 640);

  bg = loadImage("gamebg.png");
  bg.loadPixels();

  player = new Player(width/2, height/2);
}//setup

void draw() {
  imageMode(CORNER);
  image(bg, 0, 0, width, height); //full canvas bg

  float secondsElapsed = 1.0 / frameRate;
  player.draw(secondsElapsed);

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
  if (keys['d'] && player.vel.x < 2.3) {
    player.vel.x += 0.1;
    player.sprite.facingLeft = false;
  }
  if (keys['a'] && player.vel.x > -2.3) {
    player.vel.x -= 0.1;
    player.sprite.facingLeft = true;
  }
  if (keys['w']) {
    player.vel.y = -4;
    keys['w'] = false;
  }
  if (keys['s']) {
    player.vel.y += 0.1;
  }
  if (keys['m']) {
    player.vel.y = 0;
  }
}//processInputs
