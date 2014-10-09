Float scale;  // pixels of screen distance per unit of vector value (initially set to 100)
String units; // units for the vector (with a leading space)

int horizontalSize=800;  // horizontal size of the screen
int verticalSize=600;  // horizontal size of the screen

int lineWeight;  // weight of component vector
boolean clickedOnce=false; // (will need this per on-screen object)
ArrayList vectorCollection;
int selectedCount=-1;  // current vector number within vectorCollection
Vector currentVector;  // the vector currently selected and being manipulated (pushed into vectorCollection)
Vector currentVector2;  // another holding vector;
AxisAngle axes;  // tool to select bearing of the reference axes to calculate component vectors
Slider zoom;  // scaling slider
color yColor = color(0,0,255);  // colour of y and y' component vectors
color xColor = color(0,180,0);  // colour of x and x' component vectors
color activeColor = color(255,0,0);  // colour of currently-selected vector
color baseColor = color(0);  // default colour of non-selected vector

// define buttons
float buttonHeight=1/12.0;  // standard button height as a proportion of the window
float buttonWidth=1/9.0;  //standard button width as a proportion of the window
Button bClear;  // start again
Button bDelete;  // delete current vector
Button bShowComp;  // show/hide component vectors for selected vector
Button bShowBearing;  // show/hide bearing for selected vector
Button bPrev;  // select previous vector
Button bNext;  // select next vector
Button bInverse;  //create inverse (negative) vector
Button bLabel;  //edit vector label
Button bUnits;  //enter system units
StringInput getText;  // = new StringInput;  //string input tool for vector labels
// StringInput getUnits = new StringInput;  //string input tool for vector labels

String testDebug="deBug deFault";

void setup(){
 size(horizontalSize,verticalSize);
 if (frame != null) {
    frame.setResizable(true);
 }
  scale=200.0;
  units=" N";
  vectorCollection = new ArrayList();
  getText = new StringInput("title", "default");
  axes = new AxisAngle();
  zoom = new Slider(10.0, 700.0, scale, 0.95);
  bClear = new Button(0*buttonWidth, 0*buttonHeight, buttonWidth, buttonHeight, "Clear","all", "Start new free body diagram");
  bDelete = new Button(0*buttonWidth, 1*buttonHeight, buttonWidth, buttonHeight, "Delete","selected", "Delete the selected item");
  bShowComp = new Button(0*buttonWidth, 2*buttonHeight, buttonWidth, buttonHeight, "Show", "components", "Show component vectors for the active vector");
  bShowComp.selected=true;
  bShowBearing = new Button(0*buttonWidth, 3*buttonHeight, buttonWidth, buttonHeight, "Show", "bearing", "Show bearing for the active vector");
  bShowBearing.selected=false;
  bPrev = new Button(0*buttonWidth, 4*buttonHeight, 0.5*buttonWidth, buttonHeight, "Prev", "<-", "Select previous vector");
  bNext = new Button(0.5*buttonWidth, 4*buttonHeight, 0.5*buttonWidth, buttonHeight, "Next", "->", "Select next vector");
  bInverse = new Button(0*buttonWidth, 5*buttonHeight, buttonWidth, buttonHeight, "Create", "inverse", "Create an inverse of the selected vector");
  bLabel = new Button(0*buttonWidth, 6*buttonHeight, buttonWidth, buttonHeight, "Label", "", "Edit vector label");
  bUnits = new Button(0*buttonWidth, 7*buttonHeight, buttonWidth, buttonHeight, "Units", "", "Enter units (changes for all vectors)");
  //currentVector = new Vector();
}

void draw(){
  lineWeight = max(2,int(float(width/150)));  // set line weight for all vector arrows
  background(255);

  // display button controls
  bClear.display();
  bDelete.display();
  bShowComp.display();
  bShowBearing.display();
  bPrev.display();
  bNext.display();
  bInverse.display();
  bLabel.display();
  bUnits.display();
  
 if (vectorCollection.size()>0){
    currentVector= (Vector) vectorCollection.get(vectorCollection.size()-1);
    if(currentVector.forming) {
      currentVector.create(mouseX, mouseY);
    }
    vectorCollection.set(vectorCollection.size()-1, currentVector);
    //currentVector.display();
    for (int i=0; i<vectorCollection.size(); i++){
      currentVector= (Vector) vectorCollection.get(i);
      if (currentVector.dragging){
        currentVector.move(mouseX, mouseY);
        vectorCollection.set(i, currentVector);
      }
      //testDebug=testDebug+" "+str(i)+" ";
      currentVector.display();
    }
  }

  else{
    textSize(height/12);
    fill(0);
    textAlign(CENTER, CENTER);
    pushMatrix();
      translate(width*5/9, height/2);
      text("Click anywhere to locate", 0, -height/4);
      text("a vector then drag to give", 0, -height/16);
      text("it length and direction", 0, height/8);
    popMatrix();
  }
  if (getText.entering){
    getText.display();
  }
  // display mouseover text if mouse is over any buttons
  else if (mouseX<=width/9){  // only check if the mouse is over the button column
    bClear.hover(mouseX, mouseY);
    bDelete.hover(mouseX, mouseY);
    bShowComp.hover(mouseX, mouseY);
    bShowBearing.hover(mouseX, mouseY);
    bPrev.hover(mouseX, mouseY);
    bNext.hover(mouseX, mouseY);
    bInverse.hover(mouseX, mouseY);
    bLabel.hover(mouseX, mouseY);
    bUnits.hover(mouseX, mouseY);
  }
  
  
  // assign attribution and provide link for feedback
  pushMatrix();
    translate(int(width*0.99),int(height*0.98));
    rotate(PI/2);
    fill(0);
    textSize(height/40);
    textAlign(RIGHT, TOP);
    text(testDebug, 0, 0);
    //text("Suggestions and feedback to Chris.Heddles@asms.sa.edu.au", 0, 0);
  popMatrix();
  
  if (zoom.dragging) zoom.drag();
  zoom.display();
  axes.drag();
  axes.display();
  //rect(0,0,width/10,height/9);
}

