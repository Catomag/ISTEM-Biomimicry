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

public class ISTEM_biomimicry extends PApplet {

enum State {
  MENU,
  STARTSIMULATION,
  SIMULATING,
}

Population pop;
State state = State.MENU;

Button startButton = new Button(new PVector(0, 700), 200, 100);

static float _scale = 1;

static ArrayList<Line> _lines = new ArrayList<Line>();
static ArrayList<Line> _rewardLines = new ArrayList<Line>();

static PVector _startPos = new PVector(400, 400);
static XML _xml;
NumberField mutationField;

NeuralNetwork net = new NeuralNetwork(new int[] { 1, 2, 1 });;

//---------------------------------------------------------------------------------


public void setup() {
  

  //randomSeed(1);

  _xml = new XML("Training_Data");

  _scale = width/800;
  selectInput("Load map txt file", "readFile");
  pop = new Population(500);
  mutationField = new NumberField(new PVector(0, 400), 100f, 1f, 0f, .01f, .01f);

  startButton.text = "Start";
  startButton.normal = 0xff5773F7;
  startButton.highlighted = 0xff2444DE;
  startButton.pressedColor = 0xff2F0D90;
  startButton.outline = false;
}


//---------------------------------------------------------------------------------


public void draw() {
  background(255);
  mutationField.update();

  /*net.display();
  if(keyPressed && (key=='x' || key=='X')) {
    net.mutate(mutationField.value);
  }*/

  switch(state) {
    case MENU:
      displayMenu();
      displayLines();
    break;

    case SIMULATING:
      displayLines();
      pop.mutationRate = mutationField.value;
      if(keyPressed && key == 'x') {
        pop.update();
      }

      else {
        pop.update(5);
      }

    break;
  }

  //mutationField.display();
}


//---------------------------------------------------------------------------------


public void displayMenu() {
  startButton.update();
  startButton.display();

  if(startButton.pressed) {
    state = State.SIMULATING;
  }
}


//---------------------------------------------------------------------------------


public void displayLines() {
  stroke(240, 30, 10);
  for(int i = 0; i < _lines.size(); i++) {
    _lines.get(i).display();
  }

  stroke(247, 216, 54);
  for(int i = 0; i < _rewardLines.size(); i++) {
    _rewardLines.get(i).display();
  }
}


//---------------------------------------------------------------------------------


public void readFile(File selection) {
  String[] data = loadStrings(selection.getAbsolutePath());

  float scale = width/PApplet.parseFloat(data[0]);

  _lines = new ArrayList<Line>();
  _rewardLines = new ArrayList<Line>();

  String[] startData = data[3].split(",");
  _startPos = new PVector(PApplet.parseFloat(startData[0])*scale, PApplet.parseFloat(startData[1])*scale);

  for(int i = 0; i < PApplet.parseInt(data[1]); i++) {
    String[] lineData = data[i+4].split(",");

    PVector start = new PVector(PApplet.parseFloat(lineData[0])*scale, PApplet.parseFloat(lineData[1])*scale);
    PVector end = new PVector(PApplet.parseFloat(lineData[2])*scale, PApplet.parseFloat(lineData[3])*scale);
    _lines.add(new Line(start.copy(), end.copy()));
  }

  for(int i = 0; i < PApplet.parseInt(data[2]); i++) {
    String[] lineData = data[i+_lines.size()+4].split(",");

    PVector start = new PVector(PApplet.parseFloat(lineData[0])*scale, PApplet.parseFloat(lineData[1])*scale);
    PVector end = new PVector(PApplet.parseFloat(lineData[2])*scale, PApplet.parseFloat(lineData[3])*scale);
    _rewardLines.add(new Line(start.copy(), end.copy()));
  }
}


//---------------------------------------------------------------------------------


public void keyPressed() {
    if(key == 'o' || key == 'O') {
      selectInput("Load map txt file", "readFile");
  }
}
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


  public boolean isColliding(Line other) {
     for(int i = 0; i < edges.length; i++) {
       if(edges[i].isIntersecting(other)) {
         return true;
       }
     }
     
     return false;
  }
  
  
//-------------------------------------------------------------------------------


