class Blob {
  private PApplet parent;
  
  // Contour
  public Contour contour;
  
  // Am I available to be matched?
  public boolean available;
  
  // Should I be deleted?
  public boolean delete;
  
  // How long should I live if I have disappeared?
  private int initTimer = 5; //127;
  public int timer;
  
  // Unique ID for each blob
  int id;
  
  // Make me
  Blob(PApplet parent, int id, Contour c) {
    this.parent = parent;
    this.id = id;
    this.contour = new Contour(parent, c.pointMat);
    
    available = true;
    delete = false;
    
    timer = initTimer;
  }
  
  // Show me
  void display() {
    Rectangle r = contour.getBoundingBox();
    
    float opacity = map(timer, 0, initTimer, 0, 127);
    fill(0,0,255,opacity);
    stroke(0,0,255);
    float x = r.x;
    float y = r.y;
    rect(x, y, r.width, r.height);
    fill(255,2*opacity);
    textSize(26);
    text(""+id, x+10, y+30);
  }

  void update(Contour newC) {
    contour = new Contour(parent, newC.pointMat);
    timer = initTimer;
  }
  
  void countDown() {    
    timer--;
  }

  boolean dead() {
    if (timer < 0) return true;
    return false;
  }
  
  public Rectangle getBoundingBox() {
    return contour.getBoundingBox();
  }
}