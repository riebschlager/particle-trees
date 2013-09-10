class Particle extends VerletParticle2D {

  int pixel1, pixel2;
  float radiusNoise, colorNoise, xNoise, yNoise;
  float maxRadius;
  float age, lifetime;
  float radiusStep, colorStep, xStep, yStep;
  float fxMin, fxMax, fyMin, fyMax;
  int strokeColor, behavior;
  float strokeWeight, fillAlpha;
  PImage colorSource;

  public Particle(float _x, float _y, int _behavior, PImage _colorSource) {
    super(_x, _y);
    radiusNoise = random(1000);
    colorNoise = random(1000);
    xNoise = random(1000);
    yNoise = random(1000);
    age = 1;
    setBehavior(_behavior);
    pixel1 = _colorSource.pixels[round(random(_colorSource.pixels.length - 1))];
    pixel2 = _colorSource.pixels[round(random(_colorSource.pixels.length - 1))];
    colorSource = _colorSource;
  }

  public void setBehavior(int _index) {
    behavior = _index;
    switch(_index) {
    case 1:    
      maxRadius = 100;
      lifetime = 3000;
      radiusStep = 0.005;
      colorStep = 0.025;
      xStep = 0.0005;
      yStep = 0.0005;
      fxMin = -0.25;
      fxMax = 0.25;
      fyMin = -0.25;
      fyMax = 0.25;
      strokeWeight = 0.5;
      strokeColor = 0x22000000;
      fillAlpha = 100;
      break;
    case 2:
      maxRadius = random(5, 10);
      lifetime = random(10, 500);
      radiusStep = 0.035;
      colorStep = 0.005;
      xStep = 0.05;
      yStep = 0.05;
      fxMin = -1;
      fxMax = 1;
      fyMin = -1;
      fyMax = 1;
      strokeWeight = 0.25;
      strokeColor = 0x44000000;
      fillAlpha = 90;
      break;
    case 3:    
      maxRadius = random(5, 10);
      lifetime = random(10, 100);
      radiusStep = 0.005;
      colorStep = 0.005;
      xStep = 0.005;
      yStep = 0.005;
      fxMin = -1;
      fxMax = 1;
      fyMin = -1;
      fyMax = 1;
      strokeWeight = 0.25;
      strokeColor = 0x44000000;
      fillAlpha = 90;
      break;
    default:
      maxRadius = 10;
      lifetime = 100;
      radiusStep = 0.05;
      colorStep = 0.05;
      xStep = 0.005;
      yStep = 0.005;
      fxMin = -1;
      fxMax = 0;
      fyMin = -1;
      fyMax = 1;
      strokeWeight = 0;
      strokeColor = 0xFF000000;
      fillAlpha = 255;
      break;
    }
  }

  public void tick() {
    radiusNoise += radiusStep;
    colorNoise += colorStep;
    xNoise += xStep;
    yNoise += yStep;
    age++;
    float vx = map(noise(xNoise), 0, 1, fxMin, fxMax);
    float vy = map(noise(yNoise), 0, 1, fyMin, fyMax);
    Vec2D vv = new Vec2D(vx, vy);
    addForce(vv);
    if (random(1) > 0.99 && physics.particles.size() < 500) {
      for (int i = 0; i < 5; i++) {
        Particle p = new Particle(x, y, behavior, colorSource);
        float r = map(noise(radiusNoise), 0, 1, maxRadius / 2, maxRadius);
        r = r - (r * (age/lifetime));
        p.maxRadius = r;
        p.lifetime = this.lifetime / 1.5;
        p.xStep = xStep * 2.5;
        p.yStep = yStep * 1.5;
        p.fxMin = fxMin * 1.15;
        p.fxMax = fxMax * 1.15;
        p.fyMin = fyMin * 1.15;
        p.fyMax = fyMax * 1.15;
        physics.addParticle(p);
      }
    }
  }

  public void render(PGraphics _canvas) {
    float x1 = map(x, 0, width, 0, _canvas.width);
    float y1 = map(y, 0, height, 0, _canvas.height);
    _canvas.noStroke();
    if (strokeWeight > 0) {
      _canvas.strokeWeight(strokeWeight);
      _canvas.stroke(strokeColor);
    }
    int c = src.get((int) x1, (int) y1);
    if(c == 0xFFFFFFFF) _canvas.fill(pixel1);
    else _canvas.fill(pixel2,1);
    //_canvas.fill(lerpColor(pixel1,0xFF000000,map(brightness(c),0,255,0.4,1.0)));
    //_canvas.fill(lerpColor(c, pixel2, noise(colorNoise)));
    //_canvas.fill(c, fillAlpha);
    //if (c == 0xFF000000) {
    //_canvas.fill(lerpColor(pixel1, pixel2, noise(colorNoise)));
    //}
    float r = map(noise(radiusNoise), 0, 1, maxRadius / 2, maxRadius);
    r = r - (r * (age/lifetime));
    if (getVelocity().magnitude() < 0.1) {
      _canvas.noStroke();
      _canvas.noFill();
    }
    _canvas.ellipse(x1, y1, r, r);
  }
}

