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
      textAlign(CENTER);
      text("Enter "+title, width/2, 8*height/10);
      text(output, width/2, 9*height/10);
      
    }
  }
  
  void addCharacter(char entry){
    if (key==CODED){
      // left and right arrow behaviour here
    } else{
      if ((keyCode==DELETE)||(keyCode==BACKSPACE)){
        testDebug="deleting";
        if (output!=""){
          output=output.substring(0,output.length()-1);
        }
      } else{
        output=output+key;
      }
    }
  }
}
