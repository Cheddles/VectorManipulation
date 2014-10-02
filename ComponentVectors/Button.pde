class Button{
  
  float xLoc;  //top left corner (in window proportion)
  float yLoc;  //top right corner (in window proportion)
  float propWidth;  //width as proportion of window
  float propHeight;  // height as proportion of window
  String label;  //label for button
  boolean selected;  //whether button is selected (persistant toggle)
  color bgActive = color(100,0,100);  // background colour when active
  color bgInactive= color(240);  // background colour when inactive
  color fontActive=color(0);  // font colour when active;
  color fontInactive=color(0);  // font colour when inactive
  
  Button(float x, float y, float wide, float high, String text){
    xLoc=x;
    yLoc=y;
    propWidth=wide;
    propHeight=high;
    label=text;
  }
  
  void display(){
    if (selected) fill(bgActive);
    else fill(bgInactive);
    rect(xLoc*width, yLoc*height, propWidth*width, propHeight*height);
    if (selected) fill(fontActive);
    else fill(fontInactive);
    textAlign(CENTER,CENTER);
    textSize(propHeight*height/3);
    text(label, xLoc*width+propWidth*width/2, yLoc*height+propHeight*height/2);
  }
  
  boolean click(int x, int y){
    testDebug=str(yLoc*height)+","+str(y)+","+str((yLoc+propHeight)*height);
    if ((x>(xLoc*width))&&(x<(xLoc+propWidth)*width)&&(y>yLoc*height)&&(y<(yLoc+propHeight)*height)){
      selected=true;
      display();
      testDebug="clicked";
      return true;
    }
    else return false;
  }
  
}
