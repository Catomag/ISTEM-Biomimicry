enum State {
  MENU,
  STARTSIMULATION,
  SIMULATING,
}

Population pop;
State state = State.MENU;

static float _scale = 1;

static ArrayList<Line> _lines = new ArrayList<Line>();
static ArrayList<Line> _rewardLines = new ArrayList<Line>();

static PVector _startPos = new PVector(400, 400);
static XML _xml;

NeuralNetwork net = new NeuralNetwork(new int[] { 1, 2, 1 });

static int fileIndex;

String[] maps;
int mapIndex = 0;

Button startButton = new Button(new PVector(0, 700), 150, 100);
Button nextButton = new Button(new PVector(730, 480), 50, 100);
Button prevButton = new Button(new PVector(200, 480), 50, 100);
NumberField mutationField;
BooleanField sexualReproductionField;
BooleanField sexualDimorphismField;

//---------------------------------------------------------------------------------


void setup() {
  size(800, 800);
  File[] files = listFiles("/Data/");
  //randomSeed(1);
  if(files == null) {
    fileIndex = 0;
  }

  else {
    fileIndex = files.length;
  }

  File[] mapFiles = listFiles("/Maps/");

  maps = new String[mapFiles.length];

  for(int i = 0; i < mapFiles.length; i++) {
    maps[i] = mapFiles[i].getName();
  }

  _xml = new XML("Training_Data");

  readFile(maps[mapIndex]);

  _scale = width/800;
  pop = new Population(500);

  mutationField = new NumberField(new PVector(0, 550), 100, 1, 0, .01, .01);

  sexualReproductionField = new BooleanField(new PVector(0, 400), 100, 100);
  sexualReproductionField.cool = 200;
  sexualReproductionField.outline = false;
  sexualReproductionField.value = true;

  sexualDimorphismField = new BooleanField(new PVector(0, 250), 100, 100);
  sexualDimorphismField.cool = 200;
  sexualDimorphismField.outline = false;
  sexualDimorphismField.value = true;

  startButton.text = "Start";
  startButton.normal = color(random(50,255), random(50,255), random(50,255));
  startButton.highlighted = color(random(25,200), random(25,200), random(25,200));
  startButton.pressedColor = color(random(10,150), random(10,150), random(10,150));
  startButton.outline = false;

  nextButton.text = "►";
  nextButton.normal = color(random(50,255), random(50,255), random(50,255));
  nextButton.highlighted = color(random(25,200), random(25,200), random(25,200));
  nextButton.pressedColor = color(random(10,150), random(10,150), random(10,150));
  nextButton.outline = false;
  nextButton.cool = 200;

  prevButton.text = "◄";
  prevButton.normal = color(random(50,255), random(50,255), random(50,255));
  prevButton.highlighted = color(random(25,200), random(25,200), random(25,200));
  prevButton.pressedColor = color(random(10,150), random(10,150), random(10,150));
  prevButton.outline = false;
  prevButton.cool = 200;
}


//---------------------------------------------------------------------------------


void reset() {
  _xml = new XML("Training_Data");
  File[] files = listFiles("/Data/");
  randomSeed(1);
  fileIndex = files.length;

  pop = new Population(20);
}


//---------------------------------------------------------------------------------


void draw() {
  background(255);

  switch(state) {
    case MENU:
      displayMenu();
    break;

    case SIMULATING:
      displayLines(1);

      pop.mutationRate = mutationField.value;
      pop.sexualReproduction = sexualReproductionField.value;
      pop.sexualDimorphism = sexualDimorphismField.value;

      if(keyPressed && key == 'x') {
        pop.update();
      }

      else {
        pop.update(12);
      }

      /*if(pop.generation > 40) {
        reset();
      }*/

    break;
  }
}


//---------------------------------------------------------------------------------


