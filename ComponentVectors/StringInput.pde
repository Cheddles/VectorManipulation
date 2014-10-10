class StringInput{
  String title="";  //the name of the text being entered (eg. 
  String output="";
  boolean entering=false;
  
  StringInput(String purpose, String defaultText){
    title=purpose;
    output=defaultText;
  }
  
  void display(){
    if(entering){
      fill(255,255,255,180);
      strokeWeight(0);
      rect(0,0,width,height);
      fill(0);
      textSize(height/20);
      textAlign(LEFT);
      text("Enter "+title, width*0.2, 3*height/4);
      if ((millis()-1000*int(millis()/1000))<500){
        text(output, width*0.2, 0.87*height);
      } else {
        text(output+"|", width*0.2, 0.87*height);
      }
      textSize(height/30);
      fill(100);
      text("Press [Return] or [Enter] to finish or [Escape] to cancel", width*0.2, 8*height/10);

      
      
    }
  }
  
  void addCharacter(char entry){
    if (key==CODED){
      // left and right arrow behaviour here
    } else{
      if ((keyCode==DELETE)||(keyCode==BACKSPACE)){
        if (output.length()==1){
          output="";
        } else if (output!=""){
          output=output.substring(0,output.length()-1);
        }
      } else if ((keyCode == RETURN)||(keyCode == ENTER)){
        accept();
      } else if (keyCode==ESC){
        key=0;
        bLabel.selected=false;
        entering=false;
      } else if ((int(key)>=32)&&(int(key)<=126)) {  // all "regular" characters
        output=output+key;
      }
    }
  }
  
  void accept(){  // accept the current value of output and pass to calling variable
    if (title=="vector label"){
      currentVector.label=output;
      vectorCollection.set(selectedCount, currentVector);
    }
    bLabel.selected=false;
    bUnits.selected=false;
    entering=false;
  }
}
