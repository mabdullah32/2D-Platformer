PImage bg;
ArrayList<Collider> boxes = new ArrayList<Collider>();
PVector pos = new PVector(100, 100);
PVector vel = new PVector(0, 0);
float gravity = 0.5;
boolean grounded = false;

Sprite player;

void setup() {
  size(1280, 640);
  
  bg = loadImage("gamebg.png");
  bg.loadPixels();

  player = new Sprite();
  player.spritesheet = loadImage("Zweihander_Combat/Spritesheet/Zweihander_Spritesheet_Player.png");
  player.position = new PVector(width / 2, height / 2);
  player.spriteFootOffset = 120; 

  Animation walk = new Animation(
    width/2, height/2,            // topLeftX, topLeftY of the first frame
    256, 256,          // frame width and height
    8,               // number of frames
    0.5,             // frame duration in seconds
    true             // should loop
  );

  player.animations.put("walk", walk);
  player.changeAnimation("walk");
}

void draw() {
  imageMode(CORNER);
  image(bg, 0, 0, width, height); //full canvas bg

  float secondsElapsed = 1.0 / frameRate;
  player.updateAnimation(secondsElapsed);
  player.draw();
}

void keyPressed() {
  if (key == 'd') {
    player.position.x += 5;
    player.facingLeft = false;
  } else if (key == 'a') {
    player.position.x -= 5;
    player.facingLeft = true;
  }
}
