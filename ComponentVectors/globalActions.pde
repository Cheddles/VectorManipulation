// this file contains globally-available-methods for ComponentVectors

void deleteAll(){
    //use current dimensions to clear display
  horizontalSize=width;
  verticalSize=height;
  setup();
}

void deleteCurrentVector(){
  if (selectedCount!=-1){
    vectorCollection.remove(selectedCount);
    if (vectorCollection.size()==0) selectedCount=-1;  //reset the "no vectors" flag
    else if (selectedCount==0) selectedCount=vectorCollection.size()-1;
    else selectedCount--;
    if (selectedCount!=-1){
      currentVector= (Vector) vectorCollection.get(selectedCount);
      currentVector.selected=true;
      vectorCollection.set(selectedCount, currentVector);
    }
  }
}

void previousVector(){
  if (vectorCollection.size()>0){
    currentVector= (Vector) vectorCollection.get(selectedCount);
    currentVector.selected=false;
    //testDebug=testDebug+str(selectedCount) + "set false";
    vectorCollection.set(selectedCount, currentVector);
    if (selectedCount==0) selectedCount=vectorCollection.size()-1;
    else selectedCount--;
    currentVector= (Vector) vectorCollection.get(selectedCount);
    currentVector.selected=true;
    testDebug= str(selectedCount) + " selected of "+str(vectorCollection.size())+"'"+str(degrees(currentVector.bearing))+currentVector.label;
    vectorCollection.set(selectedCount, currentVector);
  }
}

void nextVector(){
  if (vectorCollection.size()>0){
    currentVector= (Vector) vectorCollection.get(selectedCount);
    currentVector.selected=false;
    //testDebug=testDebug+str(selectedCount) + "set false";
    vectorCollection.set(selectedCount, currentVector);
    if (selectedCount==vectorCollection.size()-1) selectedCount=0;
    else selectedCount++;
    currentVector= (Vector) vectorCollection.get(selectedCount);
    currentVector.selected=true;
    testDebug= str(selectedCount) + " selected of "+str(vectorCollection.size())+"'"+str(degrees(currentVector.bearing))+currentVector.label;
    vectorCollection.set(selectedCount, currentVector);
  }
}

void createInverse(){
  if (selectedCount!=-1){
    float tempBearing;
    float tempSize;
    String tempLabel;
    int[] tempScr = new int[2];
    
    currentVector=(Vector) vectorCollection.get(selectedCount);  //pull selected vector from list
    tempScr=currentVector.vectorToScreen(currentVector.xLoc, currentVector.yLoc);
    tempSize=currentVector.value;
    tempLabel=currentVector.label;
    tempBearing=currentVector.bearing+PI;
    if (tempBearing>2*PI) tempBearing=tempBearing-2*PI;
    currentVector.selected=false;
    vectorCollection.set(selectedCount, currentVector);  
    if (tempLabel=="") tempLabel = "unnamed vector";
    vectorCollection.add(new Vector(tempScr[0], tempScr[1], "inverse of "+tempLabel));
    selectedCount=vectorCollection.size()-1;  //select the new vector
    currentVector=(Vector) vectorCollection.get(selectedCount);  //pull new vector from list
    currentVector.forming=false;
    currentVector.bearing=tempBearing;
    currentVector.value=tempSize;
    vectorCollection.set(selectedCount, currentVector);  //push inverted matrix to the end of the list
  }
}

void jump(){ //debugging method to jump a vector 1 unit to the right
  currentVector=(Vector) vectorCollection.get(selectedCount);  //pull selected vector from list
  currentVector.xLoc=currentVector.xLoc+1;
  vectorCollection.set(selectedCount, currentVector);
}
