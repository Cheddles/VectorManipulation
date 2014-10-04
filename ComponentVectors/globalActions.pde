// this file contains globally-available-methods for ComponentVectors

void deleteAll(){
    //use current dimensions to clear display
  horizontalSize=width;
  verticalSize=height;
  setup();
}

void deleteCurrentVector(){
  for (int i=0; i<vectorCollection.size(); i++){
    currentVector= (Vector) vectorCollection.get(i);
    if (currentVector.selected){
      vectorCollection.remove(i);
      i=i-1;  //to account for renumbering a shorter array list
    }
  }
      bDelete.selected=false;
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
