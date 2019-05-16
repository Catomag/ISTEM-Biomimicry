class BoxCollider {
  Line[] edges;
  float rot;
  float wid;
  PVector pos;
  
//-------------------------------------------------------------------------------
  
  
  BoxCollider(float x, float y, float w) {
    edges = new Line[4];
    //line[0] = new Line();
  }
  

//-------------------------------------------------------------------------------
  
  
  BoxCollider(PVector p, float w) {
    edges = new Line[4];
    pos = p;
    wid = w;
    
    edges[0] = new Line(new PVector(pos.x, pos.y), new PVector(pos.x+w, pos.y));
    edges[1] = new Line(new PVector(pos.x+w, pos.y), new PVector(pos.x, pos.y+w));
    edges[2] = new Line(new PVector(pos.x, pos.y), new PVector(pos.x, pos.y+w));
    edges[3] = new Line(new PVector(pos.x, pos.y+w), new PVector(pos.x+w, pos.y));
  }
  
  
//-------------------------------------------------------------------------------


  boolean isColliding(Line other) {
     for(int i = 0; i < edges.length; i++) {
       if(edges[i].isIntersecting(other)) {
         return true;
       }
     }
     
     return false;
  }
  
  
//-------------------------------------------------------------------------------


  boolean isColliding(Line[] others) {
     for(int i = 0; i < edges.length; i++) {
       for(int j = 0; j < others.length; j++) {
         if(edges[i].isIntersecting(others[j])) {
           return true;
         }
       }
     }
     return false;
  }
  
  
//-------------------------------------------------------------------------------


  boolean isColliding(ArrayList<Line> others) {
    if(others.size() == 0) {
       return false;
    }
    
     for(int i = 0; i < edges.length; i++) {
       for(int j = 0; j < others.size(); j++) {
         if(edges[i].isIntersecting(others.get(j))) {
           return true;
         }
       }
     }
     return false;
  }
  

//-------------------------------------------------------------------------------


  int isCollidingIndex(ArrayList<Line> others) {
    if(others.size() == 0) {
       return -1;
    }
    
     for(int i = 0; i < edges.length; i++) {
       for(int j = 0; j < others.size(); j++) {
         if(edges[i].isIntersecting(others.get(j))) {
           return j;
         }
       }
     }
     return -1;
  }


//-------------------------------------------------------------------------------


  void display() {
    for(int i = 0; i < edges.length; i++) {
      stroke(0);
      edges[i].display();
    }
  }


//-------------------------------------------------------------------------------


  void update() {
    edges[0] = new Line(new PVector(pos.x, pos.y), new PVector(pos.x+wid, pos.y));
    edges[1] = new Line(new PVector(pos.x, pos.y), new PVector(pos.x, pos.y+wid));
    edges[2] = new Line(new PVector(pos.x, pos.y+wid), new PVector(pos.x+wid, pos.y+wid));
    edges[3] = new Line(new PVector(pos.x+wid, pos.y+wid), new PVector(pos.x+wid, pos.y));
  }
  
}
