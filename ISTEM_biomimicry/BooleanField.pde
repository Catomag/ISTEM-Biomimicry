class BooleanField {
  float w;
  float h;

  PVector pos;

  color textColor = color(0);

  boolean outline = true;

  boolean pressed;
  boolean value;

  float coolTime = 0;
  float cool = 0;

//-------------------------------------------------------------------------------

  //Button constructor takes the message, position and size of the button
  BooleanField(PVector p, float _w, float _h) {
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
          value = !value;
        }

        else {
          pressed = false;
        }
      }

      //If mouse is not pressed
      else {
        //Set color to highlighted and the pressed boolean to false
        pressed = false;
      }
    }

    //If mouse not within button
    else {
      //Set color to normal and the pressed boolean to false
      pressed = false;
    }
  }


//-------------------------------------------------------------------------------

  //Draws the button and text
  void display() {
    if(outline) {
      strokeWeight(5);
      stroke(230);
      noFill();
    }

    else {
      noStroke();
      fill(230);
    }

    rect(pos.x, pos.y, w, h);

    if(value) {
      /*fill(textColor);
      textAlign(CENTER, CENTER);
      textSize(60);
      text("X", pos.x+(w*.5), pos.y+(h*.5));*/
      stroke(0);
      strokeWeight(5);
      line(pos.x+20, pos.y+20, (pos.x+w)-20, (pos.y+h)-20);
      line(pos.x+20, (pos.y+h)-20, (pos.x+w)-20, pos.y+20);
    }
  }
}
