class Line {
 PVector start;
 PVector end;
 float len = 0;
 float rot;
 float oRot = 0;
 boolean destroy = false;


//---------------------------------------------------------------------------------


 Line(PVector s, PVector e) {
   start = s;
   end = e;
   float cos = (start.y-end.y)/(start.x-end.x);
   len = dist(s.x,s.y,e.x,e.y);
 }


//---------------------------------------------------------------------------------


 Line(Line papa) {
   start = papa.start.copy();
   end = papa.end.copy();
   len = dist(start.x, start.y, end.x, end.y);
 }


//---------------------------------------------------------------------------------


 void display() {
   strokeWeight(2);
   line(start.x, start.y, end.x, end.y);
 }


//---------------------------------------------------------------------------------


  PVector intersect(Line other) {

    if(other == null) {
      return null;
    }

    //Line a
    float x1 = start.x;
    float x2 = end.x;
    float y1 = start.y;
    float y2 = end.y;

    //Line b
    /*float x3 = other.start.x;
    float x4 = other.start.x + cos(radians(other.angle))*other.len;
    float y3 = other.start.y;
    float y4 = other.start.y + sin(radians(other.angle))*other.len;*/

    float x3 = other.start.x;
    float x4 = other.end.x;
    float y3 = other.start.y;
    float y4 = other.end.y;

    float u1 = (x1-x2)*(y1-y3)-(y1-y2)*(x1-x3);
    float u2 = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);

    float u = -u1/u2;

    float t1 = (x1-x3)*(y3-y4)-(y1-y3)*(x3-x4);
    float t2 = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);

    float t = t1/t2;

    if((u < 0 || u > 1) || (t < 0 || t > 1)) {
      return null;
    }

    float x = x3+u*(x4-x3);
    float y = y3+u*(y4-y3);

    return new PVector(x, y);
  }


//---------------------------------------------------------------------------------


  Line getLowestT(ArrayList<Line> lines) {

    if(lines == null || lines.size() == 0) {
      return null;
    }

    float lowestT = 1000000000;
    int lowestI = 10000000;

    for(int i = 0; i < lines.size(); i++) {
      float x1 = start.x;
      float x2 = end.x;
      float y1 = start.y;
      float y2 = end.y;

      //Line b
      float x3 = lines.get(i).start.x;
      float x4 = lines.get(i).end.x;
      float y3 = lines.get(i).start.y;
      float y4 = lines.get(i).end.y;

      float t1 = (x1-x3)*(y3-y4)-(y1-y3)*(x3-x4);
      float t2 = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);

      float t = t1/t2;

      if(t < lowestT) {
        lowestT = t;
      }
    }

    if(lowestI < lines.size()) {
      return lines.get(lowestI);
    }

    else {
      return null;
    }
  }
}
