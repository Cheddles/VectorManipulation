class AxisAngle{
  int xPos;  // x-coordinate of top right corner
  int yPos;  // y-coordinate of top right corner
  float bPrime=0;  // offset angle (clockwise from straight up)
  float oldAngle;  // previous bPrime (to be used if angle change is cancelled
  boolean selected=false;  // shows and adjustable only when selected
  boolean dragging=false;
  boolean clickedOnce=false;  // if this control has been clicked once (to display control instructions)
  float dragOffset;  // the angle offset when the mouse is clicked to drag
  String xLabel="x";
  String yLabel="y";
  
  AxisAngle(){
  }
  
  void display(){
    xPos=int(width*0.98);
    yPos=int(height*0.02);
    if (selected){  // mute vectors and display angle adjustment tool (with done and cancel buttons)
      fill(255,255,255,180);
      strokeWeight(0);
      rect(0,0,width,height);
      drawRotator();
    }
    drawSelect();  // display button to select this tool
    
//  // show rotate instruction if not rotated yet
//    if (!clickedOnce){
//      pushMatrix();
//        translate(xCentre-(diameter*0.6),yCentre);
//        rotate(PI*1.5);
//        textSize (diameter/12);
//        textAlign(CENTER, CENTER);
//        fill(127);
//        text("drag shape to rotate", 0, 0);
//      popMatrix();
//    }
  }
  
  boolean clicked(int mx, int my) {
    boolean returnValue;
    int radius=min(height/4,width/6);
    if (selectedPressed(mx, my)){
      returnValue = true;
      if (!selected){
          selected = true;
          clickedOnce=true;
      }
      else{
        selected=false;
      }
    }
    else if (selected&&(turningPressed(mx, my))) {  // if selected, check for rotation
      returnValue = true;
      dragging=true;
      oldAngle=bPrime;
      dragOffset = findAngle(mx-(xPos-radius), my-(yPos+radius))-bPrime;
      if (dragOffset<0) dragOffset=dragOffset+(2*PI);
      if (dragOffset>(2*PI)) dragOffset=dragOffset-(2*PI);
    }
    else returnValue = false;
    
    return returnValue;
  }
  
  void drag() {
    if (dragging){
      int radius=min(height/4,width/6);
      bPrime = findAngle(mouseX-(xPos-radius), mouseY-(yPos+radius)) - dragOffset;
      bPrime = radians(float(int(degrees(bPrime))));
      if (bPrime>(2*PI)) bPrime=bPrime-(2*PI);
      if (bPrime<0) bPrime=bPrime+(2*PI);
    }
  }
  
  // inverse tangent function with correction for angles outside the first quadrant.
  float findAngle(int x, int y){
    float clickAngle = atan(float(y)/float(x));
    if (x<0) clickAngle = clickAngle+PI;
    if (clickAngle>(2*PI)) clickAngle=clickAngle-(2*PI);
    if (clickAngle<0) clickAngle=clickAngle+(2*PI);
    return clickAngle;
  }
  
  void drawSelect(){  //draw button to select the tool
    int radius=max(height/40,15);
    strokeWeight(max(1,lineWeight/3));
    stroke(0);
    fill(255,255,255,0);
    pushMatrix();
      translate(xPos-radius, yPos+radius);
      rotate(bPrime);
      stroke(xColor);
      line(-radius,0, radius, 0);
      ellipse(radius,0, max(1,lineWeight/3),min(1,lineWeight/3));
      stroke(yColor);
      line(0,-radius,0,radius);
      ellipse(0,-radius, max(1,lineWeight/3),min(1,lineWeight/3));
      stroke(0);
      ellipseMode(RADIUS);
      ellipse(0,0,2*radius/3,2*radius/3);
    popMatrix();
  }
  
  void drawRotator(){  // display the device to select new angle
    int radius=min(height/4,width/6);
    stroke(0);
    fill(255,255,255,0);
    pushMatrix();
      translate(xPos-radius, yPos+radius);
      stroke(128);
      strokeWeight(max(1,lineWeight/3));
      if(bPrime!=0) line(0,0,0,-radius);
      rotate(bPrime);
      stroke(xColor);
      strokeWeight(lineWeight);
      drawArrow(-radius, 0, 2.0*radius,3*PI/2, lineWeight);
      stroke(yColor);
      drawArrow(0, radius, 2.0*radius,PI, lineWeight);
      stroke(0);
      rotate(-bPrime);
      textAlign(CENTER, CENTER);
      textSize(height/12);
      fill(0);
      text(int(degrees(bPrime)+0.001)+"°",0,4*radius/3);
//      fill(0,255,0);
//      ellipse(-radius/2,2*radius, radius/4, radius/4);
//      fill(255,0,0);
//      ellipse(radius/2,2*radius, radius/4, radius/4);
    popMatrix();
    stroke(0);
    roundArrow(xPos-radius, yPos+radius, 2*radius/3, 0, bPrime);
  }
  
  boolean selectedPressed(int x, int y){
    int dispRadius=max(height/40,15);
    xPos=int(width*0.98);
    yPos=int(height*0.02);
    float r = pow(pow(x-(xPos-dispRadius),2)+pow(y-(yPos+dispRadius),2),0.5);  //click radius
    if (r < dispRadius) {
      return true;
    }
    else return false;
  }
  
  boolean turningPressed(int x, int y){
    int dispRadius=min(height/4,width/6);
    xPos=int(width*0.98);
    yPos=int(height*0.02);
    float r = pow(pow(x-(xPos-dispRadius),2)+pow(y-(yPos+dispRadius),2),0.5);  //click radius
    if (r < int(1.1*dispRadius)) {
      return true;
    }
    else return false;
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
  
  void roundArrow(int xCentre, int yCentre, int radius, float startBearing, float arcAngle){
    //draw arc
    noFill();
    strokeWeight(max(1,lineWeight/3));
    pushMatrix();
      translate(xCentre, yCentre);
      rotate(1.5*PI-startBearing);
      arc(0,0, 2*radius, 2*radius, 0, arcAngle);
      rotate(arcAngle);
      //ellipse(radius,0,10,10);
      line(radius,0,radius*(1+min(0.25,arcAngle/4)),-radius*min(0.25,arcAngle/4));
      line(radius,0,radius*(1-min(0.25,arcAngle/4)),-radius*min(0.25,arcAngle/4));
    popMatrix();
  }
}
