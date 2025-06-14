class Enemy {
  Sprite sprite;

  PVector pos;
  PVector vel;
  float health;
  
  void draw(float secondsElapsed) {
    sprite.updateAnimation(secondsElapsed);
    sprite.draw(pos.x, pos.y, 0);
  }

}
