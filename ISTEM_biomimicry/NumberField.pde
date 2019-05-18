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

    up = new Button(new PVector(pos.x+w, pos.y), w/2, w/2);

    up.normal = color(random(50,255), random(50,255), random(50,255));
    up.highlighted = color(random(25,200), random(25,200), random(25,200));
    up.pressedColor = color(random(10,150), random(10,150), random(10,150));

    up.outline = false;
    up.cool = 120;
    up.text = "▲";

    down = new Button(new PVector(pos.x+w, pos.y+(w/2)), w/2, w/2);

    down.normal = color(random(50,255), random(50,255), random(50,255));
    down.highlighted = color(random(25,200), random(25,200), random(25,200));
    down.pressedColor = color(random(10,150), random(10,150), random(10,150));

    down.outline = false;
    down.cool = 120;
    down.text = "▼";
  }


//---------------------------------------------------------------------------------


  void display() {
    noStroke();
    fill(230);
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


  void update() {
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
