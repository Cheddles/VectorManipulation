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
      text("Click anywhere and drag", 0, -height/4);
      text("to display displacement", 0, 0);
      text("vectors from centre", 0, height/4);
    popMatrix();
  }
  
  // assign attribution and provide link for feedback
  fill(0);
  textSize(height/40);
  textAlign(LEFT, TOP);
  text("Suggestions and feedback to Chris.Heddles@asms.sa.edu.au", height/50, height/80);
  
  axes.display();
}

void mousePressed(){
  axes.clicked(mouseX,mouseY);
  if(axes.selectedPressed(mouseX, mouseY)){  // check all existing vectors for dragging/selection
  }
  else{  // start new vector
    if (vectorCollection.size()>0){  // deselect the previously-selected vector
      currentVector = (Vector) vectorCollection.get(vectorCollection.size()-1);
      currentVector.selected=false;
      vectorCollection.set(vectorCollection.size()-1, currentVector);
    }
    vectorCollection.add(new Vector(mouseX, mouseY));
  }
}

void mouseReleased(){
  for (int i=0; i<vectorCollection.size(); i++){
    currentVector= (Vector) vectorCollection.get(i);
    currentVector.dragging=false;
    currentVector.forming=false;
    vectorCollection.set(i, currentVector);
  }
}
