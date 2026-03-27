class Enemy {
  Sprite sprite;

  PVector pos;
  PVector vel;
  float health;
  float maxHealth;
  EnemyType type;

  float aggroRange = 200;
  float attackRange = 50;
  float attackCooldown = 0;
  float attackDelay = 2.0;

  boolean isStunned = false;
  float stunTimer = 0;
  Collider hitbox;

  Enemy(EnemyType enemyType) {
    this.type = enemyType;
    this.pos = new PVector(0, 0);
    setupHitbox();
  }

  void setupHitbox() {
    switch(type) {
    case ANGEL:
      hitbox = new Collider(pos.x - 15, pos.y - 10, 30, 40);
      break;
    case GHOUL:
      hitbox = new Collider(pos.x - 10, pos.y - 5, 20, 30);
      break;
    case WIZARD:
      hitbox = new Collider(pos.x - 12, pos.y - 8, 24, 33);
      break;
    }
  }

  void draw(float secondsElapsed) {
    updateAI(secondsElapsed);
    updatePos();
    updateHitbox();
    drawHitbox();


    sprite.updateAnimation(secondsElapsed);
    sprite.draw(pos.x, pos.y, 0);
  }

  void updatePos() {


    if (clipping() != 1) { //in air
      vel.y += gravity;
    }
    pos.add(vel);
    collisionCorrect();
    collisionCorrect(); //important that collisions are *double resolved*
  }//updatePos

  void updateAI(float secondsElapsed) {
    if (isStunned) {
      stunTimer -= secondsElapsed;
      if (stunTimer <= 0) {
        isStunned = false;
      }
      return;
    }

    float distToPlayer = PVector.dist(pos, player.pos);

    // Update attack cooldown
    if (attackCooldown > 0) {
      attackCooldown -= secondsElapsed;
    }

    switch(type) {
    case ANGEL:
      updateAngelAI(distToPlayer, secondsElapsed);
      break;
    case GHOUL:
      updateGhoulAI(distToPlayer, secondsElapsed);
      break;
    case WIZARD:
      updateWizardAI(distToPlayer, secondsElapsed);
      break;
    }
  }

  void drawHitbox() {

    stroke(255, 0, 0);
    noFill();
    //for (Attack attack : activeAttacks) {
    //  rect(attack.hitbox.x, attack.hitbox.y, attack.hitbox.w, attack.hitbox.h);
    //}
    
    rect(hitbox.x, hitbox.y, hitbox.w, hitbox.h);
    noStroke();
  }

  void updateAngelAI(float distToPlayer, float secondsElapsed) {
    if (distToPlayer <= aggroRange) {
      // Fly towards player
      PVector direction = PVector.sub(player.pos, pos);
      direction.normalize();
      direction.mult(1.5);
      vel = direction;

      sprite.facingLeft = player.pos.x < pos.x;

      // Attack if close enough
      if (distToPlayer <= attackRange && attackCooldown <= 0) {
        performAttack();
        attackCooldown = attackDelay;
      }
    } else {
      vel.mult(0.9); // Slow down when not aggroed
    }
  }

  void updateGhoulAI(float distToPlayer, float secondsElapsed) {
    if (distToPlayer <= aggroRange) {
      // Run towards player
      if (player.pos.x < pos.x) {
        vel.x = -2.5;
        sprite.facingLeft = true;
      } else {
        vel.x = 2.5;
        sprite.facingLeft = false;
      }

      // Attack if close enough
      if (distToPlayer <= attackRange && attackCooldown <= 0) {
        performAttack();
        attackCooldown = attackDelay * 0.7; // bhouls attack faster
      }
    }
  }

  void updateWizardAI(float distToPlayer, float secondsElapsed) {
    if (distToPlayer <= aggroRange) {
      // keep distance and attack
      if (distToPlayer < attackRange * 1.5) {
        // back away
        if (player.pos.x < pos.x) {
          vel.x = 1;
          sprite.facingLeft = true;
        } else {
          vel.x = -1;
          sprite.facingLeft = false;
        }
      } else {
        vel.x *= 0.8; // slow down
      }

      // attack at range
      if (distToPlayer <= attackRange * 2 && attackCooldown <= 0) {
        performAttack();
        attackCooldown = attackDelay * 1.5; // wizards attack slower but at range
      }
    }
  }

  void performAttack() {
    if (sprite.animations.containsKey("attack")) {
      sprite.changeAnimation("attack");
    }

    // create damage area around enemy
    Collider attackHitbox = new Collider(pos.x - 25, pos.y - 15, 50, 30);

    // check if player in range
    Collider playerHitbox = new Collider(player.pos.x - 6, player.pos.y, 12, 40);
    if (attackHitbox.intersects(playerHitbox)) {
      float damage = 0;
      switch(type) {
      case ANGEL:
        damage = 8;
        break;
      case GHOUL:
        damage = 12;
        break;
      case WIZARD:
        damage = 6;
        break;
      }
      player.takeDamage(damage);
    }
  }

  void takeDamage(float damage, float knockback, PVector direction) {
    health -= damage;
    isStunned = true;
    stunTimer = 0.3;

    // knockback
    vel.add(PVector.mult(direction, knockback));

    if (health <= 0) {
      println("Enemy died lawl");
      sprite = null;
    }
  }

  void updateHitbox() {
    hitbox.x = pos.x - hitbox.w/2;
    hitbox.y = pos.y - hitbox.h/2;
  }

  Collider getHitbox() {
    return hitbox;
  }

  void drawHealthBar() {
    if (health < maxHealth) {
      float barWidth = 30;
      float barHeight = 4;
      float barY = pos.y - 20;

      fill(255, 0, 0);
      rect(pos.x - barWidth/2, barY, barWidth, barHeight);
      fill(0, 255, 0);
      rect(pos.x - barWidth/2, barY, barWidth * (health/maxHealth), barHeight);
    }
  }

  void collisionCorrect() {
    if (clipping() == 1) {
      vel.y = 0;
      while (sideClip(pos.x - 10, pos.y + 29, 20, 1) != 0) {
        pos.y --;
      }
    } else if (clipping() == 0) {
      vel.y = 0;
      while (sideClip(pos.x - 10, pos.y - 2, 20, 1) != 0) {
        pos.y ++;
      }
    } else if (clipping() == 3) {
      while (sideClip(pos.x + 10, pos.y, 1, 30) != 0) {
        pos.x --;
      }
      vel.y = -5;
    } else if (clipping() == 2) {
      while (sideClip(pos.x - 10, pos.y, 1, 30) != 0) {
        pos.x ++;
      }
      vel.y = -5;
    }
  }

  int clipping() { //which side of the player is most clipped inside of a wall?
    int[] clips = new int[4]; //0 = top, 1 = bottom, 2 = left, 3 = right
    int max;

    clips[0] = sideClip(pos.x - 10, pos.y, 20, 1);//top
    clips[1] = sideClip(pos.x - 10, pos.y + 30, 20, 1);//bottom
    clips[2] = sideClip(pos.x - 10, pos.y, 1, 30);//left
    clips[3] = sideClip(pos.x + 10, pos.y, 1, 30);//right

    max = max(clips);

    if (max == 0) {
      return -1;
    }
    if (max == clips[0]) {
      return 0;
    } else if (max == clips[1]) {
      return 1;
    } else if (max == clips[2]) {
      return 2;
    } else {
      return 3;
    }
  }
}
