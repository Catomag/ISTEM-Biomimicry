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

NeuralNetwork net = new NeuralNetwork(new int[] { 1, 2, 1 });

static int fileIndex;

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

  _xml = new XML("Training_Data");

  _scale = width/800;
  selectInput("Load map txt file", "readFile");
  pop = new Population(500);
  mutationField = new NumberField(new PVector(0, 400), 100f, 1f, 0f, .01f, .01f);

  startButton.text = "Start";
  startButton.normal = #5773F7;
  startButton.highlighted = #2444DE;
  startButton.pressedColor = #2F0D90;
  startButton.outline = false;
}


//---------------------------------------------------------------------------------


void reset() {
  _xml = new XML("Training_Data");
  File[] files = listFiles("/Data/");
  //randomSeed(1);
  fileIndex = files.length;

  pop = new Population(500);
}


//---------------------------------------------------------------------------------


void draw() {
  background(255);
  mutationField.update();

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
        pop.update(8);
      }

      if(pop.generation > 40) {
        reset();
      }

    break;
  }

  //mutationField.display();
}


//---------------------------------------------------------------------------------


void displayMenu() {
  startButton.update();
  startButton.display();

  if(startButton.pressed) {
    state = State.SIMULATING;
  }
}


//---------------------------------------------------------------------------------


void displayLines() {
  stroke(0);
  strokeWeight(3);
  for(int i = 0; i < _lines.size(); i++) {
    _lines.get(i).display();
  }

  stroke(247, 216, 54);
  for(int i = 0; i < _rewardLines.size(); i++) {
    _rewardLines.get(i).display();
  }
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


void keyPressed() {
    if(key == 'o' || key == 'O') {
      selectInput("Load map txt file", "readFile");
  }
}
