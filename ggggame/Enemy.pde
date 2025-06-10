//class Enemy {
//  Sprite sprite;

//  PVector pos;
//  PVector vel;
//  float health;

//  sprite = new Sprite();
//  sprite.spritesheet = loadImage("gothSprites/angel/spritesheet/angel.png");
//  sprite.spritesheet = loadImage("gothSprites/burning-ghoul/spritesheet/v2/burning-ghoul.png");
//  sprite.spritesheet = loadImage("gothSprites/wizard/spritesheet/wizard.png");

//  //angel


//  //ghoul
//  Animation walk = new Animation(
//    0, 0, // topLeftX, topLeftY of the first frame
//    57, 60, // frame width and height
//    16, // number of frames
//    0.1, // frame duration in seconds
//    true               // should loop
//    );

//  sprite.animations.put("walk", walk);

//  //wizard
//  Animation idle = new Animation(
//    0, 0, // topLeftX, topLeftY of the first frame
//    81, 66, // frame width and height
//    6, // number of frames
//    0.3, // frame duration in seconds
//    true               // should loop
//    );

//  sprite.animations.put("idle", idle);

//  Animation attack = new Animation(
//    81 * 6, 0, // topLeftX, topLeftY of the first frame
//    81, 66, // frame width and height
//    9, // number of frames
//    0.3, // frame duration in seconds
//    true               // should loop
//    );

//  sprite.animations.put("attack", attack);
//}
