PImage bg;
ArrayList<Collider> boxes = new ArrayList<Collider>();
PVector pos = new PVector(100, 100);
PVector vel = new PVector(0, 0);
float gravity = 0.5;
boolean grounded = false;

PImage player;

void setup() {
  size(1280, 640);
  bg = loadImage("gamebg.png");
  bg.loadPixels();
  
  image(bg, 0, 0);
  
}

void draw() {
  
}

void keyPressed() {
    
}
