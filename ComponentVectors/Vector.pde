class Vector{
  
  float xLoc;  // x-coordinate of base (as number of vector units from screen centre)
  float yLoc;  // y-coordinate of base (as number of vector units from screen centre)
  float value;  // value in vector units (not screen dimensions)
  String label;
  float stringOffsetX;  // offset from x1 (in vector units)
  float stringOffsetY;  // offset from y1 (in vector units)
  boolean dragging=false;
  boolean selected=true;  // if currently the selected vector (true when first created)
  boolean forming=true;  // if still being created (true when first created)
  float bearing;  // in radians clockwise from straight up
  //float xComp;
  //float yComp;
  color colour;  // display colour
  
  Vector(int x, int y){
    // Transfer to class-wide variables
    float[] tempArray = new float[2];
    tempArray=screenToVector(x, y);
    xLoc=tempArray[0];
    yLoc=tempArray[1];
  } 
  
  void display(){
    int[] location = new int[2];
    location=vectorToScreen(xLoc, yLoc);
    stroke(colour);
    pushMatrix();
    translate(width/2, height/2);
      if (selected){
        if (showComponents){
          //strokeWeight(max(1, lineWeight/2));
          pushMatrix();
            translate(location[0], location[1]);
            rotate(upAngle);
            stroke(0,0,255);
            // draw x' component vector
            if (sin(bearing-upAngle)<0){
              drawArrow(0,0,-value*scale*sin(bearing-upAngle), 3*PI/2, max(1, lineWeight/2));
            }
            else{
              drawArrow(0,0,value*scale*sin(bearing-upAngle), PI/2, max(1, lineWeight/2));
            }
            // draw y' component vector
            if (cos(bearing-upAngle)>0){
              drawArrow(int(-value*scale*sin(bearing-upAngle)),0,value*scale*cos(bearing-upAngle), 0, max(1, lineWeight/2));
            }
            else{
              drawArrow(int(-value*scale*sin(bearing-upAngle)),0,-value*scale*cos(bearing-upAngle), PI, max(1, lineWeight/2));
            }
          popMatrix();
        }
        stroke (255,0,0);
      }
      drawArrow(location[0], location[1], value*scale, bearing, lineWeight);
    popMatrix();
  }
  
  void create (int x, int y){  // create a new vector by clicking and dragging
    float xComp;  // local variiables
    float yComp;  // components parallel to x and y axes for the screen only.
    float tempPoint[] = new float[2];
    tempPoint = screenToVector(x,y);
    xComp=tempPoint[0]-xLoc;
    yComp=tempPoint[1]-yLoc;
    value=pow(pow(xComp,2)+pow(yComp,2),0.5);
    bearing=findBearing(xComp, yComp);
  }
  
  void move (int x, int y){  // move a vector by dragging
    
  }
  
  void click (int x, int y){  // determine if the vector has been clicked on to select/drag (ignore 20% of length at each end)
    
  }
  
  void drawArrow(int x1, int y1, float arrowLength, float angle, int weight){
    angle=angle+PI/2;  // convert to due east starting point (as per Processing convention)
    strokeWeight(weight);
    pushMatrix();
      translate(x1, y1);
      rotate(angle);
      line(0,0,arrowLength, 0);
      line(arrowLength, 0, arrowLength - min(10, arrowLength/3), -min(10, arrowLength/3));
      line(arrowLength, 0, arrowLength - min(10, arrowLength/3), min(10,arrowLength/3));
    popMatrix();
  }
  
  float findBearing(float deltaX, float deltaY){
    float angle;
    if (deltaX==0){
      if (deltaY<0) angle=0;
      else angle=PI;
    }
    else {
      angle=atan(-deltaY/deltaX);
      if (deltaX<0) angle=angle+PI;
      angle=angle-PI/2;
    }
    
    return angle;
  }
  
  float[] screenToVector(int xScreen, int yScreen){  // convert a screen location to a grid location in vector units
      float[] coordinatesOut = new float[2];
      coordinatesOut[0] = xScreen/scale;
      coordinatesOut[1] = -yScreen/scale;
      return coordinatesOut;
  }
  
  int[] vectorToScreen (float xVect, float yVect){  // grid location in vector units to screen location in pixels
    int[] screenOut = new int[2];
    screenOut[0] = int(xVect*scale)-width/2;
    screenOut[1] = int(-yVect*scale)-height/2;
    return screenOut;
  }

}
