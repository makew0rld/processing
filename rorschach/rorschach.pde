Blob[] blobs = new Blob[9];


void setup() {
  size(600, 800);
  stroke(0);
  fill(0);
  
  // Eyes
  blobs[0] = new Blob(width*0.30, height*0.25);
  // Mouth
  blobs[1] = new Blob(width/2, height*0.75);
  // Nose
  blobs[2] = new Blob(width/2, height/2);
  
  for (int i = 3; i < blobs.length; i++) {
    blobs[i] = new Blob();
  }
}

void draw() {
  background(255);
  
  for (int i = 0; i < blobs.length; i++) {
    blobs[i].update();
    blobs[i].display();
  }
  hSymmetry();
}

void hSymmetry() {
  loadPixels();
  for (int x = width/2; x < width; x++) {
    for (int y = 0; y < height; y++) {
      pixels[x+y*width] = color(pixels[(width-x)+y*width]);
    }
  }
  updatePixels();
}
