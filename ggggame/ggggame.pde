PImage bg;
ArrayList<Collider> boxes = new ArrayList<Collider>();
PVector pos = new PVector(100, 100);
PVector vel = new PVector(0, 0);
float gravity = 0.5;
boolean grounded = false;

boolean[] keys;

Sprite player;

void setup() {
  size(1280, 640);

  keys = new boolean[256];

  bg = loadImage("gamebg.png");
  bg.loadPixels();

  player = new Sprite();
  player.spritesheet = loadImage("FreeKnight_v1/Colour1/Outline/120x80_PNGSheets/_Run.png");
  player.position = new PVector(width / 2, height / 2);
  player.spriteFootOffset = 120;

  Animation walk = new Animation(
    0, 0, // topLeftX, topLeftY of the first frame
    120, 80, // frame width and height
    10, // number of frames
    0.1, // frame duration in seconds
    true               // should loop
    );

  player.animations.put("walk", walk);
  player.changeAnimation("walk");
}//setup

void draw() {
  imageMode(CORNER);
  image(bg, 0, 0, width, height); //full canvas bg

  float secondsElapsed = 1.0 / frameRate;
  player.updateAnimation(secondsElapsed);
  player.draw();

  processInputs();
}//draw

void keyPressed() {
  keys[key] = true;
}//keyPressed

void keyReleased() {
  keys[key] = false;
}//keyReleased

void processInputs() {
  if (keys['d']) {
    player.position.x += 5;
    player.facingLeft = false;
  }
  if (keys['a']) {
    player.position.x -= 5;
    player.facingLeft = true;
  }
  if (keys['w']) {
    player.position.y -= 5;
  }
  if (keys['s']) {
    player.position.y += 5;
  }
}//processInputs
