class WaveManager {
  Wave[] m1Waves;
  Wave[] m2Waves;
  int currentWaveIndex;
  boolean wavesActive;
  float timeBetweenWaves = 5.0;
  float nextWaveTime;

  WaveManager() {
    setupWaves();
    currentWaveIndex = 0;
    wavesActive = false;
  }

  void setupWaves() {
    // Create progressively harder waves
    m1Waves = new Wave[10]; 

    for (int i = 0; i < m1Waves.length; i++) {
      m1Waves[i] = new Wave(i + 1);
      setupWaveEnemies(m1Waves[i], i + 1);
    }

    // Similar setup for map 2
    m2Waves = new Wave[8];
    for (int i = 0; i < m2Waves.length; i++) {
      m2Waves[i] = new Wave(i + 1);
      setupWaveEnemies(m2Waves[i], i + 1);
    }
  }

  void setupWaveEnemies(Wave wave, int waveNumber) {
    // difficulty ish? idk
    switch(waveNumber) {
    case 1:
      wave.addSpawnEvent(EnemyType.ANGEL, 0, 0);
      wave.addSpawnEvent(EnemyType.ANGEL, 2, 1);
      break;
    case 2:
      wave.addSpawnEvent(EnemyType.GHOUL, 0, 0);
      wave.addSpawnEvent(EnemyType.ANGEL, 1, 1);
      wave.addSpawnEvent(EnemyType.GHOUL, 2, 2);
      break;
    case 3:
      wave.addSpawnEvent(EnemyType.WIZARD, 0, 0);
      wave.addSpawnEvent(EnemyType.GHOUL, 1, 1);
      wave.addSpawnEvent(EnemyType.ANGEL, 1, 2);
      wave.addSpawnEvent(EnemyType.WIZARD, 2, 1);
      break;
      // Add more wave configs later ..
    }
  }

  Wave getCurrentWave() {
    if (currentMap == 1 && currentWaveIndex < m1Waves.length) {
      return m1Waves[currentWaveIndex];
    } else if (currentMap == 2 && currentWaveIndex < m2Waves.length) {
      return m2Waves[currentWaveIndex];
    }
    return null;
  }

  void startWaves() {
    m1Waves[0].start();
  }

  void update() {
    Wave currentWave = getCurrentWave();

    if (currentWave != null) {
      currentWave.update();

      // check if curr wave is complete, start next wave
      if (currentWave.isComplete && !wavesActive) {
        currentWaveIndex++;
        nextWaveTime = millis() / 1000.0 + timeBetweenWaves;
        wavesActive = true;
      }

      // start next wave after delay
      if (wavesActive && millis() / 1000.0 >= nextWaveTime) {
        Wave nextWave = getCurrentWave();
        if (nextWave != null) {
          nextWave.start();
          wavesActive = false;
        }
      }
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
