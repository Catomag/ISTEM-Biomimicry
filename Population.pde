class Population {
  ArrayList<Car> cars = new ArrayList<Car>();
  int[] layers = { 9, 18, 6, 2 };
  int generation = 0;

  int framesPerGeneration = 500;
  int extraFrames = 0;
  int extraFrameTime = 2;
  int frame = 0;

  boolean sexualReproduction = true;
  boolean sexualDimorphism = true;
  int thanosAmount = 2;
  double mutationRate = .01;

  boolean started = false;

  Population(int size) {
    for(int i = 0; i < size; i++) {
      cars.add(new Car());
      cars.get(i).brain = new NeuralNetwork(layers);
    }
  }


//---------------------------------------------------------------------------------


  void update() {
    update(1);
  }


//---------------------------------------------------------------------------------


  void update(int numbUpdates) {
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


  void nextGeneration() {
    ArrayList<Car> nextCars = new ArrayList<Car>();
    float totalFitness = 0;
    float totalMaleFitness = 0;
    float bestFitness = 0;

    java.util.Collections.sort(cars);
    java.util.Collections.reverse(cars);

    for(int i = 0; i < cars.size()/thanosAmount; i++) {
      if(bestFitness < cars.get(i).fitness) {
         bestFitness = cars.get(i).fitness;
      }

      if(cars.get(i).male) {
        totalMaleFitness += cars.get(i).fitness;
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
      if(sexualDimorphism && sexualReproduction) {
        Car papa = getPapa(totalMaleFitness);
        Car mommy = getMommy(totalFitness-totalMaleFitness);
        boolean male;

        if(random(1) > .5) {
          male = true;
          nextCars.add(papa.copy());

          float r = red(papa.col) + random(-255*(float)mutationRate, 255*(float)mutationRate);
          float g = green(papa.col) + random(-255*(float)mutationRate, 255*(float)mutationRate);
          float b = blue(papa.col) + random(-255*(float)mutationRate, 255*(float)mutationRate);
          nextCars.get(i).col = color(r, g, b);
        }

        else {
          male = false;
          nextCars.add(mommy.copy());

          float r = red(mommy.col) + random(-255*(float)mutationRate, 255*(float)mutationRate);
          float g = green(mommy.col) + random(-255*(float)mutationRate, 255*(float)mutationRate);
          float b = blue(mommy.col) + random(-255*(float)mutationRate, 255*(float)mutationRate);
          nextCars.get(i).col = color(r, g, b);
        }

        nextCars.get(i).male = male;
        nextCars.get(i).brain = new NeuralNetwork(papa.brain.copy(), mommy.brain.copy());
        nextCars.get(i).brain.mutate(mutationRate);
      }

      else if(sexualReproduction) {
        Car papa = getParent(totalFitness);
        Car papa2 = getParent(totalFitness);

        nextCars.add(papa.copy());
        nextCars.get(i).brain = new NeuralNetwork(papa.brain.copy(), papa2.brain.copy());
        nextCars.get(i).brain.mutate(mutationRate);

        float r = red(papa.col) + random(-255*(float)mutationRate, 255*(float)mutationRate);
        float g = green(papa.col) + random(-255*(float)mutationRate, 255*(float)mutationRate);
        float b = blue(papa.col) + random(-255*(float)mutationRate, 255*(float)mutationRate);
        nextCars.get(i).col = color(r, g, b);
      }

      else {
        Car papa = getParent(totalFitness);

        nextCars.add(papa.copy());
        nextCars.get(i).brain = papa.brain.copy();
        nextCars.get(i).brain.mutate(mutationRate);

        float r = red(papa.col) + random(-255*(float)mutationRate, 255*(float)mutationRate);
        float g = green(papa.col) + random(-255*(float)mutationRate, 255*(float)mutationRate);
        float b = blue(papa.col) + random(-255*(float)mutationRate, 255*(float)mutationRate);
        nextCars.get(i).col = color(r, g, b);
      }
      /*Car papa = getParent(totalFitness);


      if(sexualReproduction) {
        Car papa2 = getParent(totalFitness);
        nextCars.get(i).brain = new NeuralNetwork(papa.brain.copy(), papa2.brain.copy());
      }

      else {
        nextCars.get(i).brain = papa.brain.copy();
      }

      nextCars.get(i).brain.mutate(mutationRate);*/

    }

    cars.clear();

    XML generationXML = _xml.addChild("Generation");

    XML averageFitnessXML = generationXML.addChild("AverageFitness");
    averageFitnessXML.setContent(str(averageFitness));

    XML totalFitnessXML = generationXML.addChild("TotalFitness");
    totalFitnessXML.setContent(str(totalFitness));

    XML bestFitnessXML = generationXML.addChild("BestFitness");
    bestFitnessXML.setContent(str(bestFitness));

    saveXML(_xml, "Data/data" + fileIndex + ".xml");

    cars = (ArrayList<Car>) nextCars.clone();
    generation++;
    frame = 0;
  }


//---------------------------------------------------------------------------------


  Car getParent(float totalFitness) {

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


Car getPapa(float totalFitness) {

  float rand = random(totalFitness);

  for(int i = 0; i < cars.size()/thanosAmount; i++) {
    if(cars.get(i).male) {
      rand -= cars.get(i).fitness;
    }

    if(0 >= rand) {
      return cars.get(i).copy();
    }
  }

  return cars.get((int)random(cars.size()/thanosAmount));
}


//---------------------------------------------------------------------------------


Car getMommy(float totalFitness) {

  float rand = random(totalFitness);

  for(int i = 0; i < cars.size()/thanosAmount; i++) {
    if(!cars.get(i).male) {
      rand -= cars.get(i).fitness;
    }

    if(0 >= rand) {
      return cars.get(i).copy();
    }
  }

  return cars.get((int)random(cars.size()/thanosAmount));
}


//---------------------------------------------------------------------------------


  void randomize (Car[] arrMy) {
    for (int k=0; k < arrMy.length; k++) {
      int x = (int)random(0, arrMy.length);
      arrMy = swapValues(arrMy, k, x);
    }
  }


//---------------------------------------------------------------------------------


  Car[] swapValues (Car[] myArray, int a, int b) {
    Car temp=myArray[a].copy();
    myArray[a]=myArray[b].copy();
    myArray[b]=temp;
    return myArray;
  }
}
