import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

VerletPhysics2D physics;
ArrayList<Attractor> attractors = new ArrayList<Attractor>();
PImage src, rSrc, gSrc, bSrc;
PGraphics canvas;
PImage background;
PImage shapeSrc;
ArrayList<PVector> rPixels = new ArrayList<PVector>();
ArrayList<PVector> gPixels = new ArrayList<PVector>();
ArrayList<PVector> bPixels = new ArrayList<PVector>();

void setup() {
  canvas = createGraphics(1920, 1080);
  canvas.beginDraw();
  canvas.endDraw();
  size(floor(canvas.width), floor(canvas.height));
  background = loadImage("data/img/background.png");
  if (background.width != width || background.height != height) background.resize(width, height);
  src = loadImage("img/src.png");
  src.loadPixels();
  rSrc = loadImage("img/illustration_bizarre.jpg");
  rSrc.loadPixels();
  gSrc = loadImage("img/illustration_bizarre.jpg");
  gSrc.loadPixels();
  bSrc = loadImage("img/illustration_bizarre.jpg");
  bSrc.loadPixels();
  physics = new VerletPhysics2D();
  physics.setDrag(0.75f);
  shapeSrc = loadImage("data/img/shape.png");
  shapeSrc.loadPixels();
  for (int i = 0; i < shapeSrc.pixels.length; i++) {
    if (shapeSrc.pixels[i] == 0xFFFF0000) rPixels.add(new PVector(i % shapeSrc.width, i / shapeSrc.width));
    if (shapeSrc.pixels[i] == 0xFF00FF00) gPixels.add(new PVector(i % shapeSrc.width, i / shapeSrc.width));
    if (shapeSrc.pixels[i] == 0xFF0000FF) bPixels.add(new PVector(i % shapeSrc.width, i / shapeSrc.width));
  }
  noiseDetail(8);
}

void draw() {
  renderBackground(g, 0xFF000000);
  canvas.beginDraw();
  physics.update();
  for (int i = physics.particles.size() - 1; i >= 0; i--) {
    Particle p = (Particle) physics.particles.get(i);
    p.tick();
    p.render(canvas);
    if (p.age > p.lifetime) physics.removeParticle(p);
    if (p.x >= width - 10|| p.x <= 10 || p.y >= height - 10 || p.y <= 10) {
      physics.removeParticle(p);
    }
  }
  canvas.endDraw();
  image(canvas, 0, 0, width, height);
  for (int i = 0; i < attractors.size(); i++) {
    Attractor a = attractors.get(i);
    a.tick();
    a.render(g);
  }
  //saveFrameForVideo();
}

void addAttractor(float _x, float _y, int _behavior, boolean _isStatic) {
  Attractor a = new Attractor(new Vec2D(_x, _y), width / 4, 0, 0, _behavior, _isStatic);
  physics.addBehavior(a);
  attractors.add(a);
}

void mousePressed() {
  physics.addParticle(new Particle(mouseX, mouseY, 1, rSrc));
}

void keyPressed() {
  if (key == '1') {    
    for (int i = 0; i < 300; i++) {
      PVector p = rPixels.get(floor(random(rPixels.size())));
      //addParticle(p.x, p.y, rSrc);
    }
  }
  if (key == '2') {    
    for (int i = 0; i < 300; i++) {
      PVector p = gPixels.get(floor(random(gPixels.size())));
     // addParticle(p.x, p.y, gSrc);
    }
  }
  if (key == '3') {    
    for (int i = 0; i < 300; i++) {
      PVector p = bPixels.get(floor(random(bPixels.size())));
      //addParticle(p.x, p.y, bSrc);
    }
  }
  if (key == 'a' || key == 'A') addAttractor(0, 0, 1, false);
  if (key == 'r' || key == 'R') addAttractor(0, 0, -1, false);
  if (key == 'c' || key == 'C') {
    canvas.beginDraw();
    canvas.clear();
    canvas.endDraw();
    physics.clear();
    attractors.clear();
  }
  if (key == ' ') attractors.clear();
  if (key == 'q') physics.clear();
  if (key == 's' || key == 'S') {
//    PGraphics img = createGraphics(canvas.width, canvas.height, P2D);
//    img.beginDraw();
//    renderBackground(img, 0xFF000000);
//    img.image(canvas, 0, 0);
//    img.endDraw();
    this.save("data/output/composition-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second() + ".tif");
    this.save("/Users/riebschlager/Dropbox/Public/p5/composition-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second() + ".png");
  }
}

void renderBackground(PGraphics context, int _color) {
  context.background(_color);
}

void renderBackground(PGraphics context, PImage _image) {
  context.background(_image);
}

void saveFrameForVideo() {
  String fileName = nf(frameCount, 5) + ".tif";
  saveFrame("data/video/" + fileName);
}

