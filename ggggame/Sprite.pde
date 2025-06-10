public class Sprite {
  
  PImage spritesheet;
  boolean facingLeft = false;
  int spriteFootOffset;
  
  PVector position;
  
  HashMap<String, Animation> animations = new HashMap<String, Animation>();
  String currentAnimationName;
  Animation currentAnimation;
  float secondsSinceAnimationStarted = 0;
  
  void changeAnimation(String animName) {
    currentAnimationName = animName;
    currentAnimation = animations.get(animName);
    secondsSinceAnimationStarted = 0;
  }
  
  void updateAnimation(float secondsElapsed) {
    secondsSinceAnimationStarted += secondsElapsed;
  }
  
  boolean isAnimationComplete() {
    return secondsSinceAnimationStarted >= currentAnimation.numFrames * currentAnimation.frameDurationSeconds;
  }
  
  void draw(float theta) {
    draw(position.x, position.y, theta);
  }
  
  void draw(float x, float y, float theta) {
    int currentFrameIndex = (int)(secondsSinceAnimationStarted / currentAnimation.frameDurationSeconds);
    if (currentAnimation.looping) {
      currentFrameIndex = currentFrameIndex % currentAnimation.numFrames;
    }
    else if (currentFrameIndex >= currentAnimation.numFrames) {
      currentFrameIndex = currentAnimation.numFrames;
    }
    
    //println(currentFrameIndex);
    drawAnimationFrame(currentAnimation, currentFrameIndex, x, y, theta);
  }
  
  void drawAnimationFrame(Animation animation, int frameIndex, float x, float y, float theta) {
    imageMode(CENTER);
    pushMatrix();
    translate(x, y - spriteFootOffset);
    rotate(theta);
    if (facingLeft) {
      scale(-1, 1);
    }

    int frameStartX = animation.topLeftX + animation.frameWidth*frameIndex;
    
    //rect(-animation.frameWidth/2,-animation.frameHeight/2,animation.frameWidth, animation.frameHeight);
    tint(255);
    image(
        spritesheet,
        0, 0,                                                                           // Position
        animation.frameWidth, animation.frameHeight,                                    // Target size
        frameStartX, animation.topLeftY,                                                // Source top-left
        frameStartX + animation.frameWidth, animation.topLeftY + animation.frameHeight  // Source size  
    );
 
    popMatrix();
  }
}
