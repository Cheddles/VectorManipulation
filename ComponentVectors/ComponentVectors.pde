Float scale=100.0;  // pixels of screen distance per unit of vector value (initially set to 100)
String units=" m"; // units for the vector (with a leading space)

int horizontalSize=800;  // horizontal size of the screen
int verticalSize=600;  // horizontal size of the screen
int lineWeight;  // weight of component vector
boolean clickedOnce=false; // (will need this per on-screen object)
boolean showComponents=true;  // show component vectors for selected vector
boolean showBearing=false;  // show bearing for selected vector
ArrayList vectorCollection;
//int currentVector;  // current vector number within vectorCollection
Vector currentVector;  // the vector currently selected and being manipulated (pushed into vectorCollection)       
AxisAngle axes;  // tool to select bearing of the reference axes to calculate component vectors
color yColor = color(0,0,255);  // colour of y and y' component vectors
color xColor = color(0,180,0);  // colour of x and x' component vectors
color activeColor = color(255,0,0);  // colour of currently-selected vector
color baseColor = color(0);  // default colour of non-selected vector

String testDebug="testing";

void setup(){
 size(horizontalSize,verticalSize);
 if (frame != null) {
    frame.setResizable(true);
 }
//  totalVector = new Arrow (0, 0, 0, lineWeight);
//  verticalComponent = new Arrow (255, 0, 0, lineWeight);
//  horizontalComponent = new Arrow (0, 0, 255, lineWeight);
vectorCollection = new ArrayList();
axes = new AxisAngle();
//currentVector = new Vector();
}

void draw(){
  lineWeight = max(2,int(float(horizontalSize)/100.0));  // set line weight for all vector arrows
  background(255);
  rect(100,100,100,100);

  if (vectorCollection.size()>0){
    currentVector= (Vector) vectorCollection.get(vectorCollection.size()-1);
    if(currentVector.forming) {
      //currentVector.colour = color(255,0,0);
      currentVector.create(mouseX, mouseY);
    }
    vectorCollection.set(vectorCollection.size()-1, currentVector);
    //currentVector.display();
    for (int i=0; i<vectorCollection.size(); i++){
      currentVector= (Vector) vectorCollection.get(i);
      currentVector.display();
    }
  }

  else{
    textSize(height/10);
    fill(0);
    textAlign(CENTER, CENTER);
    pushMatrix();
      translate(width/2, height/2);
      text("Click anywhere to locate", 0, -height/4);
      text("a vector then drag to give", 0, 0);
      text("it length and direction", 0, height/4);
    popMatrix();
  }
  
  // assign attribution and provide link for feedback
  fill(0);
  textSize(height/40);
  textAlign(LEFT, TOP);
  text(testDebug, height/50, height/80);
  //text("Suggestions and feedback to Chris.Heddles@asms.sa.edu.au", height/50, height/80);
  
  axes.drag();
  axes.display(); 
}

void mousePressed(){
  boolean foundSomething=false;  // switch to draw a new vector if nothing else is being clicked
  foundSomething = axes.clicked(mouseX,mouseY);
  if ((vectorCollection.size()>0)&&(!foundSomething)){  //don't do this check if there are no vectors drawn yet
    for (int i=0; i<vectorCollection.size(); i++){
      currentVector= (Vector) vectorCollection.get(i);
      foundSomething=currentVector.click(mouseX, mouseY);  //select a vector if clicked on and stop new vector creation
      vectorCollection.set(i, currentVector);
    }
  }
//  if(axes.selectedPressed(mouseX, mouseY) || axes.selected){  // only look at vectors if the rotation tool is not being used
//    
//  }
  if (!foundSomething){  // start new vector
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
  for (int i=0; i<vectorCollection.size(); i++){
    currentVector= (Vector) vectorCollection.get(i);
    currentVector.dragging=false;
    currentVector.forming=false;
    vectorCollection.set(i, currentVector);
  }
}
