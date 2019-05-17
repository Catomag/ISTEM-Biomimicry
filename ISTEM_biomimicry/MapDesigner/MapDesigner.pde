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


void setup() {
  size(800, 800);
}


//---------------------------------------------------------------------------------


void draw() {
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


void readFile(File selection) {
  String[] data = loadStrings(selection.getAbsolutePath());
  boolean doneLines = false;

  println("Width is: " + data[0]);

  lines = new ArrayList<Line>();
  rewardGates = new ArrayList<Line>();

  String[] startData = data[3].split(",");
  start = new PVector(float(startData[0]), float(startData[1]));

  for(int i = 0; i < int(data[1]); i++) {
    println(data[i+4]);
    String[] lineData = data[i+4].split(",");

    PVector start = new PVector(float(lineData[0]), float(lineData[1]));
    PVector end = new PVector(float(lineData[2]), float(lineData[3]));
    lines.add(new Line(start.copy(), end.copy()));
  }

  println("Lines size is: " + lines.size());

  for(int i = 0; i < int(data[2]); i++) {
    String[] lineData = data[i+lines.size()+4].split(",");

    PVector start = new PVector(float(lineData[0]), float(lineData[1]));
    PVector end = new PVector(float(lineData[2]), float(lineData[3]));
    rewardGates.add(new Line(start.copy(), end.copy()));
  }
}


//---------------------------------------------------------------------------------


void writeFile(File selection) {
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


void mouseReleased() {
 mouseReleased = true;
}


//---------------------------------------------------------------------------------


void mousePressed() {
 mouseReleased = false;
}


//---------------------------------------------------------------------------------


void keyPressed() {
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


void keyReleased() {
  if(key == 'z' || key == 'Z') {
    zPressed = false;
  }

  if(key == 'x' || key == 'X') {
    xPressed = false;
  }
}


//---------------------------------------------------------------------------------


void mouseWheel(MouseEvent event) {
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


void cycle() {
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
