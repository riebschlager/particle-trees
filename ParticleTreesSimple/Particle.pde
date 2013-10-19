class Particle extends VerletParticle2D {

  int pixel1, pixel2;
  float radiusNoise, colorNoise, xNoise, yNoise;
  float age;
  boolean isDead;
  ParticleBehavior pb;

  public Particle(float _x, float _y, int _behavior) {
    super(_x, _y);
    radiusNoise = random(1000);
    colorNoise = random(1000);
    xNoise = random(1000);
    yNoise = random(1000);
    age = 1;
    pixel1 = src.pixels[round(random(src.pixels.length - 1))];
    pixel2 = src.pixels[round(random(src.pixels.length - 1))];
    isDead = false;
    pb = new ParticleBehavior(ParticleBehavior.DEFAULT);
  }

  public void tick() {
    radiusNoise += pb.radiusStep;
    colorNoise += pb.colorStep;
    xNoise += pb.xStep;
    yNoise += pb.yStep;
    age++;
    float vx = map(noise(xNoise), 0, 1, pb.fxMin, pb.fxMax);
    float vy = map(noise(yNoise), 0, 1, pb.fyMin, pb.fyMax);
    addForce(new Vec2D(vx, vy));
    if (random(1) > 0.999 && physics.particles.size() < 100) {
      Particle p = new Particle(x, y, ParticleBehavior.DEFAULT);
      physics.addParticle(p);
    }
    if (x > width || x < 0 || y > height || y < 0 || age > pb.lifetime) {
      isDead = true;
    }
  }

  public void render(PGraphics _canvas) {
    float x1 = map(x, 0, width, 0, _canvas.width);
    float y1 = map(y, 0, height, 0, _canvas.height);
    _canvas.noStroke();
    if (pb.strokeWeight > 0) {
      _canvas.strokeWeight(pb.strokeWeight);
      _canvas.stroke(pb.strokeColor);
    }
    _canvas.fill(lerpColor(pixel1, pixel2, noise(colorNoise)));
    float r = map(noise(radiusNoise), 0, 1, pb.minRadius, pb.maxRadius);
    r = r - (r * (age / pb.lifetime));
    _canvas.ellipse(x1, y1, r, r);
  }
}

