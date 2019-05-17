class Button {
  float w;
  float h;

  String text;
  PVector pos;

  color normal = #c3c3c3;
  color highlighted = #817a7a;
  color pressedColor = #585252;
  color currentColor;

  color textColor = color(0);

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
  void update() {

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
  void display() {
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
    text(text, pos.x+(w*.5), pos.y+(h*.5));
  }


//-------------------------------------------------------------------------------
}
