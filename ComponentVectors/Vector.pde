class Vector{
  
  float xLoc;  // x-coordinate of base (as number of vector units from screen centre)
  float yLoc;  // y-coordinate of base (as number of vector units from screen centre)
  float value;  // value in vector units (not screen dimensions)
  String label;
  float dragOffsetX;  // offset from x1 (in vector units)
  float dragOffsetY;  // offset from y1 (in vector units)
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
    if ((selected)&&(bShowBearing.selected)){  // draw bearing arrow and show value
      strokeWeight(max(1, lineWeight/3));
      stroke(128);
      line(location[0], location[1], location[0], location[1]-int(2*value*scale/3));
      roundArrow(location[0], location[1], int(value*scale/3), 0.0, bearing);
      pushMatrix();
        translate(location[0], location[1]-int(value*scale/3));
        rotate(-PI/2);
        fill(0);
        textSize(height/30);
        textAlign(CENTER, BOTTOM);
        text(str(int(degrees(bearing)+0.001))+"°",0,0);
      popMatrix();
    }
    stroke(colour);
    if (selected || (axes.dragging)){
      if ((bShowComp.selected)||(axes.dragging)){  //draw component vectors and show values
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
          textAlign(CENTER, TOP);
          textSize(height/30);
          fill(xColor);
          text(String.format("%.2f", abs((value*sin(bearing-axes.bPrime))))+units,int(0.5*value*scale*sin(bearing-axes.bPrime)),height/80);
          // draw y' component vector
          stroke(yColor);
          if (cos(bearing-axes.bPrime)>0){
            drawArrow(int(value*scale*sin(bearing-axes.bPrime)),0,value*scale*cos(bearing-axes.bPrime), 0, max(1, lineWeight/2));
          }
          else{
            drawArrow(int(value*scale*sin(bearing-axes.bPrime)),0,-value*scale*cos(bearing-axes.bPrime), PI, max(1, lineWeight/2));
          }
          pushMatrix();
          fill(yColor);
            if(bearing<=PI){
              rotate(-PI/2);
              text(String.format("%.2f", abs((value*cos(bearing-axes.bPrime))))+units,
                  int(0.5*value*scale*cos(bearing-axes.bPrime)),int(value*scale*sin(bearing-axes.bPrime))+width/100);
            }
            else{
            }
          popMatrix();
        popMatrix();
      }
      
      if (selected){  //show vector details on top of screen
        textSize(height/20);
        textAlign(LEFT, TOP);
        fill(0);
        text(String.format("%.2f", value)+units+" at bearing "+str(int(degrees(bearing)+0.001))+"°T", width/6, height/30);
      }
      stroke (activeColor);
    }
    
    drawArrow(location[0], location[1], value*scale, bearing, lineWeight);
    

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
    float[] mouseLoc = new float[2];
    mouseLoc = screenToVector(x,y);
    xLoc = mouseLoc[0]-dragOffsetX;
    yLoc = mouseLoc[1]-dragOffsetY;
  }
  
  boolean click (int x, int y){  // determine if the vector has been clicked on to select/drag (middle 1/3 only)
    float[] clickLoc = new float[2];  // location of mouse click in vector units
    clickLoc=screenToVector(x,y);
    float xComp=value*sin(bearing);  // x-component of vector
    float yComp=value*cos(bearing);  // y-component of vector
    
    float r=pow(pow(xLoc-clickLoc[0],2)+pow(yLoc-clickLoc[1],2),0.5);  // distance of click from vector base
    if ((r>value/3)&&(r<2*value/3)){  // check that mouse click is between 1/3 and 2/3 of the arrow length from the base
      float m = 1/tan(bearing);  //slope of the vector
      float b = yLoc-(m*xLoc);  //y-intercept of vector
      float d = (clickLoc[0]-(clickLoc[1]-b)/m)*sin(PI/2-bearing);
            
      if (abs(d*scale)<(2*lineWeight)){
        dragOffsetX=clickLoc[0]-xLoc;
        dragOffsetY=clickLoc[1]-yLoc;
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

   void roundArrow(int xCentre, int yCentre, int radius, float startBearing, float arcAngle){
    //draw arc
    noFill();
    strokeWeight(max(1,lineWeight/3));
    pushMatrix();
      translate(xCentre, yCentre);
      rotate(1.5*PI-startBearing);
      arc(0,0, radius, radius, 0, arcAngle);
      rotate(arcAngle);
      //ellipse(radius,0,10,10);
      line(radius,0,radius*(1+min(0.25,arcAngle/4)),-radius*min(0.25,arcAngle/4));
      line(radius,0,radius*(1-min(0.25,arcAngle/4)),-radius*min(0.25,arcAngle/4));
    popMatrix();
  }

}
