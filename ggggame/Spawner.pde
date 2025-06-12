class Spawner {
  EnemyType enemyType;
  float spawnDelay;
  int spawnSide; //0 left, 1 right
  
  Spawner(EnemyType type, float delay, int side) {
     enemyType = type;
     spawnDelay = delay;
     spawnSide = side;
  }
}
