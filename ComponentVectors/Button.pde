class Button{
  
  float xLoc;  //top left corner (in window proportion)
  float yLoc;  //top right corner (in window proportion)
  float propWidth;  //width as proportion of window
  float propHeight;  // height as proportion of window
  String label1;  //label for button
  String label2;  //label for button (second line - leave as "" for single-line button)
  String hoverText;  //text that shows when the mouse is over the button
  boolean selected;  //whether button is selected (persistant toggle)
  color bgActive = color(255,150,255);  // background colour when active
  color bgInactive= color(240);  // background colour when inactive
  color fontActive=color(0);  // font colour when active;
  color fontInactive=color(0);  // font colour when inactive
  
  Button(float x, float y, float wide, float high, String text1, String text2, String mouseOver){
    xLoc=x;
    yLoc=y;
    propWidth=wide;
    propHeight=high;
    label1=text1;
    label2=text2;
    hoverText=mouseOver;
  }
  
  void display(){
    if (selected) fill(bgActive);
    else fill(bgInactive);
    rect(xLoc*width, yLoc*height, propWidth*width, propHeight*height);
    if (selected) fill(fontActive);
    else fill(fontInactive);
    textAlign(CENTER,CENTER);
    if (label2==""){
      textSize(propHeight*height/3);
      text(label1, xLoc*width+propWidth*width/2, yLoc*height+propHeight*height/2);
    }
    else{
      textSize(propHeight*height/4);
      text(label1, xLoc*width+propWidth*width/2, yLoc*height+propHeight*height/3);
      text(label2, xLoc*width+propWidth*width/2, yLoc*height+propHeight*2*height/3);
    }
  }
  
  void hover(int x, int y){
    if ((x>(xLoc*width))&&(x<(xLoc+propWidth)*width)&&(y>yLoc*height)&&(y<(yLoc+propHeight)*height)){
      fill(0);
      textAlign(LEFT, CENTER);
      textSize(propHeight*height/3);
      text(hoverText, (xLoc+propWidth)*width*1.1, (yLoc+propHeight/2)*height);
    }
  }
  
  boolean click(int x, int y){
    if ((x>(xLoc*width))&&(x<(xLoc+propWidth)*width)&&(y>yLoc*height)&&(y<(yLoc+propHeight)*height)){
      if (selected){
        selected=false;
        display();
      }
      else selected=true;
      return true;
    }
    else{
      return false;
    }
  }
}
