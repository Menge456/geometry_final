ArrayList<Float[]> dots = new ArrayList<Float[]>();
int mode = 0; // 0 is new dots, 1 is flipping, and I'll probs add one for circles later
ArrayList<InCircle> circles = new ArrayList<InCircle>();
int whichCirc = 0;
int newRad = 20;


void setup() {
  size(1200, 800);
  circles.add(0, new InCircle(600, 400, 30));
  ellipseMode(CENTER);
}


void draw() {
  newDot();
  background(255, 255, 255);
  strokeWeight(50);
  fill(0, 0, 0);
  text(newRad, 100, 100);
  strokeWeight(2);
  for (InCircle in : circles) {
    in.drawCirc();
  }
  strokeWeight(10);
  for (int i = 0; i < dots.size(); i++) {
    Float[] dot = dots.get(i);
    point(dot[0], dot[1]);
  }
}
void keyPressed() {
  if (keyCode == SHIFT) {
    mode = 1;
  }
  if (key == ENTER) {
    circles.get(whichCirc).findInverses();
  }
  if (key == ' ') {
    circles.add(new InCircle(mouseX, mouseY, newRad));
  }

  if (keyCode == LEFT) {
    newRad -= 10;
    if (newRad < 0) {
      newRad = 0;
    }
  }

  if (keyCode == RIGHT) {
    newRad +=10;
  }
}
void keyReleased() {
  if (keyCode == SHIFT || key == ' ') {
    mode = 0;
  }
  if (key == BACKSPACE) {
    dots = new ArrayList<Float[]>();
    circles = new ArrayList<InCircle>();
    whichCirc = 0;
  }

  if (keyCode == UP) {
    whichCirc += 1;
    if (whichCirc >= circles.size()) {
      whichCirc = 0;
    }
  }
  if (keyCode == DOWN) {
    whichCirc -= 1;
    if (whichCirc < 0) {
      whichCirc = circles.size() - 1;
    }
  }
}

void newDot() {
  if (mousePressed) {
    Float[] newDot = {float(mouseX), float(mouseY)};
    dots.add(newDot);
  }
}

class InCircle {
  float xpos, ypos;
  float rad;
  float radSq;
  boolean thisCirc;

  InCircle (float x, float y, float rat) {
    xpos = x;
    ypos = y;
    rad = rat;
    radSq = rat*rat;
    thisCirc = false;
  }

  void drawCirc() {
    if (circles.get(whichCirc) == this) {
      fill(255, 0, 0);
    } else {
      fill(255, 255, 255);
    }
    circle(xpos, ypos, rad*2);
  }

  void findInverses() {
    for (int i = 0; i < dots.size(); i++) { // doing this for all dots
      Float[] dot = dots.get(i); // finds the dot we're looking at
      dot[0] = dot[0] - xpos;
      dot[1] = dot[1] - ypos;
      float len = (float) (Math.sqrt((double)
        ((dot[0] * dot[0]) + (dot[1] * dot[1]))

        )); // this is supposed to be the pythagorean theorem
      float newLen = radSq/len; // OP' = r^2/ OP, we need to find OP'
      float angle = atan(dot[1]/dot[0]); // angle from the circle of the new length

      int xNeg = 1;
      int yNeg = 1;
      if (dot[0] < 0) {
        xNeg *= -1;
        yNeg *= -1;
      }


      Float[] setDot = {xpos + (newLen * xNeg * cos(angle)), ypos + (newLen * yNeg* sin(angle))};

      dots.set(i, setDot);
    }
  }
}
