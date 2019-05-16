class Line {
  PVector start;
  PVector end;
  float len = 0;
  SharedFloat rot;
  float oRot = 0;
  float intersectDist;


  //---------------------------------------------------------------------------------


  Line(PVector s, PVector e) {
    start = s;
    end = e;
  }

  Line(PVector s, float l, float r) {
    start = s;
    oRot = r;
    rot = new SharedFloat();
    rot.set(0);
    len = l;
    end = new PVector(cos(radians(rot.get()))*len, sin(radians(rot.get()))*len);
  }

  Line(PVector s, float l, float r, SharedFloat ro) {
    start = s;
    oRot = r;
    rot = ro;
    len = l;
    end = new PVector(cos(radians(rot.get()))*len, sin(radians(rot.get()))*len);
  }


  //---------------------------------------------------------------------------------


  Line(Line papa) {
    start = papa.start.copy();
    end = papa.end.copy();
    len = dist(start.x, start.y, end.x, end.y);
  }


  //---------------------------------------------------------------------------------


  void update() {
    end = new PVector(start.x+cos(radians(rot.get()+oRot))*len, start.y+sin(radians(rot.get()+oRot))*len);
  }


  //---------------------------------------------------------------------------------


  void display() {
    line(start.x, start.y, end.x, end.y);
  }


  //---------------------------------------------------------------------------------


  PVector intersect(Line other) {

    if (other == null) {
      return null;
    }

    //Line a
    float x1 = start.x;
    float x2 = end.x;
    float y1 = start.y;
    float y2 = end.y;

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

    if ((u < 0 || u > 1) || (t < 0 || t > 1)) {
      return null;
    }

    float x = x3+u*(x4-x3);
    float y = y3+u*(y4-y3);

    return new PVector(x, y);
  }


//---------------------------------------------------------------------------------


  float getLowestIntersects(ArrayList<Line> others) {
    float lowest = 1;

    for (int i = 0; i < others.size(); i++) {
      float x1 = start.x;
      float x2 = end.x;
      float y1 = start.y;
      float y2 = end.y;

      float x3 = others.get(i).start.x;
      float x4 = others.get(i).end.x;
      float y3 = others.get(i).start.y;
      float y4 = others.get(i).end.y;

      float u1 = (x1-x2)*(y1-y3)-(y1-y2)*(x1-x3);
      float u2 = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);

      float u = -u1/u2;

      float t1 = (x1-x3)*(y3-y4)-(y1-y3)*(x3-x4);
      float t2 = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);

      float t = t1/t2;

      float x = x3+u*(x4-x3);
      float y = y3+u*(y4-y3);

      float dist = dist(start.x, start.x, x, y);

      if (dist < lowest) {
        lowest = dist;
      }
    }

    println(lowest);
    return lowest;
  }


  //---------------------------------------------------------------------------------


  boolean isIntersecting(Line other) {

    if (other == null) {
      println("Other is null");
      return false;
    }

    //Line a
    float x1 = start.x;
    float x2 = end.x;
    float y1 = start.y;
    float y2 = end.y;

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

    if ((u < 0 || u > 1) || (t < 0 || t > 1)) {
      return false;
    }

    float x = x3+u*(x4-x3);
    float y = y3+u*(y4-y3);

    return true;
  }



  //---------------------------------------------------------------------------------


  Line getLowestTLine(ArrayList<Line> lines) {

    if (lines == null || lines.size() == 0) {
      return null;
    }

    float lowestT = 1000000000;
    int lowestI = 10000000;

    for (int i = 0; i < lines.size(); i++) {
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

      if (t < lowestT) {
        lowestT = t;
      }
    }

    if (lowestI < lines.size()) {
      return lines.get(lowestI);
    }

    else {
      return null;
    }
  }


//---------------------------------------------------------------------------------


  float getLowestT(ArrayList<Line> lines) {
    update();

    if (lines == null || lines.size() == 0) {
      return 0;
    }

    float lowestT = 1000000000;

    for (int i = 0; i < lines.size(); i++) {
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

      float u1 = (x1-x2)*(y1-y3)-(y1-y2)*(x1-x3);
      float u2 = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);

      float u = -u1/u2;

      if (t < lowestT && (t > 0 && t < 1) && (u > 0 && u < 1)) {
        lowestT = t;
      }
    }

    if (lowestT > 0 && lowestT < 1) {
      return lowestT;
    }

    else {
      return 1;
    }
  }


//---------------------------------------------------------------------------------


  float getLowestU(ArrayList<Line> lines) {
    update();

    if (lines == null || lines.size() == 0) {
      return 0;
    }

    float lowestU = 1000000000;

    for (int i = 0; i < lines.size(); i++) {
      float x1 = start.x;
      float x2 = end.x;
      float y1 = start.y;
      float y2 = end.y;

      //Line b
      float x3 = lines.get(i).start.x;
      float x4 = lines.get(i).end.x;
      float y3 = lines.get(i).start.y;
      float y4 = lines.get(i).end.y;

      float u1 = (x1-x2)*(y1-y3)-(y1-y2)*(x1-x3);
      float u2 = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);

      float u = -u1/u2;

      if (u < lowestU && u > 0 && u < 1) {
        lowestU = i;
      }
    }

    if (lowestU > 0 && lowestU < 1) {
      return lowestU;
    }

    else {
      return 1;
    }
  }
}
