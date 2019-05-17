

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


  void mutate(double mutationRate) {
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


  NeuralNetwork crossover(NeuralNetwork partner) {
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


  NeuralNetwork copy() {
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
    float size = 3.3;

    stroke(255);
    strokeWeight(size);
    fill(0);

    for (int layer = 1; layer < layers.length; layer++) {
      for (int neuron = 0; neuron < layers[layer]; neuron++) {
        for (int prevNeuron = 0; prevNeuron < layers[layer-1]; prevNeuron++) {

          float x = 25*size + (layer*50*size) + ((width*.5) - (layers.length*50*.5*size));
          float y = 15*size + (neuron*30*size) + ((width*.5) - (layers[layer]*.5*30*size));

          float x2 = 25*size + ((layer-1)*50*size) + ((width*.5) - (layers.length*50*.5*size));
          float y2 = 15*size + (prevNeuron*30*size) + ((width*.5) - (layers[layer-1]*.5*30*size));

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

        float x = 25*size + (layer*50*size) + ((width*.5) - (layers.length*50*.5*size));
        float y = 15*size + (neuron*30*size) + ((width*.5) - (layers[layer]*.5*30*size));
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


  double[] createArray(int size, double value) {
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


  double[] createRandomArray(int size, double min, double max) {
    if (size < 1) {
      return null;
    }

    double[] result = new double[size];

    for (int i = 0; i < size; i++) {
      result[i] = (double) (random((float)(min*1000), (float)(max*1000))*.001);
    }

    return result;
  }


//---------------------------------------------------------------------------------


  double[][] createRandomArray(int size1, int size2, double min, double max) {
    if (size1 < 1) {
      return null;
    }

    double[][] result = new double[size1][size2];

    for (int i = 0; i < size1; i++) {
      for (int j = 0; j < size2; j++) {
        result[i][j] = (double) (random((float)(min*1000), (float)(max*1000))*.001);
      }
    }

    return result;
  }


//---------------------------------------------------------------------------------


  double[] copyArray(double[] b) {
    double[] a = new double[b.length];
    for(int i = 0; i < b.length; i++) {
      a[i] = b[i];
    }

    return a;
  }


//---------------------------------------------------------------------------------


  double[][] copyArray(double[][] b) {
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
