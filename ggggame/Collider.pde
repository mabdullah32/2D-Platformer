class Collider {
  float x, y, w, h;

  Collider(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  boolean intersects (Collider other) {
    return x < other.x + other.w &&
      x + w > other.x &&
      y < other.y + other.h &&
      y + h > other.y;
  }
}