void mousePressed(){
  testDebug="";
  boolean foundSomething=false;  // switch to draw a new vector if nothing else is being clicked
  
  // check for button clicks
  if (mouseX<=width/9){  // only check for button clicks if the mouse is over the button column
    if(bClear.click(mouseX, mouseY)){  //check clear button
      foundSomething=true;
      deleteAll();
    }
    
    if(bDelete.click(mouseX, mouseY)){  //check delete button
      foundSomething=true;
      deleteCurrentVector();
      bDelete.selected=false;
    }
    
    if(bShowComp.click(mouseX, mouseY)){  //check show components button
      foundSomething=true;
    }
    
    if(bShowBearing.click(mouseX, mouseY)){  //check show components button
      foundSomething=true;
    }
    
    if(bPrev.click(mouseX, mouseY)){  //check previous vector button
      foundSomething=true;
      previousVector();
      bPrev.selected=false;
    }
    
    if(bNext.click(mouseX, mouseY)){  //check previous vector button
      foundSomething=true;
      nextVector();
      bNext.selected=false;
    }
    
    if(bInverse.click(mouseX, mouseY)){  //check previous vector button
      //testDebug="inverting";
      foundSomething=true;
      createInverse();
      bInverse.selected=false;
    }
    
    if(bLabel.click(mouseX, mouseY)&&(selectedCount>0)){  //check show components button
      foundSomething=true;
      currentVector= (Vector) vectorCollection.get(selectedCount);
      getText=new StringInput("vector label", currentVector.label);
    }
    
    if(bUnits.click(mouseX, mouseY)){  //check show components button
      foundSomething=true;
    }
  }
  
  if (!foundSomething) foundSomething = axes.clicked(mouseX,mouseY);
  if ((!axes.selected)&&(!foundSomething)) foundSomething = zoom.clicked(mouseX, mouseY);
  if ((vectorCollection.size()>0)&&(!foundSomething)){  //don't do this check if there are no vectors drawn yet
    for (int i=0; i<vectorCollection.size(); i++){
      currentVector= (Vector) vectorCollection.get(i);
      currentVector.selected=false;
      if (!foundSomething){  //only check for clicks if a vector hasn't already been selected
        testDebug=testDebug+str(i)+", ";
        foundSomething=currentVector.click(mouseX, mouseY);  //select a vector if clicked on and stop new vector creation
        //testDebug=testDebug+"found vector "+str(i);
         if (foundSomething){
          selectedCount=i;  //note which vector is selected
        }
      }
      vectorCollection.set(i, currentVector);
    }
  }
  if ((!foundSomething)&&(!axes.selected)){  // start new vector
    if (selectedCount!=-1){  // deselect the previously-selected vector
      currentVector = (Vector) vectorCollection.get(vectorCollection.size()-1);
      currentVector.selected=false;
      vectorCollection.set(vectorCollection.size()-1, currentVector);
    }
    vectorCollection.add(new Vector(mouseX, mouseY, "vector"));
    //testDebug="makingNew";
    selectedCount=vectorCollection.size()-1;
  }
}

void mouseReleased(){
  axes.dragging=false;
  zoom.dragging=false;
  for (int i=0; i<vectorCollection.size(); i++){
    currentVector= (Vector) vectorCollection.get(i);
    currentVector.dragging=false;
    currentVector.forming=false;
    vectorCollection.set(i, currentVector);
  }
}

void keyPressed() {
  if (getText.entering){
    getText.addCharacter(key);
  }
  else{
    if (key==CODED){
      if (keyCode == LEFT){
        previousVector();
      }
      if (keyCode == RIGHT){
        nextVector();
      }
    }
    if ((keyCode == RETURN)||(keyCode == ENTER)||(keyCode==TAB)){
      nextVector();
    }
    if (keyCode == ESC){
        key=0;  //stop the program closing down entirely
        axes.selected=false;
    }
    if ((keyCode == BACKSPACE)||(keyCode == DELETE)) {
      deleteCurrentVector();
    }
  }
    
//  if (keyCode == BACKSPACE) {
//    if (myText.length() > 0) {
//      myText = myText.substring(0, myText.length()-1);
//    }
//  } else if (keyCode == DELETE) {
//    myText = "";
//  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
//    myText = myText + key;
//  }
}
