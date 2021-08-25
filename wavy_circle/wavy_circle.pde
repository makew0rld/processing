float amp = 10;
float freq = 20;
float off = 0;
float offStep = 0.01;
int radius = 100;

// You only need one step per pixel.
// The number of a pixels needed for a circle is the circumference
// Which is TAU*r
// So the number of steps is TAU/(TAU*r) which equals 1/r
float circumStep = 1.0/radius; 

void setup() {
  size(300, 300);
  fill(0);
  stroke(0);
}

void draw() {
  background(255);

  beginShape();

  float angle = 0; // Start position on the circle in radians

  while (angle < TAU) {
    float x = (sin((angle+off)*freq)*amp + radius) * cos(angle);
    float y = (sin((angle+off)*freq)*amp + radius) * sin(angle);
    vertex(x+width/2, y+height/2);
    angle += circumStep;
  }
  off += offStep;

  endShape(CLOSE);
}
