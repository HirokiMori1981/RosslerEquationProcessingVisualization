int[] HSVtoRGB(int h, int s, int v) {
  // hue = 0 to 360
  // saturation = 0 to 255
  // value = 0 to 255
  float f;
  int i, p, q, t;
  int[] rgb = new int[3];

  i = (int)Math.floor(h / 60.0f) % 6;
  f = (float)(h / 60.0f) - (float)Math.floor(h / 60.0f);
  p = (int)Math.round(v * (1.0f - (s / 255.0f)));
  q = (int)Math.round(v * (1.0f - (s / 255.0f) * f));
  t = (int)Math.round(v * (1.0f - (s / 255.0f) * (1.0f - f)));

  switch(i) {
  case 0 : 
    rgb[0] = v; 
    rgb[1] = t; 
    rgb[2] = p; 
    break;
  case 1 : 
    rgb[0] = q; 
    rgb[1] = v; 
    rgb[2] = p; 
    break;
  case 2 : 
    rgb[0] = p; 
    rgb[1] = v; 
    rgb[2] = t; 
    break;
  case 3 : 
    rgb[0] = p; 
    rgb[1] = q; 
    rgb[2] = v; 
    break;
  case 4 : 
    rgb[0] = t; 
    rgb[1] = p; 
    rgb[2] = v; 
    break;
  case 5 : 
    rgb[0] = v; 
    rgb[1] = p; 
    rgb[2] = q; 
    break;
  }

  return rgb;
}