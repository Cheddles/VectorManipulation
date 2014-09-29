// from main


//// set up arrows for each vector (red, green, blue, line weight)
//Arrow totalVector = new Arrow (0, 0, 0, lineWeight);
//Arrow verticalComponent = new Arrow (255, 0, 0, lineWeight);
//Arrow horizontalComponent = new Arrow (0, 0, 255, lineWeight);

// Set up a switch for whether the mouse button is down (and hence if the arrows should be drawn)
// boolean clicked=false;  // true if mouse button is down (or screen is being touched)
//int startX;
//int startY;

// ---------------------------------------------------------

//  if (clicked){
//    // Draw arrows
//    horizontalComponent.display(startX, startY, mouseX, startY);
//    verticalComponent.display(mouseX, startY, mouseX, mouseY);
//    totalVector.display(startX, startY, mouseX, mouseY); // draw this last to display on top
//    
//    // calculate vector values
//    String totalValue = String.format("%.2f", pow(pow(mouseX-startX,2)+pow(mouseY-startY,2),0.5)/scale);
//    String verticalValue = String.format("%.2f", abs(float(startY-mouseY)/scale));
//    String horizontalValue = String.format("%.2f", abs(float(startX-mouseX)/scale));

//    // determine horizontal component directions
//    String horizontalDirection=" right";
//    if (mouseX<startX) horizontalDirection=" left";
//    else if (mouseX==startX) horizontalDirection="";

//    // set display height to empty half of the screen and determine vertical component direction
//    int textTop = int(float(height)/10);
//    String verticalDirection = " down";
//    if (mouseY<startY){
//      textTop = int(6*float(height)/10);
//      verticalDirection = " up";
//    }
    
//    int textTop=int(height/3);
    
//    // display vector values (colour coded to match vector arrows)
//    textSize(int(float(height/20)));
//    textAlign(CENTER, TOP);
//    fill(totalVector.colour[0],totalVector.colour[1],totalVector.colour[2]);
//    text("Total vector="+totalValue+units, width/2, textTop);
//    fill(verticalComponent.colour[0],verticalComponent.colour[1],verticalComponent.colour[2]);
//    text("Vertical component="+verticalValue+units+verticalDirection, width/2, textTop+(verticalSize/12));
//    fill(horizontalComponent.colour[0],horizontalComponent.colour[1],horizontalComponent.colour[2]);
//    text("Horizontal component="+horizontalValue+units+horizontalDirection, width/2, textTop+(verticalSize/6));
//  }
