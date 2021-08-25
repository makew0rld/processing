float noiseOff = 0;
float step = 0.05;
int radius = 100;
float circumStep = 1.0/radius;

void setup() {
  size(300, 300);
  fill(0);
  stroke(0);
  noiseSeed(0);
}

void draw() {
  background(255);

  beginShape();

  // Start position on the circle in radians
  // The *10 happens so that the start and end of the circle
  // don't meet perfectly. The missing part is interpolated, so
  // that the randomness mismatch at 0 and TAU isn't noticed.
  float angle = circumStep*10;

  while (angle < TAU - circumStep*10) {
    float r = map(noise(angle, noiseOff), 0, 1, -20, 20) + radius;
    float x = r * cos(angle);
    float y = r * sin(angle);
    vertex(x+width/2, y+height/2);
    angle += circumStep;
  }
  noiseOff += step;

  endShape(CLOSE);
}
