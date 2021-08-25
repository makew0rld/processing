// To generate perlin offsets, the code random(perlinMaxRandom) is used.
float perlinMaxRandom = 10000;
float defaultNoiseFalloff = 0.5; // The default for the second arg of noiseDetail in Processing
int noiseLod = 4; // All calls to noiseDetail will use this many octaves

class Blob {
  PVector pos;
  PVector prevPos; // Used for non-movers only
  boolean mover;  // Does this blob move?
  
  // The proportion of (width+height)/2 that non movers jitter in from their original position
  float nonMoverRadius = 1.0/12.0;

  float ellipseOffset = 0; // For rotation of the ellipse angle

  int radius;  // Actually the height of an ellipse
  float ecc; // eccentricity/elongation of ellipse
  float circumStep;

  // Perlin offset/step variables

  float ellipseOffsetPerlinOffset;
  float ellipseOffsetPerlinStep = 0.005;
  float ellipseOffsetPerlinFalloff = defaultNoiseFalloff;
  float radiusPerlinOffset;
  float radiusPerlinStep = 0.006;
  float radiusPerlinFalloff = defaultNoiseFalloff;
  float eccPerlinOffset;
  float eccPerlinStep = 0.003;
  float eccPerlinFalloff = defaultNoiseFalloff;
  float eccPerlinScale = 1.1;  // Noise is scaled then clipped. This is like increasing contrast.
  float posXPerlinOffset;
  float posXPerlinStep = 0.01;
  float posXPerlinFalloff = defaultNoiseFalloff;
  float posYPerlinOffset;
  float posYPerlinStep = posXPerlinStep;
  float posYPerlinFalloff = posXPerlinFalloff;
  float wavePerlinOffset;
  float wavePerlinStep = 0.04;
  float wavePerlinFalloff = 0.3;

  Blob() {
    this(0, 0);
    mover = true;
  }

  // Constructor for blob that doesn't move
  Blob(float x, float y) {
    pos = new PVector(x, y);
    prevPos = new PVector(x, y);
    mover = false;

    // radius, circumStep, offsetSstep is set in update()
    
    ellipseOffsetPerlinOffset = random(perlinMaxRandom);
    radiusPerlinOffset = random(perlinMaxRandom);
    eccPerlinOffset = random(perlinMaxRandom);
    posXPerlinOffset = random(perlinMaxRandom);
    posYPerlinOffset = random(perlinMaxRandom);
    wavePerlinOffset = random(perlinMaxRandom);
  }

  void update() {
    noiseDetail(noiseLod, radiusPerlinFalloff);
    radius = int(map(noise(radiusPerlinOffset), 0, 1, ((width+height)/2)/40, ((width+height)/2)/8));
    radiusPerlinOffset += radiusPerlinStep;

    noiseDetail(noiseLod, eccPerlinFalloff);
    float i = min(max(noise(eccPerlinOffset)*eccPerlinScale, 0), 1);
    ecc = map(i, 0, 1, 0.4, 0.98);
    eccPerlinOffset += eccPerlinStep;

    // Each angle step should be about one pixel
    // So the equation is TAU/(circumference in pixels)
    // Ellipse circumference is complex to calculate, so instead
    // I calculate the perimeter of the bounding rectangle of the ellipse
    // This is a*4 + b*4
    // b is known already, as "radius" in the code
    // 'a' can be calculated as explained on https://en.wikipedia.org/wiki/Semi-major_and_semi-minor_axes
    float a = float(radius)/sqrt(1-ecc*ecc);
    circumStep = TAU/(a*4 + radius*4);

    noiseDetail(noiseLod, ellipseOffsetPerlinFalloff);
    ellipseOffset = map(noise(ellipseOffsetPerlinOffset), 0, 1, 0, TAU);
    ellipseOffsetPerlinOffset += ellipseOffsetPerlinStep;

    if (mover) {
      noiseDetail(noiseLod, posXPerlinFalloff);
      pos.x = map(noise(posXPerlinOffset), 0, 1, 0, width/2);
      posXPerlinOffset += posXPerlinStep;
      noiseDetail(noiseLod, posYPerlinFalloff);
      pos.y = map(noise(posYPerlinOffset), 0, 1, 0, height);
      posYPerlinOffset += posYPerlinStep;
    } else {
      float moveDist = ((width+height)/2) * nonMoverRadius;
      
      // Reset
      pos = new PVector(prevPos.x, prevPos.y);
      
      noiseDetail(noiseLod, posXPerlinFalloff);
      pos.x += map(noise(posXPerlinOffset), 0, 1, -moveDist, moveDist);
      posXPerlinOffset += posXPerlinStep;
      noiseDetail(noiseLod, posYPerlinFalloff);
      pos.y += map(noise(posYPerlinOffset), 0, 1, -moveDist, moveDist);
      posYPerlinOffset += posYPerlinStep;
    }

    wavePerlinOffset += wavePerlinStep;
  }

  void display() {
    fill(0);
    stroke(0);

    beginShape();

    // Start position on the circle in radians
    // The *10 happens so that the start and end of the circle
    // don't meet perfectly. The missing part is interpolated, so
    // that the randomness mismatch at 0 and TAU isn't noticed.
    float angle = circumStep*10;

    while (angle < TAU - circumStep*10) {

      // Ellipse formula from https://en.wikipedia.org/wiki/Ellipse#Polar_form_relative_to_center

      noiseDetail(noiseLod, wavePerlinFalloff);

      float r = radius / sqrt(1-pow(ecc*cos(angle+ellipseOffset), 2));
      r += map(noise(angle, wavePerlinOffset), 0, 1, -r*0.4, r*0.4);
      float x = r * cos(angle);
      float y = r * sin(angle);
      vertex(x+pos.x, y+pos.y);
      angle += circumStep;
    }
    endShape(CLOSE);
  }
}
