class Vector{
  
  float xLoc;  // x-coordinate of base (as number of vector units from screen centre)
  float yLoc;  // y-coordinate of base (as number of vector units from screen centre)
  float value;  // value in vector units (not screen dimensions)
  String label;
  float stringOffsetX;  // offset from x1 (in vector units)
  float stringOffsetY;  // offset from y1 (in vector units)
  boolean dragging=false;  // true if being dragged to relocate
  boolean selected=true;  // if currently the selected vector (true when first created)
  boolean forming=true;  // if still being created (true when first created)
  float bearing;  // in radians clockwise from straight up
  //float xComp;
  //float yComp;
  color colour;  // display colour
  
  Vector(int x, int y){
    // Transfer to class-wide variables
    float[] tempArray = new float[2];
    tempArray=screenToVector(x,y);
    xLoc=tempArray[0];
    yLoc=tempArray[1];
    colour=baseColor;  //default to base colour
  } 
  
  void display(){
    int[] location = new int[2];
    location=vectorToScreen(xLoc, yLoc);
    //testDebug=str(degrees(bearing));
    stroke(colour);
    pushMatrix();
      if (selected || (axes.dragging)){
        if (showComponents){
          //strokeWeight(max(1, lineWeight/2));
          pushMatrix();
            translate(location[0], location[1]);
            rotate(axes.bPrime);
            stroke(xColor);
            // draw x' component vector
            if (sin(bearing-axes.bPrime)<0){
              drawArrow(0,0,-value*scale*sin(bearing-axes.bPrime), 3*PI/2, max(1, lineWeight/2));
            }
            else{
              drawArrow(0,0,value*scale*sin(bearing-axes.bPrime), PI/2, max(1, lineWeight/2));
            }
            // draw y' component vector
            stroke(yColor);
            if (cos(bearing-axes.bPrime)>0){
              drawArrow(int(value*scale*sin(bearing-axes.bPrime)),0,value*scale*cos(bearing-axes.bPrime), 0, max(1, lineWeight/2));
            }
            else{
              drawArrow(int(value*scale*sin(bearing-axes.bPrime)),0,-value*scale*cos(bearing-axes.bPrime), PI, max(1, lineWeight/2));
            }
          popMatrix();
        }
        textSize(20);
        fill(0);
        text(str(xLoc)+", "+str(yLoc),location[0], location[1]+20);
        stroke (activeColor);
      }
      drawArrow(location[0], location[1], value*scale, bearing, lineWeight);

    popMatrix();
   // text(str(xLoc)+", "+str(yLoc),50,50);
  }
  
  void create (int x, int y){  // create a new vector by clicking and dragging
    float xComp;  // local variables
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
  
  boolean click (int x, int y){  // determine if the vector has been clicked on to select/drag (middle 1/3 only)
    float[] clickLoc = new float[2];  // location of mouse click in vector units
    clickLoc=screenToVector(x,y);
    float xComp=value*sin(bearing);  // x-component of vector
    float yComp=value*cos(bearing);  // y-component of vector

    if((clickLoc[0]>(xLoc+xComp/3))&&(clickLoc[0]<(xLoc+2*xComp/3))&&(clickLoc[1]>(yLoc+yComp/3))&&(clickLoc[1]<(yLoc+2*yComp/3))){  //check to make sure in a box around middle 1/3 of the vector
      //rect(20,20,100,100);
      testDebug="found one";  //
      float m = 1/tan(bearing);  //slope of the vector
      float b = yLoc-(m*xLoc);  //y-intercept of vector
      float d = (clickLoc[0]-(clickLoc[1]-b)/m)*sin(PI/2-bearing);
      
      if (d*scale<(4*lineWeight)){
        
        dragging=true;
        selected=true;
        return true;
      }
    }
    return false;
  }
  
  void drawArrow(int x1, int y1, float arrowLength, float angle, int weight){
    angle=angle-PI/2;  // convert to due east starting point (as per Processing convention)
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
      if (deltaY>0) angle=0;
      else angle=PI;
    }
    else {
      angle=atan(deltaX/deltaY);
      if (deltaY<0) angle=angle+PI;
      if (angle<0) angle=angle+2*PI;
      //angle=angle-PI/2;
    }
    
    return angle;
  }
  
  float[] screenToVector(int xScreen, int yScreen){  // convert a screen location (x and y from top left) to a grid location in vector units from a centre origin
      float[] coordinatesOut = new float[2];
      coordinatesOut[0] = (xScreen-width/2)/scale;
      coordinatesOut[1] = (-yScreen+height/2)/scale;
      return coordinatesOut;
  }
  
  int[] vectorToScreen (float xVect, float yVect){  // grid location in vector units to screen location in pixels
    int[] screenOut = new int[2];
    screenOut[0] = int(xVect*scale)+width/2;
    screenOut[1] = int(-yVect*scale)+height/2;
    return screenOut;
  }

}
