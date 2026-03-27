class Spawner {
  EnemyType enemyType;
  float spawnDelay;
  int spawnSide; //0 left, 1 right top, 2 right bottom for map 1, 0 left, 1 right for map 2
  /*
  * map 1 left - coordinates are (0, 210) to (0, 380)
  * map 1 top right - coordinates are (1280, 85) to (1280, 275)
  * map 1 bottom right - coordinates are (1280, 450) to (1280, 550)
  * map 2 left - (0, 390) to (0, 595)
  * map 2 right - (1280, 45) to (1280, 170)
  */
  int gameMap; //1 for map 1, 2 for map 2
  
  Spawner(EnemyType type, float delay, int side, int map) {
     enemyType = type;
     spawnDelay = delay;
     spawnSide = side;
     gameMap = map;
  }
}