void displayMenu() {
  PVector offset = new PVector(250, 200);
  float scale = .6;

  fill(50);
  rect(offset.x, offset.y, 800*scale, 800*scale);
  fill(255);
  rect(offset.x+5, offset.y+5, (800*scale)-10, (800*scale)-10);

  fill(0);
  String[] mapName = maps[mapIndex].split(".txt");
  text(mapName[0], offset.x+((800*scale)/2), offset.y-20);

  noStroke();
  displayLines(scale, offset);

  startButton.update();
  startButton.display();

  textSize(20);
  fill(0);
  textAlign(LEFT);
  text("Mutation Rate", mutationField.pos.x+5, mutationField.pos.y-10);
  mutationField.update();
  mutationField.display();

  textSize(20);
  fill(0);
  textAlign(LEFT);
  text("Sexual Reproduction", sexualReproductionField.pos.x+5, sexualReproductionField.pos.y-10);
  sexualReproductionField.update();
  sexualReproductionField.display();

  textSize(20);
  fill(0);
  textAlign(LEFT);
  text("Sexual Dimorphism", sexualDimorphismField.pos.x+5, sexualDimorphismField.pos.y-10);
  sexualDimorphismField.update();
  sexualDimorphismField.display();

  nextButton.display();
  nextButton.update();

  prevButton.display();
  prevButton.update();

  if(prevButton.pressed || nextButton.pressed) {

    if(prevButton.pressed) {
      mapIndex++;
    }

    else {
      mapIndex--;
    }

    if(mapIndex < 0) {
      mapIndex = maps.length - 1;
    }

    else if(mapIndex > maps.length - 1) {
      mapIndex = 0;
    }

    readFile(maps[mapIndex]);
  }

  if(startButton.pressed) {
    state = State.SIMULATING;
  }
}


//---------------------------------------------------------------------------------


void displayLines(float scale) {
  displayLines(scale, new PVector(0, 0));
}


//---------------------------------------------------------------------------------


void displayLines(float scale, PVector pos) {
  pushMatrix();
  scale(scale);
  translate(pos.x*(1/scale), pos.y*(1/scale));
  stroke(0);
  strokeWeight(3);
  for(int i = 0; i < _lines.size(); i++) {
    _lines.get(i).display();
  }

  stroke(247, 216, 54);
  for(int i = 0; i < _rewardLines.size(); i++) {
    _rewardLines.get(i).display();
  }
  popMatrix();
}


//---------------------------------------------------------------------------------


void readFile(File selection) {
  String[] data = loadStrings(selection.getAbsolutePath());

  float scale = width/float(data[0]);

  _lines = new ArrayList<Line>();
  _rewardLines = new ArrayList<Line>();

  String[] startData = data[3].split(",");
  _startPos = new PVector(float(startData[0])*scale, float(startData[1])*scale);

  for(int i = 0; i < int(data[1]); i++) {
    String[] lineData = data[i+4].split(",");

    PVector start = new PVector(float(lineData[0])*scale, float(lineData[1])*scale);
    PVector end = new PVector(float(lineData[2])*scale, float(lineData[3])*scale);
    _lines.add(new Line(start.copy(), end.copy()));
  }

  for(int i = 0; i < int(data[2]); i++) {
    String[] lineData = data[i+_lines.size()+4].split(",");

    PVector start = new PVector(float(lineData[0])*scale, float(lineData[1])*scale);
    PVector end = new PVector(float(lineData[2])*scale, float(lineData[3])*scale);
    _rewardLines.add(new Line(start.copy(), end.copy()));
  }
}


//---------------------------------------------------------------------------------


void readFile(String selection) {
  String[] data = loadStrings("/Maps/" + selection);

  float scale = width/float(data[0]);

  _lines = new ArrayList<Line>();
  _rewardLines = new ArrayList<Line>();

  String[] startData = data[3].split(",");
  _startPos = new PVector(float(startData[0])*scale, float(startData[1])*scale);

  for(int i = 0; i < int(data[1]); i++) {
    String[] lineData = data[i+4].split(",");

    PVector start = new PVector(float(lineData[0])*scale, float(lineData[1])*scale);
    PVector end = new PVector(float(lineData[2])*scale, float(lineData[3])*scale);
    _lines.add(new Line(start.copy(), end.copy()));
  }

  for(int i = 0; i < int(data[2]); i++) {
    String[] lineData = data[i+_lines.size()+4].split(",");

    PVector start = new PVector(float(lineData[0])*scale, float(lineData[1])*scale);
    PVector end = new PVector(float(lineData[2])*scale, float(lineData[3])*scale);
    _rewardLines.add(new Line(start.copy(), end.copy()));
  }
}


//---------------------------------------------------------------------------------


void keyPressed() {
    if(key == 'o' || key == 'O') {
      selectInput("Load map txt file", "readFile");
  }
}
