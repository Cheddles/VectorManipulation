Float scale;  // pixels of screen distance per unit of vector value (initially set to 100)
String units; // units for the vector (with a leading space)

int horizontalSize=800;  // horizontal size of the screen
int verticalSize=600;  // horizontal size of the screen
int lineWeight;  // weight of component vector
boolean clickedOnce=false; // (will need this per on-screen object)
//boolean showComponents=true;  // show component vectors for selected vector
//boolean showBearing=false;  // show bearing for selected vector
ArrayList vectorCollection;
//int currentVector;  // current vector number within vectorCollection
Vector currentVector;  // the vector currently selected and being manipulated (pushed into vectorCollection)       
AxisAngle axes;  // tool to select bearing of the reference axes to calculate component vectors
Slider zoom;  // scaling slider
color yColor = color(0,0,255);  // colour of y and y' component vectors
color xColor = color(0,180,0);  // colour of x and x' component vectors
color activeColor = color(255,0,0);  // colour of currently-selected vector
color baseColor = color(0);  // default colour of non-selected vector

Button bClear;  //clear all button
Button bDelete;  //delete current selection button
Button bShowComp;  // show/hide component vectors for selected vector
Button bShowBearing;  // show/hide bearing for selected vector

String testDebug="deBug deFault";

void setup(){
 size(horizontalSize,verticalSize);
 if (frame != null) {
    frame.setResizable(true);
 }
  scale=200.0;
  units=" N";
  vectorCollection = new ArrayList();
  axes = new AxisAngle();
  zoom = new Slider(10.0, 700.0, scale, 0.95);
  bClear = new Button(0.0, 0.0, 1/9.0, 1/12.0, "Clear","all", "Start new free body diagram");
  bDelete = new Button(0.0, 1/12.0, 1/9.0, 1/12.0, "Delete","selected", "Delete the selected item");
  bShowComp = new Button(0.0, 2/12.0, 1/9.0, 1/12.0, "Show", "components", "Show component vectors for the active vector");
  bShowComp.selected=true;
  bShowBearing = new Button(0.0, 3/12.0, 1/9.0, 1/12.0, "Show", "bearing", "Show bearing for the active vector");
  bShowBearing.selected=false;
  //currentVector = new Vector();
}

void draw(){
  lineWeight = max(2,int(float(horizontalSize)/100.0));  // set line weight for all vector arrows
  background(255);

  // display button controls
  bClear.display();
  bDelete.display();
  bShowComp.display();
  bShowBearing.display();
  
  // display mouseover text if mouse is over any buttons
  if (mouseX<=width/9){  // only check if the mouse is over the button column
    bClear.hover(mouseX, mouseY);
    bDelete.hover(mouseX, mouseY);
    bShowComp.hover(mouseX, mouseY);
    bShowBearing.hover(mouseX, mouseY);
    //b###.hover(mouseX, mouseY);
  }

  if (vectorCollection.size()>0){
    currentVector= (Vector) vectorCollection.get(vectorCollection.size()-1);
    if(currentVector.forming) {
      currentVector.create(mouseX, mouseY);
    }
    else if (currentVector.dragging) currentVector.move(mouseX, mouseY);
    vectorCollection.set(vectorCollection.size()-1, currentVector);
    //currentVector.display();
    for (int i=0; i<vectorCollection.size(); i++){
      currentVector= (Vector) vectorCollection.get(i);
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
  
  // assign attribution and provide link for feedback
  pushMatrix();
    translate(int(width*0.99),int(height*0.98));
    rotate(PI/2);
    fill(0);
    textSize(height/40);
    textAlign(RIGHT, TOP);
    //text(testDebug, 0, 0);
    text("Suggestions and feedback to Chris.Heddles@asms.sa.edu.au", 0, 0);
  popMatrix();
  
  if (zoom.dragging) zoom.drag();
  zoom.display();
  axes.drag();
  axes.display();
  //rect(0,0,width/10,height/9);
}

void mousePressed(){
  boolean foundSomething=false;  // switch to draw a new vector if nothing else is being clicked
  
  // check for button clicks
  if (mouseX<=width/9){  // only check for button clicks if the mouse is over the button column
    if(bClear.click(mouseX, mouseY)){  //check clear button
      foundSomething=true;
      //use current dimensions to clear display
      horizontalSize=width;
      verticalSize=height;
      setup();
    }
    
    if(bDelete.click(mouseX, mouseY)){  //check delete button
      foundSomething=true;
      for (int i=0; i<vectorCollection.size(); i++){
        currentVector= (Vector) vectorCollection.get(i);
        if (currentVector.selected){
          vectorCollection.remove(i);
          i=i-1;  //to account for renumbering a shorter array list
        }
      }
      bDelete.selected=false;
    }
    
    if(bShowComp.click(mouseX, mouseY)){  //check show components button
      foundSomething=true;
    }
    
    if(bShowBearing.click(mouseX, mouseY)){  //check show components button
      foundSomething=true;
    }
  }
  
  if (!foundSomething) foundSomething = axes.clicked(mouseX,mouseY);
  if ((!axes.selected)&&(!foundSomething)) foundSomething = zoom.clicked(mouseX, mouseY);
  if ((vectorCollection.size()>0)&&(!foundSomething)){  //don't do this check if there are no vectors drawn yet
    for (int i=0; i<vectorCollection.size(); i++){
      currentVector= (Vector) vectorCollection.get(i);
      foundSomething=currentVector.click(mouseX, mouseY);  //select a vector if clicked on and stop new vector creation
      if (foundSomething){  //reshuffle vectors to put selected vector at end of arraylist
        Vector currentVector2 = new Vector(0,0);
        for (int j=i+1; j<vectorCollection.size(); j++){
          currentVector2 = (Vector) vectorCollection.get(j);
          currentVector2.selected=false;
          vectorCollection.set(j-1, currentVector2);
        }
        vectorCollection.set(vectorCollection.size()-1, currentVector);  //put currentVector last
      }
      else {
        currentVector.selected=false;
        vectorCollection.set(i, currentVector);
      }
    }
  }
  if ((!foundSomething)&&(!axes.selected)){  // start new vector
    if (vectorCollection.size()>0){  // deselect the previously-selected vector
      currentVector = (Vector) vectorCollection.get(vectorCollection.size()-1);
      currentVector.selected=false;
      vectorCollection.set(vectorCollection.size()-1, currentVector);
    }
    vectorCollection.add(new Vector(mouseX, mouseY));
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
