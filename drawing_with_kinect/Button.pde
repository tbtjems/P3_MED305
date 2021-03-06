class Button {
  // variables
  int x, y, bWidth, bHeight;
  boolean isEraser, isToolbarButton;
  boolean hasEnteredEraser = false, hasEnteredToolbarButton = false;
  PImage image;

  // constructor
  Button(int _x, int _y, int _bWidth, int _bHeight, boolean _isEraser, boolean _isToolbarButton, PImage _image) {
    this.x = _x;
    this.y = _y;
    this.bWidth = _bWidth;
    this.bHeight = _bHeight;
    this.isEraser = _isEraser;
    this.isToolbarButton = _isToolbarButton;
    this.image = _image;
  }

  void update() {
    this.display(); // show the button
    this.calculateCenterOfMass();
    if (this.centerOfMassInsideHitbox()) {
      if (this.isToolbarButton) {
        if (!hasEnteredToolbarButton) {
          showToolbar = !showToolbar;
          hasEnteredToolbarButton = true;
        }
      }
      else if (this.isEraser) {
        if (!hasEnteredEraser) {
          isErasing = !isErasing;
          hasEnteredEraser = true;
          if(isErasing) {
            previousColor = currentDrawingColor;
            currentDrawingColor = backgroundColor;
          } else {
            currentDrawingColor = previousColor;
          }
        }
      }
    }
    else {
      hasEnteredEraser = false;
      hasEnteredToolbarButton = false;
    }
  }

  void display() {
    image(this.image, this.x, this.y, this.bWidth, this.bHeight);
  }

  boolean isInsideHitbox(float x, float y) {
    if (x > this.x && x < (this.x + this.bWidth) &&
      y > this.y && y < (this.y + this.bHeight)) {
      return true;
    } else return false;
  }

  boolean centerOfMassInsideHitbox() {
    if (centerOfMass_x > this.x && centerOfMass_x < (this.x + this.bWidth) &&
      centerOfMass_y > this.y && centerOfMass_y < (this.y + this.bHeight)) {
      return true;
    } else return false;
  }
  
  void calculateCenterOfMass() {
    if (isMouseControlled) { 
      centerOfMass_x = mouseX;
      centerOfMass_y = mouseY;
      return;
    }
    int numberCoordinatesSilhouette = 0; // the number of coordinates of the silhouette that are inside of this button's hitbox
    int xSum = 0, ySum = 0;
    for (int i = 0; i < xSilhouetteCoordinates.size(); i++) {
      if (isInsideHitbox(xSilhouetteCoordinates.get(i), ySilhouetteCoordinates.get(i))) {
        xSum += xSilhouetteCoordinates.get(i);
        ySum += ySilhouetteCoordinates.get(i);
        numberCoordinatesSilhouette++;
      }
    }
    // to avoid dividing by zero, and to avoid noise, check if the number of coordinates in the silhouette is higher number than this value
    if (numberCoordinatesSilhouette > noiseFilter) {
      centerOfMass_x = xSum / numberCoordinatesSilhouette;
      centerOfMass_y = ySum / numberCoordinatesSilhouette;
      numberCoordinatesSilhouette = 0;
    }
  }
}
