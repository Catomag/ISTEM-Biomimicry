import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class MapDesigner extends PApplet {

ArrayList<Line> lines = new ArrayList<Line>();
ArrayList<Line> rewardGates = new ArrayList<Line>();
PVector start = new PVector(400, 400);
boolean startedLine = false;
boolean mouseReleased = false;
Line createdLine = new Line(new PVector(-1000,-1000), new PVector(-1000,-100));

float lineRad = 10;
float ctrlZCool = 0;
boolean zPressed = false;
boolean xPressed = false;

int current = 0;
Type type = Type.LINE;

int deleteNumb= 0;

//---------------------------------------------------------------------------------


public void setup() {
  
}


//---------------------------------------------------------------------------------


public void draw() {
  background(255);

  if(type == Type.START && mousePressed && mouseButton == LEFT) {
    start = new PVector(mouseX, mouseY);
  }


  else if(mousePressed && mouseButton == LEFT && !startedLine) {
    startedLine = true;

    float lineRad = 20;

    float lineX = mouseX;
    float lineY = mouseY;

    for(int i = 0; i < lines.size(); i++) {
      if(((lines.get(i).start.x > mouseX-lineRad && lines.get(i).start.x < mouseX+lineRad) && (lines.get(i).start.y > mouseY-lineRad && lines.get(i).start.y < mouseY+lineRad))) {
        lineX = lines.get(i).start.x;
        lineY = lines.get(i).start.y;
        break;
      }

      else if(((lines.get(i).end.x > mouseX-lineRad && lines.get(i).end.x < mouseX+lineRad) && (lines.get(i).end.y > mouseY-lineRad && lines.get(i).end.y < mouseY+lineRad))) {
        lineX = lines.get(i).end.x;
        lineY = lines.get(i).end.y;
        break;
      }
    }

    if(type == Type.REWARD) {
      for(int i = 0; i < rewardGates.size(); i++) {
        if(((rewardGates.get(i).start.x > mouseX-lineRad && rewardGates.get(i).start.x < mouseX+lineRad) && (rewardGates.get(i).start.y > mouseY-lineRad && rewardGates.get(i).start.y < mouseY+lineRad))) {
          lineX = rewardGates.get(i).start.x;
          lineY = rewardGates.get(i).start.y;
          break;
        }

        else if(((rewardGates.get(i).end.x > mouseX-lineRad && rewardGates.get(i).end.x < mouseX+lineRad) && (rewardGates.get(i).end.y > mouseY-lineRad && rewardGates.get(i).end.y < mouseY+lineRad))) {
          lineX = rewardGates.get(i).end.x;
          lineY = rewardGates.get(i).end.y;
          break;
        }
      }
    }

    createdLine.start.x = lineX;
    createdLine.start.y = lineY;
  }


  else if(mouseReleased && startedLine) {
    startedLine = false;
    float lineX = mouseX;
    float lineY = mouseY;

    for(int i = 0; i < lines.size(); i++) {
      if(((lines.get(i).start.x > mouseX-lineRad && lines.get(i).start.x < mouseX+lineRad) && (lines.get(i).start.y > mouseY-lineRad && lines.get(i).start.y < mouseY+lineRad))) {
        lineX = lines.get(i).start.x;
        lineY = lines.get(i).start.y;
        break;
      }

      else if(((lines.get(i).end.x > mouseX-lineRad && lines.get(i).end.x < mouseX+lineRad) && (lines.get(i).end.y > mouseY-lineRad && lines.get(i).end.y < mouseY+lineRad))) {
        lineX = lines.get(i).end.x;
        lineY = lines.get(i).end.y;
        break;
      }
    }

    if(type == Type.REWARD) {
      for(int i = 0; i < rewardGates.size(); i++) {
        if(((rewardGates.get(i).start.x > mouseX-lineRad && rewardGates.get(i).start.x < mouseX+lineRad) && (rewardGates.get(i).start.y > mouseY-lineRad && rewardGates.get(i).start.y < mouseY+lineRad))) {
          lineX = rewardGates.get(i).start.x;
          lineY = rewardGates.get(i).start.y;
          break;
        }

        else if(((rewardGates.get(i).end.x > mouseX-lineRad && rewardGates.get(i).end.x < mouseX+lineRad) && (rewardGates.get(i).end.y > mouseY-lineRad && rewardGates.get(i).end.y < mouseY+lineRad))) {
          lineX = rewardGates.get(i).end.x;
          lineY = rewardGates.get(i).end.y;
          break;
        }
      }
    }

    createdLine.end.x = lineX;
    createdLine.end.y = lineY;

    Line newLine = new Line(createdLine);

    if(type == Type.LINE) {
      lines.add(newLine);
    }

    else if(type == Type.REWARD) {
      rewardGates.add(newLine);
    }

    createdLine.start = new PVector(0,0);
    createdLine.end = new PVector(0,0);
  }

  noFill();
  stroke(100);

  if(startedLine) {
    createdLine.end.x = mouseX;
    createdLine.end.y = mouseY;
    createdLine.display();
  }

  if(zPressed && millis() > ctrlZCool) {
    ctrlZCool = millis() + 200;
    if(type == Type.LINE) {
      lines.remove(lines.size()-1);
    }

    else if(type == Type.REWARD) {
      rewardGates.remove(rewardGates.size()-1);
    }

  }

  for(int i = 0; i < lines.size(); i++) {
    stroke(0, 0, 0);
    lines.get(i).display();

    float lineX = -1000;
    float lineY = -1000;

    if(((lines.get(i).start.x > mouseX-lineRad && lines.get(i).start.x < mouseX+lineRad) && (lines.get(i).start.y > mouseY-lineRad && lines.get(i).start.y < mouseY+lineRad))) {
      lineX = lines.get(i).start.x;
      lineY = lines.get(i).start.y;
    }

    else if(((lines.get(i).end.x > mouseX-lineRad && lines.get(i).end.x < mouseX+lineRad) && (lines.get(i).end.y > mouseY-lineRad && lines.get(i).end.y < mouseY+lineRad))) {
      lineX = lines.get(i).end.x;
      lineY = lines.get(i).end.y;
    }

    stroke(255, 0, 0);
    noFill();
    ellipse(lineX, lineY, lineRad*2, lineRad*2);
  }

  for(int i = 0; i < rewardGates.size(); i++) {
    stroke(255, 255, 0);
    rewardGates.get(i).display();

    if(type == Type.REWARD) {
      float lineX = -1000;
      float lineY = -1000;

      if(((rewardGates.get(i).start.x > mouseX-lineRad && rewardGates.get(i).start.x < mouseX+lineRad) && (rewardGates.get(i).start.y > mouseY-lineRad && rewardGates.get(i).start.y < mouseY+lineRad))) {
        lineX = rewardGates.get(i).start.x;
        lineY = rewardGates.get(i).start.y;
      }

      else if(((rewardGates.get(i).end.x > mouseX-lineRad && rewardGates.get(i).end.x < mouseX+lineRad) && (rewardGates.get(i).end.y > mouseY-lineRad && rewardGates.get(i).end.y < mouseY+lineRad))) {
        lineX = rewardGates.get(i).end.x;
        lineY = rewardGates.get(i).end.y;
      }

      stroke(255, 0, 0);
      noFill();
      ellipse(lineX, lineY, lineRad*2, lineRad*2);
    }
  }

  boolean[] deleteLines = new boolean[lines.size()];

  if(keyPressed && (key == 'x' || key == 'X')) {
    for(int i = 0; i < lines.size(); i++) {
      deleteLines[i] = false;

      if(((lines.get(i).start.x > mouseX-lineRad && lines.get(i).start.x < mouseX+lineRad) && (lines.get(i).start.y > mouseY-lineRad && lines.get(i).start.y < mouseY+lineRad))) {
        deleteLines[i] = true;
        break;
      }

      else if(((lines.get(i).end.x > mouseX-lineRad && lines.get(i).end.x < mouseX+lineRad) && (lines.get(i).end.y > mouseY-lineRad && lines.get(i).end.y < mouseY+lineRad))) {
        deleteLines[i] = true;
        break;
      }
    }
  }

  for(int i = 0; i < deleteLines.length; i++) {
    if(deleteLines[i]) {
      lines.remove(i);
    }
  }

  noStroke();
  fill(0, 200, 0);
  ellipse(start.x, start.y, 10, 10);

  stroke(0);
  textSize(20);
  fill(0);
  if(type == Type.LINE) {
    text("Type: Line", 10, 760);
  }

  else if(type == Type.REWARD) {
    text("Type: Reward Line", 10, 760);
  }

  else if(type == Type.START) {
    text("Type: Start", 10, 760);
  }

  else if(type == Type.SET) {
    text("Type: Set", 10, 760);
  }
}



//---------------------------------------------------------------------------------


public void readFile(File selection) {
  String[] data = loadStrings(selection.getAbsolutePath());
  boolean doneLines = false;

  println("Width is: " + data[0]);

  lines = new ArrayList<Line>();
  rewardGates = new ArrayList<Line>();

  String[] startData = data[3].split(",");
  start = new PVector(PApplet.parseFloat(startData[0]), PApplet.parseFloat(startData[1]));

  for(int i = 0; i < PApplet.parseInt(data[1]); i++) {
    println(data[i+4]);
    String[] lineData = data[i+4].split(",");

    PVector start = new PVector(PApplet.parseFloat(lineData[0]), PApplet.parseFloat(lineData[1]));
    PVector end = new PVector(PApplet.parseFloat(lineData[2]), PApplet.parseFloat(lineData[3]));
    lines.add(new Line(start.copy(), end.copy()));
  }

  println("Lines size is: " + lines.size());

  for(int i = 0; i < PApplet.parseInt(data[2]); i++) {
    String[] lineData = data[i+lines.size()+4].split(",");

    PVector start = new PVector(PApplet.parseFloat(lineData[0]), PApplet.parseFloat(lineData[1]));
    PVector end = new PVector(PApplet.parseFloat(lineData[2]), PApplet.parseFloat(lineData[3]));
    rewardGates.add(new Line(start.copy(), end.copy()));
  }
}


//---------------------------------------------------------------------------------


public void writeFile(File selection) {
  String[] data = new String[4+lines.size()+rewardGates.size()];
  data[0] = str(width);
  data[1] = str(lines.size());
  data[2] = str(rewardGates.size());
  data[3] = start.x + "," + start.y;

  for(int i = 0; i < lines.size(); i++) {
    data[i+4] = lines.get(i).start.x + "," + lines.get(i).start.y + "," + lines.get(i).end.x + "," + lines.get(i).end.y;
  }

  for(int i = 0; i < lines.size(); i++) {
    data[i+4] = lines.get(i).start.x + "," + lines.get(i).start.y + "," + lines.get(i).end.x + "," + lines.get(i).end.y;
  }

  for(int i = 0; i < rewardGates.size(); i++) {
    data[i+4+lines.size()] = rewardGates.get(i).start.x + "," + rewardGates.get(i).start.y + "," + rewardGates.get(i).end.x + "," + rewardGates.get(i).end.y;
  }

  saveStrings(selection.getAbsolutePath(), data);
}


//---------------------------------------------------------------------------------


public void mouseReleased() {
 mouseReleased = true;
}


//---------------------------------------------------------------------------------


public void mousePressed() {
 mouseReleased = false;
}


//---------------------------------------------------------------------------------


public void keyPressed() {
  if(key == 'z' || key == 'Z') {
    zPressed = true;
  }

  if(key == 'x' || key == 'X') {
    xPressed = true;
  }

  if(key == 's' || key == 'S') {
    selectOutput("Save map as txt file", "writeFile");
  }

  if(key == 'o' || key == 'O') {
    selectInput("Load map txt file", "readFile");
  }
}


//---------------------------------------------------------------------------------


public void keyReleased() {
  if(key == 'z' || key == 'Z') {
    zPressed = false;
  }

  if(key == 'x' || key == 'X') {
    xPressed = false;
  }
}


//---------------------------------------------------------------------------------


public void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(e > 0) {
    current++;
    cycle();
  }

  else {
    current--;
    cycle();
  }
}


//---------------------------------------------------------------------------------


public void cycle() {
  if(current > 2) {
    current = 0;
  }
  else if(current < 0) {
   current = 2;
  }

  if(current == 0) {
    type = Type.LINE;
  }

  else if(current == 1) {
    type = Type.REWARD;
  }

  else if(current == 2) {
    type = Type.START;
  }
}
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


 public void display() {
   strokeWeight(2);
   line(start.x, start.y, end.x, end.y);
 }


//---------------------------------------------------------------------------------


  public PVector intersect(Line other) {

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


  public Line getLowestT(ArrayList<Line> lines) {

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
enum Type {
  LINE,
  REWARD,
  START,
  SET
}
  public void settings() {  size(800, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "MapDesigner" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
