class AxisAngle{
  int xPos;  // x-coordinate of top right corner
  int yPos;  // y-coordinate of top right corner
  float bPrime=PI/6;  // offset angle (clockwise from straight up)
  float oldAngle;  // previous bPrime (to be used if angle change is cancelled
  boolean selected=false;  // shows and adjustable only when selected
  boolean dragging=false;
  boolean clickedOnce=false;  // if this control has been clicked once (to display control instructions)
  float dragOffset;  // the angle offset when the mouse is clicked to drag
  
  AxisAngle(){
  }
  
  void display(){
    xPos=int(width*0.98);
    yPos=int(height*0.02);
    if (selected){  // mute vectors and display angle adjustment tool (with done and cancel buttons)
          
    }
    
    drawSelect();  // display button to select this tool
    
//    float angle;  // rotation angle required to draw segments and dividing lines
//    strokeWeight(max(1,int(((height+width)/200-denominator*(height+width)/6000)/2)));  // roughly scale line thickness with number of segments
//    stroke(0);
//    // transfer to class variables to make visible to other class methods
//    xpos = xCentre;
//    ypos = yCentre;
//    angle=startAngle;
//    fill(shadedFill);  // start with filled segments
//    
//    if (denominator==1){
//      if (numerator==0) fill(backGround);
//      ellipse(xpos, ypos, diameter, diameter);
//    }
//    else{
//      for(int i=0; i<denominator; i++){
//        if (angle>(2*PI)) angle=angle-(2*PI);  //reset angle once over 2*PI
//        if(i==numerator) fill(backGround);  //switch to "empty" segments
//     
//        arc(xpos, ypos, diameter, diameter, angle, angle+(2*PI/denominator), PIE);
//        angle=angle+(2*PI)/denominator;
//      }
//    }
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
  
//  void clicked(int mx, int my) {
//    float r = pow(pow(mx-xpos,2)+pow(my-ypos,2),0.5);
//    if (((2*r) < diameter)&&(r>10)) {
//      dragging = true;
//      clickedOnce=true;
//      dragOffset = findAngle(mx-xPos, my-yPos)-startAngle;
//      if (dragOffset<0) dragOffset=dragOffset+(2*PI);
//    }
//  }
//  
//  void drag() {
//    startAngle = findAngle(mouseX-xpos, mouseY-ypos) - dragOffset;
//    if (startAngle>(2*PI)) startAngle=startAngle-(2*PI);
//    if (startAngle<0) startAngle=startAngle+(2*PI);
//  }
  
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
      line(-radius,0, radius, 0);
      line(0,-radius,0,radius);
      ellipseMode(RADIUS);
      ellipse(0,0,2*radius/3,2*radius/3);
      stroke(255,0,0);
      ellipse(0,-radius, min(1,lineWeight/3),min(1,lineWeight/3));
    popMatrix();
  }
}
