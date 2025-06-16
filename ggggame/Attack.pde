class Attack {
  Collider hitbox;
  float damage;
  float knockback;
  PVector direction;
  float duration;
  float timeAlive;
  boolean hasHit;
  int attackType;

  Attack(int type, float playerX, float playerY, boolean facingLeft) {
    this.attackType = type;
    this.timeAlive = 0;
    this.hasHit = false;

    // attack properties based on type
    switch(type) {
    case 1: // light
      damage = 15;
      knockback = 2;
      duration = 0.3;
      hitbox = new Collider(
        facingLeft ? playerX - 30 : playerX + 10,
        playerY + 10,
        30, 20
        );
      break;

    case 2: // heavy
      damage = 30;
      knockback = 5;
      duration = 0.6;
      hitbox = new Collider(
        facingLeft ? playerX - 40 : playerX + 10,
        playerY + 5,
        40, 30
        );
      break;

    case 3: // roll
      damage = 20;
      knockback = 3;
      duration = 0.5;
      hitbox = new Collider(
        facingLeft ? playerX - 25 : playerX + 10,
        playerY + 15,
        25, 25
        );
      break;

    case 4: // crouch
      damage = 12;
      knockback = 1;
      duration = 0.2;
      hitbox = new Collider(
        facingLeft ? playerX - 35 : playerX + 10,
        playerY + 25,
        35, 15
        );
      break;
    }

    direction = new PVector(facingLeft ? -1 : 1, 0);
  }

  void update(float secondsElapsed) {
    timeAlive += secondsElapsed;
  }

  boolean isFinished() {
    return timeAlive >= duration;
  }
}
