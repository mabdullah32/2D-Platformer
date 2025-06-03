class Collider {
  int x, y, w, h;
  
  Collider(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void display() {
    noFill();
    rect(x, y, w, h);
  }
  
}
