import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

VerletPhysics2D physics;
PImage src;
PGraphics canvas;

void setup() {
  size(1280, 720);
  noiseDetail(16);

  canvas = createGraphics(width, height);
  canvas.beginDraw();
  canvas.clear();
  canvas.endDraw();

  src = loadImage("http://img.ffffound.com/static-data/assets/6/17e6131dbfbe0fd760d8152cf2ae3255d30d223f_m.jpg");
  src.loadPixels();

  physics = new VerletPhysics2D();
  physics.setDrag(0.5f);
}

void update() {
  physics.update();
  canvas.beginDraw();
  for (int i = physics.particles.size() - 1; i >= 0; i--) {
    Particle p = (Particle) physics.particles.get(i);
    p.tick();
    p.render(canvas);
    if (p.isDead) physics.removeParticle(p);
  }
  canvas.endDraw();
}

void draw() {
  background(0);
  for (int i = 0; i < 100; i++) {
    update();
  }
  image(canvas, 0, 0, width, height);
}

void mousePressed() {
  physics.addParticle(new Particle(mouseX, mouseY, 1));
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    physics.clear();
    canvas.beginDraw();
    canvas.clear();
    canvas.endDraw();
  }
  if (key == 'q') physics.clear();
  if (key == 's' || key == 'S') {
    this.save("data/output/composition-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second() + ".tif");
    this.save("/Users/criebsch/Dropbox/Public/p5/composition-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second() + ".png");
  }
}

