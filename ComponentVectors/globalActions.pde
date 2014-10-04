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
  currentVector= (Vector) vectorCollection.get(selectedCount);
  currentVector.selected=false;
  testDebug=testDebug+str(selectedCount) + "set false";
  vectorCollection.set(selectedCount, currentVector);
  if (selectedCount==0) selectedCount=vectorCollection.size()-1;
  else selectedCount--;
  currentVector= (Vector) vectorCollection.get(selectedCount);
  currentVector.selected=true;
  testDebug=testDebug+str(selectedCount) + "set true";
  vectorCollection.set(selectedCount, currentVector);
}

void nextVector(){
  currentVector= (Vector) vectorCollection.get(selectedCount);
  currentVector.selected=false;
  testDebug=testDebug+str(selectedCount) + "set false";
  vectorCollection.set(selectedCount, currentVector);
  if (selectedCount==vectorCollection.size()-1) selectedCount=0;
  else selectedCount++;
  currentVector= (Vector) vectorCollection.get(selectedCount);
  currentVector.selected=true;
  testDebug=testDebug+str(selectedCount) + "set true";
  vectorCollection.set(selectedCount, currentVector);
}
