class Car implements Comparable<Car> {
  NeuralNetwork brain;
  PVector pos = new PVector(0, 0);
  float acc, vel = 0;
  float size = 12;
  SharedFloat rot = new SharedFloat();

  boolean dead = false;
  boolean player = false;

  final float maxVel = 4f;
  final float lineLen = 6f;

  color col;
  float fitness;

  int framesAlive = 0;
  int rewardIndex = 0;
  int rewardNumb = 0;

  Line[] lines;
  float[] linesT;
  float lineLength = 50;

  BoxCollider boxCol;
  boolean male;

//---------------------------------------------------------------------------------


  Car() {
    pos = _startPos.copy();
    col = color(random(255), random(255), random(255));

    if(random(1) > .5) {
      male = true;
    }

    else {
      male = false;
    }

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


  void update() {
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


  void begin() {
    if(player) {
      size = 15*_scale;
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


  void display() {
    //strokeWeight(3);
    fill(col);
    ellipse(pos.x, pos.y, size, size);

    /*fill(255, 0, 0);
    for(int i = 0; i < lines.length; i++) {
       ellipse(pos.x + (cos(radians(lines[i].oRot+rot.get()))*(lines[i].len*linesT[i])), pos.y+(sin(radians(lines[i].oRot+rot.get()))*(lines[i].len*linesT[i])), 5, 5);
    }*/

    stroke(0);
    strokeWeight(2);
    line(pos.x, pos.y, pos.x + (cos(radians(rot.get())) * lineLen*_scale), pos.y + (sin(radians(rot.get())) * lineLen*_scale));

    stroke(0, 0, 0, 120);
    //boxCol.display();
    /*for(int i = 0; i < lines.length; i++) {
      lines[i].display();
    }*/
  }


//---------------------------------------------------------------------------------


  int compareTo(Car other) {
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


  void calcFitness() {
    fitness = rewardNumb*rewardNumb*rewardNumb*rewardNumb;
  }


//---------------------------------------------------------------------------------


  Car copy() {
    return new Car(this);
  }


//---------------------------------------------------------------------------------


  float limit(float x, float max) {
    if(x > max) {
      return max;
    }

    return x;
  }


//---------------------------------------------------------------------------------


  float limit(float x, float min, float max) {
    if(x > max) {
      return max;
    }

    if(x < min) {
      return min;
    }

    return x;
  }
}
