class WaveManager {
  Wave[] m1Waves;
  Wave[] m2Waves;

  WaveManager() {
    m1Waves = new Wave[6];
    for (int i = 0; i < m1Waves.length; i++) { 
      m1Waves[i] = new Wave();
    }
    m1Waves[0].addSpawnEvent(EnemyType.ANGEL, 0, 0);
    m1Waves[0].addSpawnEvent(EnemyType.ANGEL, 0, 1);
    m1Waves[0].addSpawnEvent(EnemyType.ANGEL, 0, 2);
    m1Waves[0].addSpawnEvent(EnemyType.GHOUL, 3, 2);
    m1Waves[0].addSpawnEvent(EnemyType.GHOUL, 3, 1);
    m1Waves[0].addSpawnEvent(EnemyType.GHOUL, 3, 2);
    m1Waves[0].addSpawnEvent(EnemyType.WIZARD, 2, 0);
    m1Waves[0].addSpawnEvent(EnemyType.WIZARD, 2, 1);
    m1Waves[0].addSpawnEvent(EnemyType.WIZARD, 2, 2);
    m2Waves = new Wave[4];
    for (int i = 0; i < m2Waves.length; i++) { 
      m2Waves[i] = new Wave();
    }
  }

  void startWaves() {
    m1Waves[0].start();
  }

  void update() {
    for (int i = 0; i < m1Waves.length; i++) {
      m1Waves[i].update();
    }
  }

  void draw(float secondsElapsed) {
    if (currentMap == 1) {
      for (int i = 0; i < m1Waves.length; i++) {
        for (int j = 0; j < m1Waves[i].enemies.size(); j++) {
          m1Waves[i].enemies.get(j).draw(secondsElapsed);
        }
      }
    } else {
      for (int i = 0; i < m2Waves.length; i++) {
        for (int j = 0; j < m2Waves[i].enemies.size(); j++) {
          m2Waves[i].enemies.get(j).draw(secondsElapsed);
        }
      }
    }
  }
}