  public boolean isColliding(Line[] others) {
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


  public boolean isColliding(ArrayList<Line> others) {
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


  public int isCollidingIndex(ArrayList<Line> others) {
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


  public void display() {
    for(int i = 0; i < edges.length; i++) {
      stroke(0);
      edges[i].display();
    }
  }


//-------------------------------------------------------------------------------


  public void update() {
    edges[0] = new Line(new PVector(pos.x, pos.y), new PVector(pos.x+wid, pos.y));
    edges[1] = new Line(new PVector(pos.x, pos.y), new PVector(pos.x, pos.y+wid));
    edges[2] = new Line(new PVector(pos.x, pos.y+wid), new PVector(pos.x+wid, pos.y+wid));
    edges[3] = new Line(new PVector(pos.x+wid, pos.y+wid), new PVector(pos.x+wid, pos.y));
  }
  
}
class Button {
  float w;
  float h;

  String text;
  PVector pos;

  int normal = 0xffc3c3c3;
  int highlighted = 0xff817a7a;
  int pressedColor = 0xff585252;
  int currentColor;

  int textColor = color(0);

  boolean outline = true;

  boolean pressed;

  float coolTime = 0;
  float cool = 0;

//-------------------------------------------------------------------------------

  //Button constructor takes the message, position and size of the button
  Button(PVector p, float _w, float _h) {
    pos = p.copy();
    w = _w;
    h = _h;
  }


//-------------------------------------------------------------------------------


  //Function called whenever button is updated
  public void update() {

    //If mouse is within button
    if((mouseX > pos.x && mouseX < pos.x + w) && (mouseY > pos.y && mouseY < pos.y + h)) {

      //If left mouse pressed while inside button
      if(mousePressed && mouseButton == LEFT) {
        //Set color to pressedColor and the pressed boolean to true
        if(millis() > coolTime) {
          coolTime = cool+millis();
          pressed = true;
        }
        else {
          pressed = false;
        }

        currentColor = pressedColor;
      }

      //If mouse is not pressed
      else {
        //Set color to highlighted and the pressed boolean to false
        currentColor = highlighted;
        pressed = false;
      }
    }

    //If mouse not within button
    else {
      //Set color to normal and the pressed boolean to false
      currentColor = normal;
      pressed = false;
    }
  }


//-------------------------------------------------------------------------------

  //Draws the button and text
  public void display() {
    if(outline) {
      strokeWeight(5);
      stroke(currentColor);
      noFill();
    }

    else {
      noStroke();
      fill(currentColor);
    }

    rect(pos.x, pos.y, w, h);

    fill(textColor);
    textAlign(CENTER, CENTER);
    textSize(25);
    text(text, pos.x+(w*.5f), pos.y+(h*.5f));
  }


//-------------------------------------------------------------------------------
}
class Car implements Comparable<Car> {
  NeuralNetwork brain;
  PVector pos = new PVector(0, 0);
  float acc, vel = 0;
  float size = 15;
  SharedFloat rot = new SharedFloat();

  boolean dead = false;
  boolean player = false;

  final float maxVel = 4f;
  final float lineLen = 10f;

  int col;
  float fitness;

  int framesAlive = 0;
  int rewardIndex = 0;
  int rewardNumb = 0;

  Line[] lines;
  float[] linesT;
  float lineLength = 50;

  boolean haveChild = false;

  BoxCollider boxCol;

//---------------------------------------------------------------------------------


  Car() {
    pos = _startPos.copy();
    col = color(random(255), random(255), random(255));

    lines = new Line[5];
    linesT = new float[lines.length];

    lines[0] = new Line(pos, lineLength, 90, rot);
    lines[1] = new Line(pos, lineLength, 45, rot);
    lines[2] = new Line(pos, lineLength, 0, rot);
    lines[3] = new Line(pos, lineLength, -45, rot);
    lines[4] = new Line(pos, lineLength, -90, rot);

    boxCol = new BoxCollider(pos, size);
  }


//---------------------------------------------------------------------------------


  Car(Car papa) {
    pos = _startPos.copy();
    col = papa.col;
    player = papa.player;

    brain = papa.brain.copy();

    lines = new Line[5];
    linesT = new float[lines.length];

    lines[0] = new Line(pos, lineLength, 90, rot);
    lines[1] = new Line(pos, lineLength, 45, rot);
    lines[2] = new Line(pos, lineLength, 0, rot);
    lines[3] = new Line(pos, lineLength, -45, rot);
    lines[4] = new Line(pos, lineLength, -90, rot);

    boxCol = new BoxCollider(pos, size);
  }


//---------------------------------------------------------------------------------


  public void update() {
    if(!dead) {
      calcFitness();
      if(player) {
        acc = 1;
        vel += acc;
        vel = limit(vel, -maxVel, maxVel);

        if(keyPressed && (key == 'd' || key == 'D')) {
          rot.set(rot.get() + 3);
        }

        else if(keyPressed && (key == 'a' || key == 'A')) {
          rot.set(rot.get() - 3);
        }
      }

      else {
        for(int i = 0; i < lines.length; i++) {
          lines[i].rot = rot;
          lines[i].update();
          linesT[i] = lines[i].getLowestT(_lines);
        }

        double[] inputs = {
          0,
          vel/maxVel,
          acc,
          rot.get()/360,
          linesT[0],
          linesT[1],
          linesT[2],
          linesT[3],
          linesT[4]
        };

        if(mousePressed) {
          inputs[0] = 1;
        }

        double[] outputs = brain.feedForward(inputs);

        acc = (float)outputs[1];
        vel += acc;
        vel = limit(vel, -maxVel, maxVel);

        rot.set(rot.get() + 16 * (float)outputs[0]);
      }

      int rewardLineIndex = boxCol.isCollidingIndex(_rewardLines);

      if(boxCol.isColliding(_lines)) {
        dead = true;
        return;
      }

      else if(rewardLineIndex != -1 && rewardIndex != rewardLineIndex) {
        rewardIndex = rewardLineIndex;
        rewardNumb++;
      }

      pos.add(cos(radians(rot.get()))*vel, sin(radians(rot.get()))*vel);

      boxCol.pos = new PVector(pos.x - (size/2), pos.y - (size/2));
      boxCol.update();
      framesAlive++;
    }
  }


//---------------------------------------------------------------------------------


  public void begin() {
    if(player) {
      size = 20*_scale;
      col = color(247, 218, 23);
    }
    else {
      col = color(random(255), random(255), random(255), 180);
    }

    pos = _startPos.copy();

    lines = new Line[5];
    linesT = new float[lines.length];

    lines[0] = new Line(pos, lineLength, 90, rot);
    lines[1] = new Line(pos, lineLength, 45, rot);
    lines[2] = new Line(pos, lineLength, 0, rot);
    lines[3] = new Line(pos, lineLength, -45, rot);
    lines[4] = new Line(pos, lineLength, -90, rot);

    boxCol = new BoxCollider(pos, size);
  }


//---------------------------------------------------------------------------------


  public void display() {
    //strokeWeight(3);
    noStroke();
    fill(col);
    ellipse(pos.x, pos.y, size, size);

    /*fill(255, 0, 0);
    for(int i = 0; i < lines.length; i++) {
       ellipse(pos.x + (cos(radians(lines[i].oRot+rot.get()))*(lines[i].len*linesT[i])), pos.y+(sin(radians(lines[i].oRot+rot.get()))*(lines[i].len*linesT[i])), 5, 5);
    }*/

    stroke(col);
    strokeWeight(2);
    line(pos.x, pos.y, pos.x + (cos(radians(rot.get())) * lineLen*_scale), pos.y + (sin(radians(rot.get())) * lineLen*_scale));

    stroke(0, 0, 0, 120);
    //boxCol.display();
    /*for(int i = 0; i < lines.length; i++) {
      lines[i].display();
    }*/
  }


//---------------------------------------------------------------------------------


  public int compareTo(Car other) {
    if(fitness > other.fitness) {
      return 1;
    }

    else if(fitness < other.fitness) {
      return -1;
    }

    else {
      return 0;
    }
  }


//---------------------------------------------------------------------------------


  public void calcFitness() {
    fitness = rewardNumb*rewardNumb*rewardNumb;
  }


//---------------------------------------------------------------------------------


  public Car copy() {
    return new Car(this);
  }


//---------------------------------------------------------------------------------


  public float limit(float x, float max) {
    if(x > max) {
      return max;
    }

    return x;
  }


//---------------------------------------------------------------------------------


  public float limit(float x, float min, float max) {
    if(x > max) {
      return max;
    }

    if(x < min) {
      return min;
    }

    return x;
  }
}
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


  public void update() {
    end = new PVector(start.x+cos(radians(rot.get()+oRot))*len, start.y+sin(radians(rot.get()+oRot))*len);
  }


  //---------------------------------------------------------------------------------


  public void display() {
    strokeWeight(5);
    line(start.x, start.y, end.x, end.y);
  }


  //---------------------------------------------------------------------------------


  public PVector intersect(Line other) {

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


  public float getLowestIntersects(ArrayList<Line> others) {
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


  public boolean isIntersecting(Line other) {

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


  public Line getLowestTLine(ArrayList<Line> lines) {

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


  public float getLowestT(ArrayList<Line> lines) {
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


  public float getLowestU(ArrayList<Line> lines) {
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


class NeuralNetwork {
  //My neural network class which I'll probably use on everything. Original tutorial: https://www.youtube.com/watch?v=zwKKYUZh4ok&list=PLgomWLYGNl1dL1Qsmgumhcg4HOcWZMd3k&index=2. Tiny D out

  public final int[] layers;
  public final int NETWORKSIZE;
  public final int INPUTSIZE;
  public final int OUTPUTSIZE;

  private double[][] neurons;
  private double[][] bias;
  private double[][][] weights;


//---------------------------------------------------------------------------------


  public NeuralNetwork(int[] layers) {
    this.layers = layers;

    NETWORKSIZE = layers.length;
    INPUTSIZE = layers[0];
    OUTPUTSIZE = layers[NETWORKSIZE-1];

    neurons = new double[NETWORKSIZE][];
    bias = new double[NETWORKSIZE][];
    weights = new double[NETWORKSIZE][][];

    for (int i = 0; i < layers.length; i++) {
      neurons[i] = new double[layers[i]];
      bias[i] = createRandomArray(layers[i], -.5d, .5d);

      if (i > 0) {
        weights[i] = createRandomArray(layers[i], layers[i-1], -0.75d, 0.75d);
      }
    }
  }


//---------------------------------------------------------------------------------


  public NeuralNetwork(NeuralNetwork papa) {
    this.layers = papa.layers.clone();

    NETWORKSIZE = layers.length;
    INPUTSIZE = layers[0];
    OUTPUTSIZE = layers[NETWORKSIZE-1];

    neurons = new double[NETWORKSIZE][];
    bias = new double[NETWORKSIZE][];
    weights = new double[NETWORKSIZE][][];

    for (int i = 0; i < layers.length; i++) {
      neurons[i] = new double[layers[i]];

      if (i > 0) {
        weights[i] = copyArray(papa.weights[i]);
      }
    }

    bias = copyArray(papa.bias);
  }


//---------------------------------------------------------------------------------


  NeuralNetwork(NeuralNetwork brain, NeuralNetwork partner) {
    int split = (int)random(brain.layers.length);
    layers = brain.layers;
    NETWORKSIZE = layers.length;
    INPUTSIZE = layers[0];
    OUTPUTSIZE = layers[NETWORKSIZE-1];

    neurons = new double[NETWORKSIZE][];
    bias = new double[NETWORKSIZE][];
    weights = new double[NETWORKSIZE][][];

    for (int layer = 0; layer < brain.NETWORKSIZE; layer++) {
      neurons[layer] = new double[layers[layer]].clone();
      if(layer > 0) {
       if(layer > split) {
          weights[layer] = brain.weights[layer].clone();
        }

        else {
          weights[layer] = partner.weights[layer].clone();
        }
      }

      if(layer > split) {
          bias[layer] = brain.bias[layer].clone();
        }

      else {
        bias[layer] = partner.bias[layer].clone();
      }
    }
  }


//---------------------------------------------------------------------------------


  public double[] feedForward(double[] input) {
    if (input.length != INPUTSIZE) {
      println("Inputs not equal to inputlayer");
      return null;
    }

    neurons[0] = input;

    for (int layer = 1; layer < NETWORKSIZE; layer++) {
      for (int neuron = 0; neuron < layers[layer]; neuron++) {

        double sum = 0;
        sum += bias[layer][neuron];
        for (int prevNeuron = 0; prevNeuron < layers[layer-1]; prevNeuron++) {
          sum += neurons[layer-1][prevNeuron] * weights[layer][neuron][prevNeuron];
        }

        neurons[layer][neuron] = sigmoid(sum);
      }
    }

    return neurons[NETWORKSIZE-1];
  }


//---------------------------------------------------------------------------------


  public void mutate(double mutationRate) {
    for (int layer = 1; layer < NETWORKSIZE; layer++) {
      for (int neuron = 0; neuron < layers[layer]; neuron++) {
        for (int prevNeuron = 0; prevNeuron < layers[layer-1]; prevNeuron++) {
          if (random(1) < mutationRate) {
            weights[layer][neuron][prevNeuron] += random(-1, 1);

            if (weights[layer][neuron][prevNeuron] > 1) {
              weights[layer][neuron][prevNeuron] = 1;
            }

            else if (weights[layer][neuron][prevNeuron] < -1) {
              weights[layer][neuron][prevNeuron] = -1;
            }
          }
        }

        if (random(1) < mutationRate) {
          bias[layer][neuron] += random(-1, 1);

          if (bias[layer][neuron] > 1) {
            bias[layer][neuron] = 1;
          }

          else if (bias[layer][neuron] < -1) {
            bias[layer][neuron] = -1;
          }
        }
      }
    }
  }


//---------------------------------------------------------------------------------


  public NeuralNetwork crossover(NeuralNetwork partner) {
    int split = (int)random(layers.length);
    NeuralNetwork child = new NeuralNetwork(layers);

    for (int layer = 1; layer < NETWORKSIZE; layer++) {
        if(layer > split) {
          child.weights[layer] = weights[layer];
        }

        else {
          child.weights[layer] = partner.weights[layer];
        }

        if(layer > split) {
            child.bias[layer] = bias[layer];
          }

        else {
          child.bias[layer] = partner.bias[layer];
        }

    }

    return child;
  }


//---------------------------------------------------------------------------------


  public NeuralNetwork copy() {
    return new NeuralNetwork(this);
  }


//---------------------------------------------------------------------------------


  private double sigmoid(double x) {
    return java.lang.Math.tanh(x);
  }


//---------------------------------------------------------------------------------


  private double inverseSigmoid(double x) {
    return 1d/(1+Math.exp(-x));
  }


//---------------------------------------------------------------------------------


  public void display() {
    display(new PVector(0, 0));
  }


//---------------------------------------------------------------------------------

  public void display(PVector offset) {
    float size = 3.3f;

    stroke(255);
    strokeWeight(size);
    fill(0);

    for (int layer = 1; layer < layers.length; layer++) {
      for (int neuron = 0; neuron < layers[layer]; neuron++) {
        for (int prevNeuron = 0; prevNeuron < layers[layer-1]; prevNeuron++) {

          float x = 25*size + (layer*50*size) + ((width*.5f) - (layers.length*50*.5f*size));
          float y = 15*size + (neuron*30*size) + ((width*.5f) - (layers[layer]*.5f*30*size));

          float x2 = 25*size + ((layer-1)*50*size) + ((width*.5f) - (layers.length*50*.5f*size));
          float y2 = 15*size + (prevNeuron*30*size) + ((width*.5f) - (layers[layer-1]*.5f*30*size));

          line(x+offset.x, y+offset.y, x2+offset.x, y2+offset.y);

          int o = (int)(weights[layer][neuron][prevNeuron]*10000);
          float e = (float)o/10000;

          fill(255, 0, 0);
          textAlign(CENTER, CENTER);
          textSize(5*size);
          text(e + "", ((x+x2)/2)+offset.x, ((y+y2)/2)+offset.y);
        }
      }
    }

    stroke(255);
    strokeWeight(size);

    for (int layer = 0; layer < layers.length; layer++) {
      for (int neuron = 0; neuron < layers[layer]; neuron++) {

        float x = 25*size + (layer*50*size) + ((width*.5f) - (layers.length*50*.5f*size));
        float y = 15*size + (neuron*30*size) + ((width*.5f) - (layers[layer]*.5f*30*size));
        fill(0);
        ellipse(x+offset.x, y+offset.y, 20*size, 20*size);
        int o = (int)(neurons[layer][neuron]*10000);
        float e = (float)o/10000;
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(5*size);
        text(e + "", x+offset.x, y+offset.y);
      }
    }
  }


//---------------------------------------------------------------------------------


  public double[] createArray(int size, double value) {
    if (size < 1) {
      return null;
    }

    double[] result = new double[size];

    for (int i = 0; i < size; i++) {
      result[i] = value;
    }

    return result;
  }


//---------------------------------------------------------------------------------


  public double[] createRandomArray(int size, double min, double max) {
    if (size < 1) {
      return null;
    }

    double[] result = new double[size];

    for (int i = 0; i < size; i++) {
      result[i] = (double) (random((float)(min*1000), (float)(max*1000))*.001f);
    }

    return result;
  }


//---------------------------------------------------------------------------------


  public double[][] createRandomArray(int size1, int size2, double min, double max) {
    if (size1 < 1) {
      return null;
    }

    double[][] result = new double[size1][size2];

    for (int i = 0; i < size1; i++) {
      for (int j = 0; j < size2; j++) {
        result[i][j] = (double) (random((float)(min*1000), (float)(max*1000))*.001f);
      }
    }

    return result;
  }


//---------------------------------------------------------------------------------


  public double[] copyArray(double[] b) {
    double[] a = new double[b.length];
    for(int i = 0; i < b.length; i++) {
      a[i] = b[i];
    }

    return a;
  }


//---------------------------------------------------------------------------------


  public double[][] copyArray(double[][] b) {
    double[][] a = new double[b.length][];
    for(int i = 0; i < b.length; i++) {
      a[i] = new double[b[i].length];

      for(int j = 0; j < b[i].length; j++) {
        a[i][j] = b[i][j];
      }
    }

    return a;
  }
}
class NumberField {
  final float max;
  final float min;
  final float addAmount;
  float value;

  PVector pos;
  float w;

  Button up;
  Button down;

//---------------------------------------------------------------------------------


  NumberField(PVector pos, float w, float max, float min, float addAmount, float defaultValue) {
    this.max = max;
    this.min = min;
    this.addAmount = addAmount;
    value = defaultValue;

    this.pos = new PVector(pos.x, pos.y);
    this.w = w*_scale;

    up = new Button(new PVector(pos.x+w, pos.y), w, w/2);
    up.outline = false;
    up.cool = 120;
    up.text = "+" + addAmount;

    down = new Button(new PVector(pos.x+w, pos.y+(w/2)), w, w/2);
    down.outline = false;
    down.cool = 120;
    down.text = "-" + addAmount;
  }


//---------------------------------------------------------------------------------


  public void display() {
    noStroke();
    fill(255);
    rect(pos.x, pos.y, w, w);

    fill(0);
    textSize(30*_scale);
    textAlign(CENTER, CENTER);
    float displayValue = (float)((int)(value*100))/100;
    text((displayValue)+"", pos.x+(w/2), pos.y+(w/2));

    up.display();
    down.display();
  }


//---------------------------------------------------------------------------------


  public void update() {
    up.update();
    down.update();

    if(up.pressed) {
      value += addAmount;

      if(value > max) {
        value = max;
      }
    }

    if(down.pressed) {
      value -= addAmount;

      if(value < min) {
        value = min;
      }
    }
  }


//---------------------------------------------------------------------------------
}
class Population {
  ArrayList<Car> cars = new ArrayList<Car>();
  int[] layers = { 9, 18, 2 };
  int generation = 0;

  int framesPerGeneration = 300;
  int extraFrames = 50;
  int extraFrameTime = 2;
  int frame = 0;

  boolean sexualReproduction = true;
  int thanosAmount = 2;
  double mutationRate = .1f;

  boolean started = false;

  Population(int size) {
    for(int i = 0; i < size; i++) {
      cars.add(new Car());
      cars.get(i).brain = new NeuralNetwork(layers);
    }
    //cars.get(size-1).player = true;
  }


//---------------------------------------------------------------------------------


  public void update() {
    update(1);
  }


//---------------------------------------------------------------------------------


  public void update(int numbUpdates) {
    if(!started) {
      for(int i = 0; i < cars.size(); i++) {
        cars.get(i).begin();
      }

      started = true;
      return;
    }

    for(int j = 0; j < numbUpdates; j++) {

      for(int i = 0; i < cars.size(); i++) {
        cars.get(i).update();
      }

      if(frame > framesPerGeneration) {
         nextGeneration();
         if(generation % extraFrameTime == 0) {
           framesPerGeneration += extraFrames;
         }
      }
      frame++;
    }
    float totalFitness = 0;

    for(int i = 0; i < cars.size(); i++) {
      cars.get(i).display();
      totalFitness += cars.get(i).fitness;
    }

    stroke(0);
    fill(0);
    textSize(20);
    textAlign(LEFT);
    text(frame + "/" + framesPerGeneration, 5, 770);
    text("Generation: " + generation, 5, 730);
    text("Average fitness: " + (totalFitness/cars.size()), 5, 690);
    text("Total fitness: " + totalFitness, 5, 650);
  }


//---------------------------------------------------------------------------------


  public void nextGeneration() {
    ArrayList<Car> nextCars = new ArrayList<Car>();
    float totalFitness = 0;
    float bestFitness = 0;

    java.util.Collections.sort(cars);
    java.util.Collections.reverse(cars);

    for(int i = 0; i < cars.size()/thanosAmount; i++) {
      if(bestFitness < cars.get(i).fitness) {
         bestFitness = cars.get(i).fitness;
      }
      totalFitness += cars.get(i).fitness;
    }

    for(int i = 0; i < 1; i++) {
      println(cars.get(i).fitness);
    }

    float averageFitness = totalFitness/(cars.size()/thanosAmount);

    println("");
    println("Total fitness: " + totalFitness);
    println("Best fitness: " + bestFitness);
    println("Average fitness: " + averageFitness);

    for(int i = 0; i < cars.size(); i++) {
      Car papa = getPapa(totalFitness);
      nextCars.add(papa.copy());

      if(sexualReproduction) {
        Car papa2 = getPapa(totalFitness);
        nextCars.get(i).brain = new NeuralNetwork(papa.brain.copy(), papa2.brain.copy());
      }

      else {
        nextCars.get(i).brain = papa.brain.copy();
      }

      nextCars.get(i).brain.mutate(mutationRate);
      float r = red(papa.col) + random(-255*(float)mutationRate, 255*(float)mutationRate);
      float g = green(papa.col) + random(-255*(float)mutationRate, 255*(float)mutationRate);
      float b = blue(papa.col) + random(-255*(float)mutationRate, 255*(float)mutationRate);
      nextCars.get(i).col = color(r, g, b);
    }

    cars.clear();

    XML generationXML = _xml.addChild("Generation");

    XML averageFitnessXML = generationXML.addChild("AverageFitness");
    averageFitnessXML.setContent(str(averageFitness));
    saveXML(_xml, "data/data.xml");

    cars = (ArrayList<Car>) nextCars.clone();
    generation++;
    frame = 0;
  }


//---------------------------------------------------------------------------------


  public Car getPapa(float totalFitness) {

    float rand = random(totalFitness);

    for(int i = 0; i < cars.size()/thanosAmount; i++) {
      rand -= cars.get(i).fitness;
      if(0 >= rand) {
        return cars.get(i).copy();
      }
    }

    return cars.get((int)random(cars.size()/thanosAmount));
  }


//---------------------------------------------------------------------------------


  public void randomize (Car[] arrMy) {
    for (int k=0; k < arrMy.length; k++) {
      int x = (int)random(0, arrMy.length);
      arrMy = swapValues(arrMy, k, x);
    }
  }


//---------------------------------------------------------------------------------


  public Car[] swapValues (Car[] myArray, int a, int b) {
    Car temp=myArray[a].copy();
    myArray[a]=myArray[b].copy();
    myArray[b]=temp;
    return myArray;
  }
}
class SharedFloat {
  private float value;
  
  SharedFloat() {
      
  }
  
  public float get() {
    return value;  
  }
  
  public void set(float val) {
    value = val;
  }
}
  public void settings() {  size(800, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ISTEM_biomimicry" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
