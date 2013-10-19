class ParticleBehavior {

  public static final int DEFAULT = 0;

  float minRadius, maxRadius;
  float lifetime;
  float radiusStep, colorStep, xStep, yStep;
  float fxMin, fxMax, fyMin, fyMax;
  int strokeColor;
  float strokeWeight, fillAlpha;

  public ParticleBehavior(int type) {
    switch(type) {
      case(DEFAULT):
      minRadius = 1.0f;
      maxRadius = 10.0f;
      lifetime = random(10, 500);
      radiusStep = 0.075f;
      colorStep = 0.075f;
      xStep = random(-0.00725f,0.00725f);
      yStep = random(-0.00725f,0.00725f);
      fxMin = -1f;
      fxMax = 1f;
      fyMin = -1f;
      fyMax = 1f;
      strokeWeight = 1.0f;
      strokeColor = 0x22000000;
      fillAlpha = 100.0f;
      break;
    }
  }
}

