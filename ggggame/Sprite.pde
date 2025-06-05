public class Sprite {
  
  PImage spritesheet;
  boolean facingLeft = false;
  int spriteFootOffset;
  
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
  
  void draw(float x, float y) {
    int currentFrameIndex = (int)(secondsSinceAnimationStarted / currentAnimation.frameDurationSeconds);
    if (currentAnimation.looping) {
      currentFrameIndex = currentFrameIndex % currentAnimation.numFrames;
    }
    else if (currentFrameIndex >= currentAnimation.numFrames) {
      currentFrameIndex = currentAnimation.numFrames - 1;
    }
    
    drawAnimationFrame(currentAnimation, currentFrameIndex, x, y);
  }
  
  void drawAnimationFrame(Animation animation, int frameIndex, float x, float y) {
    imageMode(CENTER);
    pushMatrix();
    translate(x, y - spriteFootOffset);
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
