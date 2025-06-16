class Wave {
  ArrayList<Spawner> spawnEvents;
  ArrayList<Enemy> enemies;
  int currentEventIndex;
  float waveStartTime;
  float nextWaveStartTime;
  boolean isActive;
  boolean isComplete;
  
  int waveNumber;
  float difficultyMultiplier;
  int enemiesRemaining;

  Wave(int waveNum) {
    spawnEvents = new ArrayList<Spawner>();
    enemies = new ArrayList<Enemy>();
    currentEventIndex = 0;
    isActive = false;
    isComplete = false;
    waveNumber = waveNum;
    difficultyMultiplier = 1.0 + (waveNum - 1) * 0.3;
  }

  void addSpawnEvent(EnemyType type, float delay, int spawnSide) {
    spawnEvents.add(new Spawner(type, delay, spawnSide, currentMap));
  }

  void start() {
    isActive = true;
    waveStartTime = millis() / 1000.0;
    currentEventIndex = 0;
    nextWaveStartTime += spawnEvents.get(0).spawnDelay;
  }

  void update() {
    if (!isActive || isComplete) return;

    float currentTime = millis() / 1000.0;
    float elapsedTime = currentTime - waveStartTime;

    // check if next enemy should be spawned
    while (currentEventIndex < spawnEvents.size()) {
      Spawner event = spawnEvents.get(currentEventIndex);

      if (elapsedTime >= nextWaveStartTime) {
        spawnEnemy(event.enemyType, event.spawnSide, event.gameMap);
        currentEventIndex++;
        if (currentEventIndex < spawnEvents.size()) {
          nextWaveStartTime += spawnEvents.get(currentEventIndex).spawnDelay;
        }
      } else {
        break;
      }
    }

    // check if wave complete
    if (currentEventIndex >= spawnEvents.size()) {
      isComplete = true;
      isActive = false;
    }
  }

  void spawnEnemy(EnemyType type, int side, int map) {
    float spawnX, spawnY;

    if (type == EnemyType.ANGEL && map == 1 && side == 0) {
      spawnX = 30;
      spawnY = 295;
    } else if (type == EnemyType.ANGEL && map == 1 && side == 1) {
      spawnX = 1250;
      spawnY = 190;
    } else if (type == EnemyType.ANGEL && map == 1 && side == 2) {
      spawnX = 1250;
      spawnY = 500;
    } else if (type == EnemyType.ANGEL && map == 2 && side == 0) {
      spawnX = 30;
      spawnY = 490;
    } else if (type == EnemyType.ANGEL && map == 2 && side == 1) {
      spawnX = 1250;
      spawnY = 105;
    } else if (map == 1 && side == 0) {
      spawnX = 30;
      spawnY = 315;
    } else if (map == 1 && side == 1) {
      spawnX = 1250;
      spawnY = 210;
    } else if (map == 1 && side == 2) {
      spawnX = 1250;
      spawnY = 520;
    } else if (map == 2 && side == 0) {
      spawnX = 30;
      spawnY = 510;
    } else if (map == 2 && side == 1) {
      spawnX = 1250;
      spawnY = 125;
    } else {
      spawnX = 0;
      spawnY = 0;
    }

    Enemy newEnemy = createEnemy(type, spawnX, spawnY);
    enemies.add(newEnemy);
  }



  Enemy createEnemy(EnemyType type, float x, float y) {
    Enemy enemy = new Enemy();
    enemy.pos = new PVector(x, y);
    enemy.vel = new PVector(0, 0);
    enemy.sprite = new Sprite();

    switch(type) {
    case ANGEL:
      setupAngelEnemy(enemy);
      break;
    case GHOUL:
      setupGhoulEnemy(enemy);
      break;
    case WIZARD:
      setupWizardEnemy(enemy);
      break;
    }

    return enemy;
  }

  void setupAngelEnemy(Enemy enemy) {
    enemy.health = 100;
    enemy.sprite.spritesheet = angelSprite;

    // flying
    Animation flying = new Animation(
      0, 0, // topLeftX, topLeftY
      122, 117, // frame width and height
      9, // number of frames
      0.1, // frame duration in seconds
      true            // should loop
      );
    enemy.sprite.animations.put("flying", flying);

    // idle
    Animation idle = new Animation(
      0, 117, // topLeftX, topLeftY
      122, 117, // frame width and height
      3, // number of frames
      0.3, // frame duration in seconds
      true            // should loop
      );
    enemy.sprite.animations.put("idle", idle);

    enemy.sprite.changeAnimation("flying");
  }

  void setupGhoulEnemy(Enemy enemy) {
    enemy.health = 80;
    enemy.vel.x = -2;
    enemy.sprite.spritesheet = ghoulSprite;

    // running
    Animation running = new Animation(
      0, 0, // topLeftX, topLeftY
      57, 60, // frame width and height
      16, // number of frames
      0.08, // frame duration in seconds
      true            // should loop
      );
    enemy.sprite.animations.put("running", running);

    enemy.sprite.changeAnimation("running");
  }

  void setupWizardEnemy(Enemy enemy) {
    enemy.health = 60;
    enemy.sprite.spritesheet = wizardSprite;

    // walking
    Animation walking = new Animation(
      0, 0, // topLeftX, topLeftY
      81, 66, // frame width and height 
      6, // number of frames
      0.3, // frame duration in seconds
      true            // should loop
      );
    enemy.sprite.animations.put("walking", walking);
    
    Animation attack = new Animation(
      81 * 6, 0, // topLeftX, topLeftY of the first frame
      81, 66, // frame width and height
      9, // number of frames
      0.3, // frame duration in seconds
      true               // should loop
      );

    enemy.sprite.animations.put("attack", attack);

    enemy.sprite.changeAnimation("walking");
  }
}
