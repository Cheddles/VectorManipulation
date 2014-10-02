class Slider{
 
 float max;  // maximum on the slider line
 float min;  // minimum value on the slider line
 float value;  // current value
 int xpos;  // x-coordinate of the selection ball
 float ypos;  // y-coordinate of the line and selection ball (proportion of screenheight from top
 int ballDiameter;
 boolean dragging=false;
 boolean mouseOver=true;
 boolean clickedOnce=false;
 int dragOffset;  //horizontal offset of the mouse from the ball centre when dragging
 int xmin;  // left end of slider line
 int xmax;  // right end of slider line
    
 Slider(float minValue, float maxValue, float startValue, float verticalLocation){
   //to make available to methods
   max=maxValue;
   min=minValue;
   ypos=verticalLocation;
   value=startValue;
 }

  void display(){
    int ypix = int(ypos*height);
    stroke(0);
    // recalculate dimensions each time in case window has been resized
    strokeWeight(max(lineWeight/2,1));
    xmin=int(width*0.2);
    xmax=int(width*0.9);
    ballDiameter = int(min(height/20, width/30));
    xpos = int((scale-min)/(max-min)*(xmax-xmin)+xmin);
    
    // display slider
    line(xmin,ypix,xmax,ypix);
    fill(0);
    //if (mouseOver) fill(255);
    ellipseMode(CENTER);
    ellipse(xpos,ypix,ballDiameter,ballDiameter);
    drawArrow();
    
    // display scale marker if being adjusted
    if (dragging){
      fill(255,255,255,180);
      strokeWeight(0);
      rect(0,0,width,height);
      strokeWeight(lineWeight);
      line(((xmax+xmin)/2)-scale/2, ypix-ballDiameter, ((xmax+xmin)/2)+scale/2, ypix-ballDiameter);
      line(((xmax+xmin)/2)-scale/2, ypix-ballDiameter-2*lineWeight, ((xmax+xmin)/2)-scale/2, ypix-ballDiameter+2*lineWeight);
      line(((xmax+xmin)/2)+scale/2, ypix-ballDiameter-2*lineWeight, ((xmax+xmin)/2)+scale/2, ypix-ballDiameter+2*lineWeight);
      textAlign(CENTER);
      textSize(height/20);
      fill(0);
      text("1"+units,((xmax+xmin)/2),ypix-2*ballDiameter);
    }
    
//    // display instructions if slider has not yet been used
//    if (!clickedOnce) {
//      textSize(height*0.028);
//      fill(127);
//      text("drag to change scale (will clear drawn vectors)", (xmin+xmax)/2, ypos-height*0.065);
//    }
  }
  
  boolean clicked(int mx, int my) {
    float d = pow(pow(mx-xpos,2)+pow(my-(ypos*height),2),0.5);
    if (dragging) return true;
    else if (d < ballDiameter) {
      dragging = true;
      clickedOnce=true;
      dragOffset = mx-xpos;
      return true;
    }
    return false;
  }
  
  void drag() {
      int newloc = mouseX - dragOffset;
      //stop out of range dragging
      if (newloc>xmax) newloc=xmax;
      if (newloc<xmin) newloc=xmin;
      
      //convert location to scale value
      scale = float(newloc-xmin)/float(xmax-xmin)*(max-min)+min;
      testDebug=str(scale);
    }
  
//  void hover(int mx, int my) {
//    float d = pow(pow(mx-xpos,2)+pow(my-ypos,2),0.5);
//    if (d < ballDiameter) {
//      mouseOver = true;
//    }
//    else {
//      mouseOver = false;
//    }
//  }
  
  void drawArrow(){
    int ypix = int(ypos*height);
    // draw a red arrow indicating slider motion
    stroke(255,0,0);
    //strokeWeight(10);
    strokeCap(ROUND);
    line(xpos-ballDiameter,ypix,xpos+ballDiameter,ypix);
    line(xpos+ballDiameter,ypix,xpos+ballDiameter*0.7,(ypix-ballDiameter*0.5));
    line(xpos-ballDiameter,ypix,xpos-ballDiameter*0.7,(ypix-ballDiameter*0.5));
    line(xpos+ballDiameter,ypix,xpos+ballDiameter*0.7,(ypix+ballDiameter*0.5));
    line(xpos-ballDiameter,ypix,xpos-ballDiameter*0.7,(ypix+ballDiameter*0.5));
    
    fill(0,0,0,100);
    strokeWeight(0);
    ellipse(xpos,ypix,ballDiameter,ballDiameter);
    strokeWeight(5);
  }
}
