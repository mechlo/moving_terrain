import themidibus.*; //Import the library

float cc[] = new float[256];

MidiBus myBus; // The MidiBus

int cols, rows;
int scl = 20;
int w = 5000;
int h = 1600;

//gradients
int Y_AXIS = 1;
int X_AXIS = 2;
color b1, b2, c1, c2;

float flying = 0;

float[][] terrain;

void setup() {
  fullScreen(P3D);
  cols = w / scl;
  rows = h / scl;
  terrain = new float[cols][rows];
  
    // Define colors for gradient
  b1 = color(255);
  b2 = color(0);
  c1 = color(204, 102, 0);
  c2 = color(0, 102, 153);
  
  MidiBus.list();
  myBus = new MidiBus(this,0,1);
}

void draw() {

  //image colors
  background(cc[21]*255,cc[22]*255,cc[23]*255);
  
  //grandient background
  //setGradient(0, 0, width/2, height, b1, b2, X_AXIS);
  //setGradient(width/2, 0, width/2, height, b2, b1, X_AXIS);
  stroke(cc[24]*255,cc[25]*255,cc[26]*255);
  noFill();

  
  flying += (-cc[43]*.2);
  float yoff = flying;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) { 
      terrain[x][y] = map(noise(xoff,yoff), 0, 1, cc[41]*200, cc[42]*200);
      xoff += 0.2;
    }
    yoff += 0.2;
    }
    

  
  translate(width/2,height/2);
  rotateX(PI/3);
  
  //move center of terrain
  translate(-w/2,-h/2+50);
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {   
      vertex(x*scl, y*scl, terrain[x][y]);
      vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
      //rect(x*scl, y*scl, scl, scl);
    }
    endShape();
  }
}


void controllerChange(int channel, int number, int value){

  println("value:" +value);
  println("number:" +number);
  println("channel:" +channel);
  cc[number] = map(value, 0, 127, 0, 1);

}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}